open Ast

type mode = AstOnly | All

let mode = ref All

let enjoy sem node =
  match !mode with
  | AstOnly -> node
  | All -> sem() |> ignore; node

let wrap_open_scope func_id sym_tbl =
  match !mode with
  | AstOnly -> ()
  | All -> Symbol.open_scope func_id sym_tbl

let wrap_close_scope loc sym_tbl =
  match !mode with
  | AstOnly -> ()
  | All -> Symbol.close_scope loc sym_tbl

let wrap_var_def loc id vt sym_tbl =
  let var_def: var_def = {
    id = id;
    type_t = vt;
    frame_offset = Symbol.get_and_increment_offset sym_tbl;
    parent_path = sym_tbl.parent_path;
    loc = loc;
  } in
  let sem () = 
    Sem.sem_var_def var_def sym_tbl;
    Sem.ins_var_def var_def sym_tbl; in
  enjoy sem var_def

let wrap_param_def loc id pt pb sym_tbl =
  let param_def: param_def = {
    id = id;
    type_t = pt;
    pass_by = pb;
    frame_offset = Symbol.get_and_increment_offset sym_tbl;
    parent_path = sym_tbl.parent_path;
    loc = loc;
  } in
  let sem () = 
    Sem.sem_param_def param_def sym_tbl;
    Sem.ins_param_def param_def sym_tbl; in
  enjoy sem param_def

let wrap_l_value_id loc id exprs sym_tbl =
  let l_value_id: l_value_id = {
    id = id;
    type_t = Nothing; (* will be changed by sem_l_value *)
    pass_by = Value; (* will be changed by sem_l_value *)
    frame_offset = -1; (* will be changed by sem_l_value *)
    parent_path = []; (* will be changed by sem_l_value *)
    loc = loc;
  } in
  let l_value = (match exprs with 
    | [] -> Id l_value_id
    | _ -> ArrayAccess (Id l_value_id, exprs)) in
    let sem () = Sem.sem_l_value l_value sym_tbl in
    enjoy sem l_value

let wrap_l_value_string loc str exprs sym_tbl =
  let l_value_str: l_value_lstring = {
    id = str;
    type_t = Array (Char, [Some (String.length str)]);
    loc = loc;
  } in
  let l_value = (match exprs with 
    | [] -> LString l_value_str
    | _ -> ArrayAccess (LString l_value_str, exprs)) in
    let sem () = Sem.sem_l_value l_value sym_tbl in
    enjoy sem l_value
