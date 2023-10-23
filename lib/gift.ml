open Ast

(* to be used in parser rule fpar_def *)
let fpar_def_to_list loc pass ids ft : param node list =
  let rec aux pass ids ft acc =
    match ids with
    | [] -> List.rev acc
    | id :: ids -> aux pass ids ft ({ loc; node = (id, ft, pass) } :: acc)
  in
  aux pass ids ft []

(* to be used in parser rule var_def *)
let var_def_to_list loc ids vt : var node list =
  let rec aux ids vt acc =
    match ids with
    | [] -> List.rev acc
    | id :: ids -> aux ids vt ({ loc; node = (id, vt) } :: acc)
  in
  aux ids vt []

let wrap_var loc (id, t) sym_tbl =
  let node = { loc; node = (id, t) } in
  Sem.sem_var node sym_tbl;
  node

let wrap_param loc param sym_tbl =
  let node = { loc; node = param } in
  Sem.sem_param node sym_tbl;
  node

let wrap_l_value loc lv sym_tbl =
  let node = { loc; node = lv } in
  let _ = Sem.sem_l_value node sym_tbl in
  node

let wrap_expr loc expr sym_tbl =
  let node = { loc; node = expr } in
  let _ = Sem.sem_expr node sym_tbl in
  node

let wrap_func_call loc func_call sym_tbl =
  let node = { loc; node = func_call } in
  let _ = Sem.sem_func_call node sym_tbl in
  node

let wrap_cond loc comp sym_tbl =
  let node = { loc; node = comp } in
  Sem.sem_cond node sym_tbl;
  node

let wrap_stmt loc stmt sym_tbl =
  let node = { loc; node = stmt } in
  Sem.sem_stmt node sym_tbl;
  node

let wrap_header loc (id, param_n_list, ret_data) sym_tbl =
  let node = { loc; node = (id, param_n_list, ret_data) } in
  Sem.sem_header node sym_tbl;
  node

let wrap_func_decl loc head_n sym_tbl =
  let node = { loc; node = head_n } in
  Sem.sem_func_decl node sym_tbl;
  node

let wrap_func_def loc (head_n, local_n_l, blk_n) sym_tbl =
  let node = { loc; node = (head_n, local_n_l, blk_n) } in
  Sem.sem_func_def node sym_tbl;
  node

let wrap_local_def loc local_n =
  match local_n with
  | `FuncDef fd -> [ { loc; node = FuncDef fd } ]
  | `FuncDecl fd -> [ { loc; node = FuncDecl fd } ]
  | `VarDefList vl -> List.map (fun v -> { loc; node = Var v }) vl

let wrap_block loc stmt_n_l =
  let node = { loc; node = stmt_n_l } in
  node

let tbl : Symbol.symbol_table = ref []