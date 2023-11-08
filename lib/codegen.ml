(* standard stuff *)
let context = Llvm.global_context ()
let the_module = Llvm.create_module context "grace"
let builder = Llvm.builder context
let named_values : (string, Llvm.llvalue * Llvm.lltype * Ast.pass_by) Hashtbl.t = Hashtbl.create 10
let function_names : (string, Llvm.lltype * Llvm.lltype list) Hashtbl.t = Hashtbl.create 10

let i1_t = Llvm.i1_type context (* bool *)
let i8_t = Llvm.i8_type context (* char *)
let i32_t = Llvm.i32_type context (* int *)
let i64_t = Llvm.i64_type context (* ase *)
let void_t = Llvm.void_type context (* nothing *)
let c1 = Llvm.const_int i1_t
let c8 = Llvm.const_int i8_t
let c32 = Llvm.const_int i32_t
let c64 = Llvm.const_int i64_t

(* Edsger runtime library functions *)
let write_integer_t = Llvm.function_type void_t [| i32_t |]
let _ = Llvm.declare_function "writeInteger" write_integer_t the_module
let write_char_t = Llvm.function_type void_t [| i8_t |]
let _ = Llvm.declare_function "writeChar" write_char_t the_module
let write_string_t = Llvm.function_type void_t [| Llvm.pointer_type context |]
let _ = Llvm.declare_function "writeString" write_string_t the_module
let read_integer_t = Llvm.function_type i32_t [| void_t |]
let _ = Llvm.declare_function "readInteger" read_integer_t the_module
let read_char_t = Llvm.function_type i8_t [| void_t |]
let _ = Llvm.declare_function "readChar" read_char_t the_module

let read_string_t =
  Llvm.function_type void_t [| i32_t; Llvm.pointer_type context |]

let _ = Llvm.declare_function "readString" read_string_t the_module

(* Grace runtime library functions *)
let ascii_t = Llvm.function_type i32_t [| i8_t |]
let _ = Llvm.declare_function "ascii" ascii_t the_module
let chr_t = Llvm.function_type i8_t [| i32_t |]
let _ = Llvm.declare_function "chr" chr_t the_module

(* C runtime library functions *)
let strlen_t = Llvm.function_type i32_t [| Llvm.pointer_type context |]
let _ = Llvm.declare_function "strlen" strlen_t the_module

let strcmp_t =
  Llvm.function_type i32_t
    [| Llvm.pointer_type context; Llvm.pointer_type context |]

let _ = Llvm.declare_function "strcmp" strcmp_t the_module

let strcpy_t =
  Llvm.function_type void_t
    [| Llvm.pointer_type context; Llvm.pointer_type context |]

let _ = Llvm.declare_function "strcpy" strcpy_t the_module

let strcat_t =
  Llvm.function_type void_t
    [| Llvm.pointer_type context; Llvm.pointer_type context |]

let _ = Llvm.declare_function "strcat" strcat_t the_module

let rec var_type_lltype = function
| Ast.Int -> i32_t
| Ast.Char -> i8_t
| Ast.Array (data_type, s) -> Llvm.array_type (var_type_lltype data_type) (Option.get s)
| Ast.Nothing -> void_t

let codegen_var_def (v_d_n : Ast.var_def Ast.node) =
  match v_d_n with Ast.{node;_} -> match node with (id, data_type) ->
  let the_type = var_type_lltype data_type in
  let the_var_ptr = Llvm.build_alloca the_type id builder in
  Hashtbl.add named_values id (the_var_ptr, the_type, Ast.Value);
  (the_var_ptr, the_type)

let codegen_param_def (p_d_n : Ast.param_def Ast.node) =
  match p_d_n with Ast.{node;_} -> match node with (id, data_type, pass_by) ->
  match pass_by with
  | Ast.Value ->
    let the_type = var_type_lltype data_type in
    let the_par_ptr = Llvm.build_alloca the_type id builder in
    Hashtbl.add named_values id (the_par_ptr, the_type, Ast.Value);
    (the_par_ptr, the_type)
  | Ast.Reference ->
    let the_type = Llvm.pointer_type context in
    let the_par_ptr = Llvm.build_alloca the_type id builder in
    Hashtbl.add named_values id (the_par_ptr, the_type, Ast.Reference);
    (the_par_ptr, the_type)

let rec unroll_lltype the_type = function
| 0 -> the_type
| n -> unroll_lltype (Llvm.element_type the_type) (n - 1)

