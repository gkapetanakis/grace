open Ast

type mode = AstOnly | All

let mode = ref All

let enjoy sem node =
  match !mode with
  | AstOnly -> node
  | All ->
      sem () |> ignore;
      node

let wrap_open_scope func_id sym_tbl =
  match !mode with AstOnly -> () | All -> Symbol.open_scope func_id sym_tbl

let wrap_close_scope loc sym_tbl =
  match !mode with AstOnly -> () | All -> Symbol.close_scope loc sym_tbl

let wrap_var_def loc id vt sym_tbl =
  let var_def : var_def =
    {
      id;
      type_t = vt;
      frame_offset = Symbol.get_and_increment_offset sym_tbl;
      parent_path = sym_tbl.parent_path;
      loc;
    }
  in
  let sem () =
    Sem.sem_var_def var_def sym_tbl;
    Sem.ins_var_def var_def sym_tbl
  in
  enjoy sem var_def

let wrap_param_def loc id pt pb sym_tbl =
  let param_def : param_def =
    {
      id;
      type_t = pt;
      pass_by = pb;
      frame_offset = Symbol.get_and_increment_offset sym_tbl;
      parent_path = sym_tbl.parent_path;
      loc;
    }
  in
  let sem () =
    Sem.sem_param_def param_def sym_tbl;
    Sem.ins_param_def param_def sym_tbl
  in
  enjoy sem param_def

let wrap_l_value_id loc id exprs sym_tbl =
  let l_value_id : l_value_id =
    {
      id;
      type_t = Nothing;
      (* will be changed by sem_l_value *)
      pass_by = Value;
      (* will be changed by sem_l_value *)
      frame_offset = -1;
      (* will be changed by sem_l_value *)
      parent_path = [];
      (* will be changed by sem_l_value *)
      loc;
    }
  in
  let l_value =
    match exprs with
    | [] -> Id l_value_id
    | _ -> ArrayAccess (Id l_value_id, exprs)
  in
  let sem () = Sem.sem_l_value l_value sym_tbl in
  enjoy sem l_value

let wrap_l_value_string loc str exprs sym_tbl =
  let l_value_str : l_value_lstring =
    { id = str; type_t = Array (Char, [ Some (String.length str) ]); loc }
  in
  let l_value =
    match exprs with
    | [] -> LString l_value_str
    | _ -> ArrayAccess (LString l_value_str, exprs)
  in
  let sem () = Sem.sem_l_value l_value sym_tbl in
  enjoy sem l_value

let wrap_func_call loc id exprs (sym_tbl : Symbol.symbol_table) =
  let func_call : func_call =
    {
      id;
      args = [];
      (* will be set in sem_func_call *)
      type_t = Nothing;
      (* will be set in sem_func_call *)
      callee_path = [];
      (* will be set in sem_func_call *)
      caller_path = sym_tbl.parent_path;
      loc;
    }
  in
  let sem () = Sem.sem_func_call func_call exprs sym_tbl in
  enjoy sem func_call

let wrap_expr_lit_int loc num sym_tbl =
  let expr : expr = LitInt { lit_int = num; loc } in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_lit_char loc chr sym_tbl =
  let expr : expr = LitChar { lit_char = chr; loc } in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_l_value _loc lv sym_tbl =
  let expr : expr = LValue lv in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_func_call _loc fc sym_tbl =
  let expr : expr = EFuncCall fc in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_un_arit_op _loc op rhs sym_tbl =
  let expr : expr = UnAritOp (op, rhs) in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_bin_arit_op _loc op lhs rhs sym_tbl =
  let expr : expr = BinAritOp (lhs, op, rhs) in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_cond_un_logic_op _loc op c sym_tbl =
  let cond : cond = UnLogicOp (op, c) in
  let sem () = Sem.sem_cond cond sym_tbl in
  enjoy sem cond

let wrap_cond_bin_logic_op _loc op lhs rhs sym_tbl =
  let cond : cond = BinLogicOp (lhs, op, rhs) in
  let sem () = Sem.sem_cond cond sym_tbl in
  enjoy sem cond

let wrap_comp_op _loc op lhs rhs sym_tbl =
  let cond : cond = CompOp (lhs, op, rhs) in
  let sem () = Sem.sem_cond cond sym_tbl in
  enjoy sem cond

let wrap_block _loc stmts =
  (* the essence of functional programming *)
  List.fold_right
    (fun stmt acc -> match stmt with Return _ -> [ stmt ] | _ -> stmt :: acc)
    stmts []

let wrap_stmt_empty _loc sym_tbl =
  let stmt : stmt = Empty in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_assign _loc lv e sym_tbl =
  let stmt : stmt = Assign (lv, e) in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_block _loc b sym_tbl =
  let stmt : stmt = Block b in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_func_call _loc fc sym_tbl =
  let stmt : stmt = SFuncCall fc in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_if _loc c s1 s2 sym_tbl =
  let stmt : stmt = If (c, s1, s2) in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_while _loc c s sym_tbl =
  let stmt : stmt = While (c, s) in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_return loc e_o sym_tbl =
  let stmt : stmt = Return { expr_o = e_o; loc } in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_decl_header () = ()
let wrap_def_header () = ()
let wrap_func_decl () = ()
let wrap_func_def () = ()
