let context = Llvm.global_context ()
let modulx = Llvm.create_module context "Grace"
let builder = Llvm.builder context
let i1_t = Llvm.i1_type context (* bool *)
let i8_t = Llvm.i8_type context (* char *)
let i32_t = Llvm.i32_type context (* int *)
let i64_t = Llvm.i64_type context (* ase *)
let void_t = Llvm.void_type context (* nothing *)
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


let rec codegen_expr = function
  | Ast.LitInt i -> c32 i
  | Ast.LitChar c -> c8 (int_of_char c)
  | Ast.LValue l_val -> codegen_l_value l_val
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
      let lhs = codegen_cond cond_1_n.node in
      let rhs = codegen_cond cond_2_n.node in
      match blo with
      | Ast.And -> Llvm.build_and lhs rhs "and_tmp" builder
      | Ast.Or -> Llvm.build_or lhs rhs "or_tmp" builder)
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
  | Ast.If (cond_n, stmt_1_n_o, stmt_2_n_o) ->
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
      Llvm.position_at_end the_endif builder
  | Ast.While (cond_n, stmt_n) ->
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
      Llvm.position_at_end the_endwhile builder
  | Ast.Return expr_n_o -> (
      match expr_n_o with
      | None -> Llvm.build_ret_void builder |> ignore
      | Some expr_n ->
          Llvm.build_ret (codegen_expr expr_n.node) builder |> ignore)

(* I am become death *)