let rec flatten_l_val (l_v_n : Ast.l_value Ast.node) =
  match l_v_n with Ast.{node;_} -> match node with
  | Ast.ArrayAccess (l_val_n, e_n) ->
    let (l_val_info, e_lst) = flatten_l_val l_val_n in
    let e = codegen_expr e_n in
    (l_val_info, e :: e_lst)
  | _ -> (codegen_l_value l_v_n, [])

and codegen_l_value (l_v_n : Ast.l_value Ast.node) =
  match l_v_n with Ast.{node;_} -> match node with
  | Ast.Id id ->
    let (the_var_ptr, the_type, pass_by) = Hashtbl.find named_values id in (
    match pass_by with
    | Ast.Value -> (the_var_ptr, the_type)
    | Ast.Reference ->
      let the_elem_ptr = Llvm.build_load (Llvm.pointer_type context) the_var_ptr "ref_tmp" builder in
      (the_elem_ptr, the_type)
    )
  | Ast.LString s ->
    let the_var_ptr = Llvm.build_global_stringptr s "string_tmp" builder in
    (the_var_ptr, Llvm.array_type i8_t (String.length s))
  | Ast.ArrayAccess _ ->
    let ((the_var_ptr, the_type), e_lst) = flatten_l_val l_v_n in
    let n = List.length e_lst in
    let e_lst = (c32 0) :: e_lst in
    let the_elem_ptr = Llvm.build_gep the_type the_var_ptr (Array.of_list e_lst) "array_elem_tmp" builder in
    (the_elem_ptr, unroll_lltype the_type n)    


and codegen_expr (e_n : Ast.expr Ast.node) =
  match e_n with Ast.{node;_} -> match node with
  | Ast.LitInt i -> c32 i
  | Ast.LitChar c -> c8 (int_of_char c)
  | Ast.LValue l_val_n ->
    let (the_var_ptr, the_type) = codegen_l_value l_val_n in
    Llvm.build_load the_type the_var_ptr "l_val_tmp" builder
  | Ast.EFuncCall f_call_n -> codegen_func_call f_call_n
  | Ast.UnAritOp (uao, expr_n) -> (
    let hs = codegen_expr expr_n in
    match uao with
    | Ast.Pos -> hs
    | Ast.Neg -> Llvm.build_neg hs "neg_tmp" builder
    )
  | Ast.BinAritOp (expr_1_n, bao, expr_2_n) -> (
    let lhs = codegen_expr expr_1_n in
    let rhs = codegen_expr expr_2_n in
    match bao with
    | Ast.Add -> Llvm.build_add lhs rhs "add_tmp" builder
    | Ast.Sub -> Llvm.build_sub lhs rhs "sub_tmp" builder
    | Ast.Mul -> Llvm.build_mul lhs rhs "mul_tmp" builder
    | Ast.Div -> Llvm.build_sdiv lhs rhs "div_tmp" builder
    | Ast.Mod -> Llvm.build_srem lhs rhs "mod_tmp" builder
    )

and codegen_func_call (f_n : Ast.func_call Ast.node) =
  match f_n with Ast.{node;_} -> match node with (id, e_n_l) ->
  let func_decl = (
    match Llvm.lookup_function id the_module with
    | None -> raise (Failure "Function not found")
    | Some func_decl -> func_decl
  ) in
  let args = Array.of_list (List.map (fun e_n -> codegen_expr e_n) e_n_l) in
  let (ret_type, arg_typs) = Hashtbl.find function_names id in
  let fnty = Llvm.function_type ret_type (Array.of_list arg_typs) in
  Llvm.build_call fnty func_decl args "call_tmp" builder
  (*
  let arguments = List.map (fun e_n -> codegen_expr e_n) e_n_l in
  let func_decl = Llvm.lookup_function id the_module in
  match func_decl with
  | None -> raise (Failure "Function not found")
  | Some func_decl ->
    let func_type = Hashtbl.find function_names id in
    Llvm.build_call func_type func_decl (Array.of_list arguments) "call_tmp" builder*)

