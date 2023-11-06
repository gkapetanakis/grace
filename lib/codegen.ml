let context = Llvm.global_context ()
let modulx = Llvm.create_module context "Grace"
let builder = Llvm.builder context
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
let _ = Llvm.declare_function "writeInteger" write_integer_t modulx
let write_char_t = Llvm.function_type void_t [| i8_t |]
let _ = Llvm.declare_function "writeChar" write_char_t modulx
let write_string_t = Llvm.function_type void_t [| Llvm.pointer_type context |]
let _ = Llvm.declare_function "writeString" write_string_t modulx
let read_integer_t = Llvm.function_type i32_t [| void_t |]
let _ = Llvm.declare_function "readInteger" read_integer_t modulx
let read_char_t = Llvm.function_type i8_t [| void_t |]
let _ = Llvm.declare_function "readChar" read_char_t modulx

let read_string_t =
  Llvm.function_type void_t [| i32_t; Llvm.pointer_type context |]

let _ = Llvm.declare_function "readString" read_string_t modulx

(* Grace runtime library functions *)
let ascii_t = Llvm.function_type i32_t [| i8_t |]
let _ = Llvm.declare_function "ascii" ascii_t modulx
let chr_t = Llvm.function_type i8_t [| i32_t |]
let _ = Llvm.declare_function "chr" chr_t modulx

(* C runtime library functions *)
let strlen_t = Llvm.function_type i32_t [| Llvm.pointer_type context |]
let _ = Llvm.declare_function "strlen" strlen_t modulx

let strcmp_t =
  Llvm.function_type i32_t
    [| Llvm.pointer_type context; Llvm.pointer_type context |]

let _ = Llvm.declare_function "strcmp" strcmp_t modulx

let strcpy_t =
  Llvm.function_type void_t
    [| Llvm.pointer_type context; Llvm.pointer_type context |]

let _ = Llvm.declare_function "strcpy" strcpy_t modulx

let strcat_t =
  Llvm.function_type void_t
    [| Llvm.pointer_type context; Llvm.pointer_type context |]

let _ = Llvm.declare_function "strcat" strcat_t modulx

(* Codegen functions *)
(* -------- IMPORTANT ----------
  Something to note is that when we execute some code then we might not end up in the same block as before.
  E.g. we want to compile some code like this:
  current_block:
    ...
    cond_val = compute cond
    if cond_val = true then goto then else goto else
  then:
    compute stmt1
    goto endif
  else:
    compute stmt2
    goto endif
  endif:
    ...

  Code1:
    let cond_val = codegen_cond cond_n.node in
    let icmp_ne =
      Llvm.build_icmp Llvm.Icmp.Ne cond_val (c32 0) "if_cond" builder
    in
    let the_parent = Llvm.block_parent (Llvm.insertion_block builder) in
    let the_then = Llvm.append_block context "then" the_parent in
    let the_else = Llvm.append_block context "else" the_parent in
    let the_endif = Llvm.append_block context "endif" the_parent in
    Llvm.build_cond_br icmp_ne the_then the_else builder |> ignore;
    Llvm.position_at_end the_then builder;
    codegen_stmt (Option.get stmt_1_n_o).node;
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_else builder;
    if Option.is_some stmt_2_n_o then
      codegen_stmt (Option.get stmt_2_n_o).node;
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_endif builder)

  Code2:
    let the_parent = Llvm.block_parent (Llvm.insertion_block builder) in
    let the_then = Llvm.append_block context "then" the_parent in
    let the_else = Llvm.append_block context "else" the_parent in
    let the_endif = Llvm.append_block context "endif" the_parent in
    let cond_val = codegen_cond cond_n.node in
    let icmp_ne =
      Llvm.build_icmp Llvm.Icmp.Ne cond_val (c32 0) "if_cond" builder
    in
    Llvm.build_cond_br icmp_ne the_then the_else builder |> ignore;
    Llvm.position_at_end the_then builder;
    codegen_stmt (Option.get stmt_1_n_o).node;
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_else builder;
    if Option.is_some stmt_2_n_o then
      codegen_stmt (Option.get stmt_2_n_o).node;
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_endif builder)

  Code1 is correct (or so I think currently...). Code2 is incorrent. Explanation:
  When we call codegen_cond we might end up in a different block than the current one.
  This is because codegen_cond might put us in some other block. So we want blocks then, else, endif to be placed
  after that block (or in relation to that blocks parent).
  This is why we need to call Llvm.block_parent (Llvm.insertion_block builder) after computing the cond_val
  (and icmp_ne variable).
