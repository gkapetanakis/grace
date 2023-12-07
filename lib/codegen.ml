(* initialize llvm *)
Llvm_all_backends.initialize ()

let init_codegen filename =
  (* essential objects required by llvm *)
  let context = Llvm.create_context () in
  let the_module = Llvm.create_module context filename in
  let builder = Llvm.builder context in

  (* llvm types that correspond to grace types *)
  let i8_t = Llvm.i8_type context in
  let i32_t = Llvm.i32_type context in
  let void_t = Llvm.void_type context in

  (* llvm constants that correspond to grace constants *)
  let c8 = Llvm.const_int i8_t in
  let c32 = Llvm.const_int i32_t in

  (* architecture, vendor, operating system *)
  let triple = Llvm_target.Target.default_triple () in

  (* abstract target to build for *)
  let target = Llvm_target.Target.by_triple triple in

  (* real target machine to build for *)
  let machine = Llvm_target.TargetMachine.create ~triple target in
  let data_layout = Llvm_target.TargetMachine.data_layout machine in

  (* set parameters *)
  Llvm.set_target_triple triple the_module;
  Llvm.set_data_layout (Llvm_target.DataLayout.as_string data_layout) the_module;

  (* declare the runtime library *)
  let declare_runtime_func (name, ret_type, args) =
    let ft = Llvm.function_type ret_type (Array.of_list args) in
    ignore (Llvm.declare_function name ft the_module)
  in
  List.iter declare_runtime_func
    [
      ("writeInteger", void_t, [ i32_t ]);
      ("writeChar", void_t, [ i8_t ]);
      ("writeString", void_t, [ Llvm.pointer_type i8_t ]);
      ("readInteger", i32_t, []);
      ("readChar", i8_t, []);
      ("readString", void_t, [ i32_t; Llvm.pointer_type i8_t ]);
      ("ascii", i32_t, [ i8_t ]);
      ("chr", i8_t, [ i32_t ]);
      ("strlen", i32_t, [ Llvm.pointer_type i8_t ]);
      ("strcmp", i32_t, [ Llvm.pointer_type i8_t; Llvm.pointer_type i8_t ]);
      ("strcpy", void_t, [ Llvm.pointer_type i8_t; Llvm.pointer_type i8_t ]);
      ("strcat", void_t, [ Llvm.pointer_type i8_t; Llvm.pointer_type i8_t ]);
    ];

  let lltype_of_scalar = function
    | Ast.Int -> i32_t
    | Ast.Char -> i8_t
    | Ast.Nothing -> void_t
  in

  let lltype_of_data_type = function
    | Ast.Scalar s -> lltype_of_scalar s
    | Ast.Array (s, dims) ->
        let rec aux s d =
          match d with
          | [] -> lltype_of_scalar s
          | hd :: tl -> Llvm.array_type (aux s tl) (Option.get hd)
        in
        aux s dims
  in

  (* just the var type (no pointers) *)
  let lltype_of_var_def (vd : Ast.var_def) = lltype_of_data_type vd.var_type in

  (*
  by value -> parameter type (no pointer)
  by reference -> pointer to parameter type (scalar) or pointer to parameter element type (array)
*)
  let lltype_of_param_def (pd : Ast.param_def) =
    match pd.pass_by with
    | Ast.Value -> lltype_of_data_type pd.param_type
    | Ast.Reference -> (
        match pd.param_type with
        | Ast.Array (s, _ :: tl) ->
            Llvm.pointer_type (lltype_of_data_type (Ast.Array (s, tl)))
        | _ -> Llvm.pointer_type (lltype_of_data_type pd.param_type))
  in

  let get_parent_frame_type_ptr_option (func : Ast.func) =
    let parent_frame_name = Ast.get_parent_frame_name func in
    match Llvm.type_by_name the_module parent_frame_name with
    | Some frame -> Some (Llvm.pointer_type frame)
    | None -> None
  in

  let get_frame_type_ptr (func : Ast.func) =
    let frame_name = Ast.get_frame_name func in
    match Llvm.type_by_name the_module frame_name with
    | Some frame -> Llvm.pointer_type frame
    | None ->
        raise
          (Error.Internal_compiler_error ("Frame type not found: " ^ frame_name))
  in

  let _get_all_frame_type_ptrs (Ast.MainFunc main_func : Ast.program) =
    let rec aux (acc : Llvm.lltype list) (funcs : Ast.func list list) =
      match funcs with
      | [] -> List.rev acc
      | [] :: tl -> aux acc tl
      | (hd :: tl1) :: tl2 ->
          let _, _, local_func_defs = Ast.reorganize_local_defs hd.local_defs in
          aux (get_frame_type_ptr hd :: acc) (local_func_defs :: tl1 :: tl2)
    in
    aux [] [ [ main_func ] ]
  in

  let gen_frame_type (func : Ast.func) =
    let parent_frame_type_ptr =
      match get_parent_frame_type_ptr_option func with
      | Some ptr -> [ ptr ]
      | None -> []
    in
    let param_lltypes = List.map lltype_of_param_def func.params in
    let local_var_defs, _, _ = Ast.reorganize_local_defs func.local_defs in
    let local_var_lltypes = List.map lltype_of_var_def local_var_defs in
    let frame_name = Ast.get_frame_name func in
    let frame_field_types =
      Array.of_list (parent_frame_type_ptr @ param_lltypes @ local_var_lltypes)
    in
    let frame_type = Llvm.named_struct_type context frame_name in
    Llvm.struct_set_body frame_type frame_field_types false
  in

  let gen_all_frame_types (Ast.MainFunc main_func : Ast.program) =
    let rec aux (func : Ast.func) =
      gen_frame_type func;
      let _, _, local_func_defs = Ast.reorganize_local_defs func.local_defs in
      List.iter aux local_func_defs
    in
    aux main_func
  in

  let rec get_frame_ptr fr_ptr hops =
    match hops with
    | 0 -> fr_ptr
    | hops ->
        let link_ptr = Llvm.build_struct_gep fr_ptr 0 "link_ptr" builder in
        let link = Llvm.build_load link_ptr "link" builder in
        get_frame_ptr link (hops - 1)
  in

  let rec gen_simple_l_value frame caller_path (slv : Ast.simple_l_value) =
    match slv with
    | Ast.Id l_val_id -> gen_l_val_id frame caller_path l_val_id
    | Ast.LString Ast.{ id; _ } ->
        let str = Llvm.build_global_string id "str" builder in
        Llvm.build_struct_gep str 0 "str_ptr" builder
    (* returns i8* - matches how parameters are passed, because global strings
       are only passed by reference as parameters *)
  and gen_l_value frame caller_path (lv : Ast.l_value) =
    match lv with
    | Ast.Simple slv -> gen_simple_l_value frame caller_path slv
    | Ast.ArrayAccess { simple_l_value = slv; exprs = e_l; _ } ->
        let l_val_ptr = gen_simple_l_value frame caller_path slv in
        let expr_values_list = List.map (gen_expr frame caller_path) e_l in
        let idx =
          match slv with
          | Ast.Id { passed_by; data_type; _ } -> (
              match (passed_by, data_type) with
              | Ast.Reference, Ast.Array _ ->
                  [] (* both reference AND array causes problems *)
              | _, _ -> [ c32 0 ])
          | Ast.LString _ -> []
        in
        let expr_values_list = idx @ expr_values_list in
        let e_v_array = Array.of_list expr_values_list in
        Llvm.build_gep l_val_ptr e_v_array "array_access" builder
  and gen_l_val_id frame caller_path (l_val_id : Ast.l_value_id) =
    let Ast.{ id; passed_by; frame_offset; parent_path; _ } = l_val_id in
    let hops = List.length caller_path - List.length parent_path in
    let frame_ptr = get_frame_ptr frame hops in
    let element_ptr =
      Llvm.build_struct_gep frame_ptr frame_offset "element_ptr" builder
    in
    match passed_by with
    | Ast.Value -> element_ptr
    | Ast.Reference -> Llvm.build_load element_ptr id builder
  and gen_func_arg frame caller_path ((e, pb) : Ast.expr * Ast.pass_by) =
    match pb with
    | Ast.Value -> gen_expr frame caller_path e
    | Ast.Reference -> (
        let l_v =
          match e with
          | Ast.LValue l_v -> l_v
          | _ ->
              raise
                (Error.Internal_compiler_error
                   "Cannot pass by reference a non-lvalue")
        in
        match l_v with
        | Ast.Simple (Ast.Id l_val_id) -> (
            let Ast.{ passed_by; data_type; _ } = l_val_id in
            match (passed_by, data_type) with
            | Ast.Value, Ast.Array _ ->
                let l_val_ptr = gen_l_value frame caller_path l_v in
                Llvm.build_gep l_val_ptr [| c32 0; c32 0 |] "array_ptr" builder
                (*
          Llvm.build_struct_gep l_val_ptr 0 "array_ptr" builder
          PROBABLY EQUIVALENT CODE, MIGHT CHECK LATER  
        *)
            | _ -> gen_l_value frame caller_path l_v)
        | Ast.Simple (Ast.LString _) -> gen_l_value frame caller_path l_v
        | Ast.ArrayAccess Ast.{ simple_l_value = lv; exprs = e_l; _ } -> (
            match lv with
            | Ast.Id { passed_by; data_type; _ } -> (
                match (passed_by, data_type) with
                | Ast.Value, Ast.Array (_, dims) ->
                    if List.length dims > List.length e_l then
                      let l_val_ptr = gen_l_value frame caller_path l_v in
                      Llvm.build_gep l_val_ptr
                        [| c32 0; c32 0 |]
                        "array_ptr" builder
                    else gen_l_value frame caller_path l_v
                | _ -> gen_l_value frame caller_path l_v)
            | _ -> gen_l_value frame caller_path l_v))
  and gen_func_call frame caller_path (func_call : Ast.func_call) =
    let func_decl =
      match
        Llvm.lookup_function
          (Ast.get_proper_func_call_name func_call)
          the_module
      with
      | Some func_decl -> func_decl
      | None ->
          raise
            (Error.Internal_compiler_error
               ("Function declaration not found: "
               ^ Ast.get_proper_func_call_name func_call))
    in
    let func_args = List.map (gen_func_arg frame caller_path) func_call.args in
    let frame_ptr =
      if Array.length (Llvm.params func_decl) = List.length func_call.args then
        []
      else
        let hops =
          List.length caller_path - List.length func_call.callee_path
        in
        [ get_frame_ptr frame hops ]
    in
    let func_args = frame_ptr @ func_args in
    let ll_local_var_name =
      if func_call.ret_type = Ast.Nothing then ""
        (* void returns shouldn't be named *)
      else "func_call_" ^ func_call.id
    in
    Llvm.build_call func_decl (Array.of_list func_args) ll_local_var_name
      builder
  and gen_expr frame caller_path (e : Ast.expr) =
    match e with
    | Ast.LitInt { value; _ } -> c32 value
    | Ast.LitChar { value; _ } -> c8 (Char.code value)
    | Ast.LValue l_value ->
        let ptr = gen_l_value frame caller_path l_value in
        Llvm.build_load ptr "l_value" builder
    | Ast.EFuncCall fc -> gen_func_call frame caller_path fc
    | Ast.UnAritOp (op, expr) -> (
        let rhs = gen_expr frame caller_path expr in
        match op with
        | Ast.Pos -> rhs
        | Ast.Neg -> Llvm.build_neg rhs "neg" builder)
    | Ast.BinAritOp (expr1, op, expr2) -> (
        let lhs = gen_expr frame caller_path expr1 in
        let rhs = gen_expr frame caller_path expr2 in
        match op with
        | Ast.Add -> Llvm.build_add lhs rhs "add" builder
        | Ast.Sub -> Llvm.build_sub lhs rhs "sub" builder
        | Ast.Mul -> Llvm.build_mul lhs rhs "mul" builder
        | Ast.Div -> Llvm.build_sdiv lhs rhs "div" builder
        | Ast.Mod -> Llvm.build_srem lhs rhs "mod" builder)
  in

  let rec gen_cond frame caller_path (cond : Ast.cond) =
    match cond with
    | Ast.UnLogicOp (op, cond) -> (
        match op with
        | Ast.Not ->
            let rhs = gen_cond frame caller_path cond in
            Llvm.build_not rhs "not" builder)
    | Ast.BinLogicOp (cond1, op, cond2) ->
        let lhs = gen_cond frame caller_path cond1 in
        let lhs_block = Llvm.insertion_block builder in
        let func = Llvm.block_parent lhs_block in
        let rhs_block = Llvm.append_block context "rhs" func in
        let merge_block = Llvm.append_block context "merge" func in
        let _ =
          match op with
          | Ast.And -> Llvm.build_cond_br lhs rhs_block merge_block builder
          | Ast.Or -> Llvm.build_cond_br lhs merge_block rhs_block builder
        in
        Llvm.position_at_end rhs_block builder;
        let rhs = gen_cond frame caller_path cond2 in
        let _ = Llvm.build_br merge_block builder in
        Llvm.position_at_end merge_block builder;
        Llvm.build_phi [ (lhs, lhs_block); (rhs, rhs_block) ] "phi" builder
    | Ast.CompOp (expr1, op, expr2) -> (
        let lhs = gen_expr frame caller_path expr1 in
        let rhs = gen_expr frame caller_path expr2 in
        match op with
        | Ast.Eq -> Llvm.build_icmp Llvm.Icmp.Eq lhs rhs "eq" builder
        | Ast.Neq -> Llvm.build_icmp Llvm.Icmp.Ne lhs rhs "neq" builder
        | Ast.Gt -> Llvm.build_icmp Llvm.Icmp.Sgt lhs rhs "gt" builder
        | Ast.Lt -> Llvm.build_icmp Llvm.Icmp.Slt lhs rhs "lt" builder
        | Ast.Geq -> Llvm.build_icmp Llvm.Icmp.Sge lhs rhs "geq" builder
        | Ast.Leq -> Llvm.build_icmp Llvm.Icmp.Sle lhs rhs "leq" builder)
  in

  let rec gen_block frame caller_path (block : Ast.block) =
    let rec aux = function
      | [] -> ()
      | hd :: tl -> (
          gen_stmt frame caller_path hd;
          match Llvm.block_terminator (Llvm.insertion_block builder) with
          | None -> aux tl
          | Some inst -> (
              match Llvm.instr_opcode inst with
              | Llvm.Opcode.Ret -> aux []
              | _ -> aux tl))
    in
    aux block.stmts
  and gen_stmt frame caller_path (stmt : Ast.stmt) =
    match stmt with
    | Ast.Empty _ -> Llvm.build_is_null (c32 0) "empty" builder |> ignore
    | Ast.Assign (l_val, expr) ->
        let rhs = gen_expr frame caller_path expr in
        let l_val_ptr = gen_l_value frame caller_path l_val in
        ignore (Llvm.build_store rhs l_val_ptr builder)
    | Ast.Block block -> gen_block frame caller_path block
    | Ast.SFuncCall func_call ->
        ignore (gen_func_call frame caller_path func_call)
    | Ast.If (cond, stmt1_o, stmt2_o) ->
        let ret_insts = ref [] in
        let cond = gen_cond frame caller_path cond in
        let func = Llvm.block_parent (Llvm.insertion_block builder) in

        let then_block = Llvm.append_block context "then" func in
        let else_block = Llvm.append_block context "else" func in
        let merge_block = Llvm.append_block context "merge" func in
        let _ = Llvm.build_cond_br cond then_block else_block builder in
        Llvm.position_at_end then_block builder;
        gen_stmt frame caller_path (Option.get stmt1_o);

        (* will never be None *)
        let then_block_final = Llvm.insertion_block builder in
        (match Llvm.block_terminator then_block_final with
        | None -> ignore (Llvm.build_br merge_block builder)
        | Some inst -> (
            match Llvm.instr_opcode inst with
            | Llvm.Opcode.Ret -> ret_insts := inst :: !ret_insts
            | _ -> ()));

        Llvm.position_at_end else_block builder;

        if Option.is_some stmt2_o then
          gen_stmt frame caller_path (Option.get stmt2_o);

        let else_block_final = Llvm.insertion_block builder in
        (match Llvm.block_terminator else_block_final with
        | None -> ignore (Llvm.build_br merge_block builder)
        | Some inst -> (
            match Llvm.instr_opcode inst with
            | Llvm.Opcode.Ret -> ret_insts := inst :: !ret_insts
            | _ -> ()));

        Llvm.position_at_end merge_block builder;
        if
          List.length !ret_insts = 2
          && Llvm.num_operands (List.hd !ret_insts) = 1
        then (
          let else_inst = List.hd !ret_insts in
          ret_insts := List.tl !ret_insts;
          let then_inst = List.hd !ret_insts in

          let then_val = Llvm.operand then_inst 0 in
          let else_val = Llvm.operand else_inst 0 in

          Llvm.delete_instruction then_inst;
          let then_builder = Llvm.builder_at_end context then_block_final in
          ignore (Llvm.build_br merge_block then_builder);

          Llvm.delete_instruction else_inst;
          let else_builder = Llvm.builder_at_end context else_block_final in
          ignore (Llvm.build_br merge_block else_builder);

          let ret_val =
            Llvm.build_phi
              [ (then_val, then_block); (else_val, else_block) ]
              "phi" builder
          in
          ignore (Llvm.build_ret ret_val builder))
        else ()
    | Ast.While (cond, stmt) ->
        let func = Llvm.block_parent (Llvm.insertion_block builder) in
        let cond_block = Llvm.append_block context "cond" func in
        let body_block = Llvm.append_block context "body" func in
        let merge_block = Llvm.append_block context "merge" func in
        let _ = Llvm.build_br cond_block builder in
        Llvm.position_at_end cond_block builder;
        let cond = gen_cond frame caller_path cond in
        let _ = Llvm.build_cond_br cond body_block merge_block builder in
        Llvm.position_at_end body_block builder;
        gen_stmt frame caller_path stmt;
        (match Llvm.block_terminator (Llvm.insertion_block builder) with
        | None -> ignore (Llvm.build_br cond_block builder)
        | Some _ -> ());
        Llvm.position_at_end merge_block builder
    | Return { expr_o; _ } -> (
        match expr_o with
        | None -> ignore (Llvm.build_ret_void builder)
        | Some expr -> (
            let ret_val = gen_expr frame caller_path expr in
            match expr with
            | Ast.EFuncCall Ast.{ ret_type; _ } ->
                if ret_type = Ast.Nothing then
                  ignore (Llvm.build_ret_void builder)
                else ignore (Llvm.build_ret ret_val builder)
            | _ -> ignore (Llvm.build_ret ret_val builder)))
  in

  let gen_func_decl (func : Ast.func) =
    let parent_frame_type_ptr =
      match get_parent_frame_type_ptr_option func with
      | Some ptr -> [ ptr ]
      | None -> []
    in
    let param_lltypes = List.map lltype_of_param_def func.params in
    let full_params = parent_frame_type_ptr @ param_lltypes in
    let ret_type = lltype_of_scalar func.ret_type in
    let func_type = Llvm.function_type ret_type (Array.of_list full_params) in
    match Llvm.lookup_function (Ast.get_proper_func_name func) the_module with
    | None ->
        Llvm.declare_function
          (Ast.get_proper_func_name func)
          func_type the_module
        |> ignore
    | Some _ ->
        raise
          (Error.Internal_compiler_error
             ("Function " ^ Ast.get_func_name func ^ " already declared"))
  in

  let rec gen_func_def (func : Ast.func) =
    let _, local_f_decls, local_f_defs =
      Ast.reorganize_local_defs func.local_defs
    in
    List.iter gen_func_decl local_f_decls;
    List.iter gen_func_def local_f_defs;

    let parent_frame_type_ptr =
      match get_parent_frame_type_ptr_option func with
      | Some ptr -> [ ptr ]
      | None -> []
    in
    let param_lltypes = List.map lltype_of_param_def func.params in
    let full_params = parent_frame_type_ptr @ param_lltypes in
    let ret_type = lltype_of_scalar func.ret_type in
    let func_type = Llvm.function_type ret_type (Array.of_list full_params) in
    let func_name = Ast.get_proper_func_name func in
    let func_decl =
      match Llvm.lookup_function func_name the_module with
      | None -> Llvm.declare_function func_name func_type the_module
      | Some fd -> fd
    in
    let func_block = Llvm.append_block context "entry" func_decl in
    Llvm.position_at_end func_block builder;
    let frame_type =
      match Llvm.type_by_name the_module (Ast.get_frame_name func) with
      | None ->
          raise
            (Error.Internal_compiler_error
               ("Frame type not found for name: " ^ Ast.get_frame_name func))
      | Some ft -> ft
    in
    let frame = Llvm.build_alloca frame_type "frame_struct" builder in
    let _ =
      List.fold_left
        (fun i params ->
          let param_ptr = Llvm.build_struct_gep frame i "param_ptr" builder in
          let _ = Llvm.build_store params param_ptr builder in
          i + 1)
        0
        (Array.to_list (Llvm.params func_decl))
    in
    gen_block frame (func.id :: func.parent_path) (Option.get func.body);
    match Llvm.block_terminator (Llvm.insertion_block builder) with
    | None -> (
        match func.ret_type with
        | Ast.Nothing -> ignore (Llvm.build_ret_void builder)
        | _ ->
            raise
              (Error.Codegen_error (func.loc, "Function must return a value")))
    | Some _ -> ()
  in

  let gen_main (Ast.MainFunc main_func : Ast.program) =
    gen_func_def main_func
  in

  let add_optimizations pass_mgr =
    let optimizations =
      [
        Llvm_ipo.add_argument_promotion;
        Llvm_ipo.add_constant_merge;
        Llvm_ipo.add_dead_arg_elimination;
        Llvm_ipo.add_function_attrs;
        Llvm_ipo.add_function_inlining;
        (* Llvm_ipo.add_always_inliner;* // let's not use this one *)
        Llvm_ipo.add_global_dce;
        Llvm_ipo.add_global_optimizer;
        Llvm_ipo.add_prune_eh;
        Llvm_ipo.add_ipsccp;
        (* Llvm_ipo.add_internalize ~all_but_main:true; // not sure if this is useful *)
        Llvm_ipo.add_strip_dead_prototypes;
        Llvm_ipo.add_strip_symbols;
        Llvm_scalar_opts.add_aggressive_dce;
        Llvm_scalar_opts.add_alignment_from_assumptions;
        Llvm_scalar_opts.add_cfg_simplification;
        Llvm_scalar_opts.add_dead_store_elimination;
        (* Llvm_scalar_opts.add_scalarizer; // not sure if this is useful *)
        Llvm_scalar_opts.add_merged_load_store_motion;
        Llvm_scalar_opts.add_gvn;
        Llvm_scalar_opts.add_ind_var_simplification;
        Llvm_scalar_opts.add_instruction_combination;
        Llvm_scalar_opts.add_jump_threading;
        Llvm_scalar_opts.add_licm;
        Llvm_scalar_opts.add_loop_deletion;
        Llvm_scalar_opts.add_loop_idiom;
        Llvm_scalar_opts.add_loop_rotation;
        Llvm_scalar_opts.add_loop_reroll;
        Llvm_scalar_opts.add_loop_unroll;
        Llvm_scalar_opts.add_loop_unswitch;
        Llvm_scalar_opts.add_memcpy_opt;
        Llvm_scalar_opts.add_partially_inline_lib_calls;
        Llvm_scalar_opts.add_lower_switch;
        Llvm_scalar_opts.add_memory_to_register_promotion;
        Llvm_scalar_opts.add_reassociation;
        Llvm_scalar_opts.add_sccp;
        Llvm_scalar_opts.add_scalar_repl_aggregation;
        Llvm_scalar_opts.add_lib_call_simplification;
        Llvm_scalar_opts.add_tail_call_elimination;
        Llvm_scalar_opts.add_memory_to_register_demotion;
        Llvm_scalar_opts.add_verifier;
        Llvm_scalar_opts.add_correlated_value_propagation;
        Llvm_scalar_opts.add_early_cse;
        Llvm_scalar_opts.add_lower_expect_intrinsic;
        Llvm_scalar_opts.add_type_based_alias_analysis;
        Llvm_scalar_opts.add_scoped_no_alias_alias_analysis;
        Llvm_scalar_opts.add_basic_alias_analysis;
        Llvm_vectorize.add_loop_vectorize;
        Llvm_vectorize.add_slp_vectorize;
      ]
    in
    List.iter (fun opt -> opt pass_mgr) optimizations
  in

  let irgen main_func enable_optimizations =
    gen_all_frame_types main_func;
    gen_main main_func;
    if enable_optimizations then (
      let pass_mgr = Llvm.PassManager.create () in
      add_optimizations pass_mgr;
      ignore (Llvm.PassManager.run_module the_module pass_mgr));
    Llvm_analysis.assert_valid_module the_module
  in

  let codegen_imm outchan =
    let out = Llvm.string_of_llmodule the_module in
    Out_channel.output_string outchan out
  in

  let codegen_asm outchan =
    let out =
      Llvm.MemoryBuffer.as_string
        (Llvm_target.TargetMachine.emit_to_memory_buffer the_module
           Llvm_target.CodeGenFileType.AssemblyFile machine)
    in
    Out_channel.output_string outchan out
  in

  let codegen_obj outchan =
    let out =
      Llvm.MemoryBuffer.as_string
        (Llvm_target.TargetMachine.emit_to_memory_buffer the_module
           Llvm_target.CodeGenFileType.ObjectFile machine)
    in
    Out_channel.output_string outchan out
  in
  (the_module, context, irgen, codegen_imm, codegen_asm, codegen_obj)

let dispose_codegen (the_module, context) =
  Llvm.dispose_module the_module;
  Llvm.dispose_context context