let rec codegen_cond (c_n : Ast.cond Ast.node) = 
  match c_n with Ast.{node;_} -> match node with
  | Ast.UnLogicOp (ulo, cond_n) -> (
    match ulo with Ast.Not ->
      Llvm.build_not (codegen_cond cond_n) "not_tmp" builder
    )
  | Ast.BinLogicOp (cond_1_n, blo, cond_2_n) -> (
    let lhs = codegen_cond cond_1_n in
    let the_block = Llvm.insertion_block builder in
    let the_parent = Llvm.block_parent the_block in
    let the_cond = Llvm.append_block context "second_cond" the_parent in
    let the_end = Llvm.append_block context "merge_cond" the_parent in (
    match blo with
    | Ast.And -> Llvm.build_cond_br lhs the_cond the_end builder |> ignore
    | Ast.Or -> Llvm.build_cond_br lhs the_end the_cond builder |> ignore
    );
    Llvm.position_at_end the_cond builder;
    let rhs = codegen_cond cond_2_n in
    Llvm.build_br the_end builder |> ignore;
    Llvm.position_at_end the_end builder;
    Llvm.build_phi [(lhs, the_block); (rhs, the_cond)] "bin_cond_tmp" builder
    )
  | Ast.CompOp (expr_1_n, cop, expr_2_n) -> (
    let lhs = codegen_expr expr_1_n in
    let rhs = codegen_expr expr_2_n in
    match cop with
    | Ast.Eq -> Llvm.build_icmp Llvm.Icmp.Eq lhs rhs "eq_tmp" builder
    | Ast.Neq -> Llvm.build_icmp Llvm.Icmp.Ne lhs rhs "neq_tmp" builder
    | Ast.Gt -> Llvm.build_icmp Llvm.Icmp.Sgt lhs rhs "gt_tmp" builder
    | Ast.Lt -> Llvm.build_icmp Llvm.Icmp.Slt lhs rhs "lt_tmp" builder
    | Ast.Geq -> Llvm.build_icmp Llvm.Icmp.Sge lhs rhs "geq_tmp" builder
    | Ast.Leq -> Llvm.build_icmp Llvm.Icmp.Sle lhs rhs "leq_tmp" builder
    )
    
let rec codegen_block (b_n : Ast.block Ast.node) =
  match b_n with Ast.{node;_} -> match node with stmt_n_l ->
  List.iter (fun stmt_n -> codegen_stmt stmt_n) stmt_n_l

and codegen_stmt (s_n : Ast.stmt Ast.node) =
  match s_n with Ast.{node;_} -> match node with
  | Ast.Empty -> ()
  | Ast.Assign (l_v_n, e_n) ->
    let (the_var_ptr, _) = codegen_l_value l_v_n in
    let e = codegen_expr e_n in
    Llvm.build_store e the_var_ptr builder |> ignore
  | Ast.Block b_n -> codegen_block b_n
  | Ast.SFuncCall f_c_n -> codegen_func_call f_c_n |> ignore
  | Ast.If (cond_n, stmt_1_n_o, stmt_2_n_o) -> (
    let cond_val = codegen_cond cond_n in
    let icmp_ne =
      Llvm.build_icmp Llvm.Icmp.Ne cond_val (c32 0) "if_cond" builder
    in
    let the_parent = Llvm.block_parent (Llvm.insertion_block builder) in
    let the_then = Llvm.append_block context "then" the_parent in
    let the_else = Llvm.append_block context "else" the_parent in
    let the_endif = Llvm.append_block context "endif" the_parent in
    Llvm.build_cond_br icmp_ne the_then the_else builder |> ignore;
    Llvm.position_at_end the_then builder;
    codegen_stmt (Option.get stmt_1_n_o);
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_else builder;
    if Option.is_some stmt_2_n_o then
      codegen_stmt (Option.get stmt_2_n_o);
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_endif builder
  )
  | Ast.While (cond_n, stmt_n) -> (
    let the_parent = Llvm.block_parent (Llvm.insertion_block builder) in
    let the_while = Llvm.append_block context "while" the_parent in
    let the_body = Llvm.append_block context "body" the_parent in
    let the_endwhile = Llvm.append_block context "endwhile" the_parent in
    Llvm.build_br the_while builder |> ignore;
    Llvm.position_at_end the_while builder;
    let cond_val = codegen_cond cond_n in
    let icmp_ne =
      Llvm.build_icmp Llvm.Icmp.Ne cond_val (c32 0) "while_cond" builder
    in
    Llvm.build_cond_br icmp_ne the_body the_endwhile builder |> ignore;
    Llvm.position_at_end the_body builder;
    codegen_stmt stmt_n;
    Llvm.build_br the_while builder |> ignore;
    Llvm.position_at_end the_endwhile builder
  )
  | Ast.Return expr_n_o -> (
    match expr_n_o with
    | None -> Llvm.build_ret_void builder |> ignore
    | Some expr_n ->
      let ret_val = codegen_expr expr_n in
      Llvm.build_ret ret_val builder |> ignore
  )

let codegen_func_decl (f_decl_n : Ast.func_decl Ast.node) =
  match f_decl_n with Ast.{node;_} -> match node with
  Ast.{node = header;_} -> ()