*)
let rec codegen_expr = function
  | Ast.LitInt i -> c32 i
  | Ast.LitChar c -> c8 (int_of_char c)
  | Ast.LValue l_val_n -> codegen_l_value l_val_n.node
  | Ast.EFuncCall f_call ->
      c32 1
      (* takes a func_call ast node and turns it to llvm code *)
      (*let func_name = f_call.fname in
        let func_decl = Llvm.lookup_function func_name modulx in
        let args = Array.of_list (List.map (fun arg -> codegen_expr arg.node) f_call.args) in
        Llvm.build_call func_decl args "call_tmp" builder*)
  | Ast.UnAritOp (uao, expr_n) -> (
      let hs = codegen_expr expr_n.node in
      match uao with
      | Ast.Pos -> hs
      | Ast.Neg -> Llvm.build_neg hs "neg_tmp" builder)
  | Ast.BinAritOp (expr_1_n, bao, expr_2_n) -> (
      let lhs = codegen_expr expr_1_n.node in
      let rhs = codegen_expr expr_2_n.node in
      match bao with
      | Ast.Add -> Llvm.build_add lhs rhs "add_tmp" builder
      | Ast.Sub -> Llvm.build_sub lhs rhs "sub_tmp" builder
      | Ast.Mul -> Llvm.build_mul lhs rhs "mul_tmp" builder
      | Ast.Div -> Llvm.build_sdiv lhs rhs "div_tmp" builder
      | Ast.Mod -> Llvm.build_srem lhs rhs "mod_tmp" builder)

and codegen_l_value = function
  | Ast.Id id -> c32 1
  | Ast.LString s -> c32 1
  | Ast.ArrayAccess (l_val_n, expr_n) -> c32 1

let rec codegen_cond = function
  | Ast.UnLogicOp (ulo, cond_n) -> (
      match ulo with
      | Ast.Not -> Llvm.build_not (codegen_cond cond_n.node) "not_tmp" builder)
  | Ast.BinLogicOp (cond_1_n, blo, cond_2_n) -> (
    (*
    Implemented so that 'And' and 'Or' are short-circuiting operators.
    code looks something like this:
    
    current_block:
      ...
      lhs = compute cond1
      match blo with
      | And -> if lhs = true then goto second_cond else goto merge_cond
      | Or -> if lhs = true then goto merge_cond else goto second_cond
    second_cond:
      rhs = compute cond2
      goto merge_cond
    merge_cond:
      result = phi [lhs, current_block], [rhs, second_cond]
      ...

    In other words, if the operation is 'And' and lhs = false
    then we know that result = false so we go to merge_cond and set result to false.
    On the other hand, if the operation is 'Or' and lhs = true
    then we know that result = true so we go to merge_cond and set result to true.
    This way we can avoid computing rhs if we don't have to... :)
    *)
      let lhs = codegen_cond cond_1_n.node in
      let the_block = Llvm.insertion_block builder in
      let the_parent = Llvm.block_parent the_block in
      let the_cond = Llvm.append_block context "second_cond" the_parent in
      let the_end = Llvm.append_block context "merge_cond" the_parent in (
      match blo with
      | Ast.And -> Llvm.build_cond_br lhs the_cond the_end builder |> ignore
      | Ast.Or -> Llvm.build_cond_br lhs the_end the_cond builder |> ignore
      );
      Llvm.position_at_end the_cond builder;
      let rhs = codegen_cond cond_2_n.node in
      Llvm.build_br the_end builder |> ignore;
      Llvm.position_at_end the_end builder;
      Llvm.build_phi [(lhs, the_block); (rhs, the_cond)] "bin_cond_tmp" builder
    )
  | Ast.CompOp (expr_1_n, cop, expr_2_n) -> (
      let lhs = codegen_expr expr_1_n.node in
      let rhs = codegen_expr expr_2_n.node in
      match cop with
      | Ast.Eq -> Llvm.build_icmp Llvm.Icmp.Eq lhs rhs "eq_tmp" builder
      | Ast.Neq -> Llvm.build_icmp Llvm.Icmp.Ne lhs rhs "neq_tmp" builder
      | Ast.Gt -> Llvm.build_icmp Llvm.Icmp.Sgt lhs rhs "gt_tmp" builder
      | Ast.Lt -> Llvm.build_icmp Llvm.Icmp.Slt lhs rhs "lt_tmp" builder
      | Ast.Geq -> Llvm.build_icmp Llvm.Icmp.Sge lhs rhs "geq_tmp" builder
      | Ast.Leq -> Llvm.build_icmp Llvm.Icmp.Sle lhs rhs "leq_tmp" builder)

let rec codegen_block stmt_n_l =
  List.iter (fun stmt_n -> codegen_stmt (Ast.get_node stmt_n)) stmt_n_l

and codegen_stmt = function
  | Ast.Empty -> ()
  | Ast.Assign (l_val_n, expr_n) -> ()
  | Ast.Block block_n -> codegen_block block_n.node
  | Ast.SFuncCall func_c_n -> ()
  | Ast.If (cond_n, stmt_1_n_o, stmt_2_n_o) -> (
    (*
    current_block:
      ...
      cond_val = compute cond
      if cond_val = true then goto then else goto else
    then:
      compute stmt1
      goto endif
    else:
      compute stmt2
      goto endif
    endif:
      ...
    *)
    let cond_val = codegen_cond cond_n.node in
    let icmp_ne =
      Llvm.build_icmp Llvm.Icmp.Ne cond_val (c32 0) "if_cond" builder
    in
    let the_parent = Llvm.block_parent (Llvm.insertion_block builder) in
    let the_then = Llvm.append_block context "then" the_parent in
    let the_else = Llvm.append_block context "else" the_parent in
    let the_endif = Llvm.append_block context "endif" the_parent in
    Llvm.build_cond_br icmp_ne the_then the_else builder |> ignore;
    Llvm.position_at_end the_then builder;
    codegen_stmt (Option.get stmt_1_n_o).node;
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_else builder;
    if Option.is_some stmt_2_n_o then
      codegen_stmt (Option.get stmt_2_n_o).node;
    Llvm.build_br the_endif builder |> ignore;
    Llvm.position_at_end the_endif builder)
  | Ast.While (cond_n, stmt_n) -> (
    (*
      current_block:
        ...
        br while
      while:
        cond_val = compute cond
        if cond_val = true then goto body else goto endwhile
      body:
        compute stmt
        goto while
      endwhile:
        ... 
    *)
    let the_parent = Llvm.block_parent (Llvm.insertion_block builder) in
    let the_while = Llvm.append_block context "while" the_parent in
    let the_body = Llvm.append_block context "body" the_parent in
    let the_endwhile = Llvm.append_block context "endwhile" the_parent in
    Llvm.build_br the_while builder |> ignore;
    Llvm.position_at_end the_while builder;
    let cond_val = codegen_cond cond_n.node in
    let icmp_ne =
      Llvm.build_icmp Llvm.Icmp.Ne cond_val (c32 0) "while_cond" builder
    in
    Llvm.build_cond_br icmp_ne the_body the_endwhile builder |> ignore;
    Llvm.position_at_end the_body builder;
    codegen_stmt stmt_n.node;
    Llvm.build_br the_while builder |> ignore;
    Llvm.position_at_end the_endwhile builder)
  | Ast.Return expr_n_o -> (
    match expr_n_o with
    | None -> Llvm.build_ret_void builder |> ignore
    | Some expr_n ->
      let ret_val = codegen_expr expr_n.node in
      Llvm.build_ret ret_val builder |> ignore)

