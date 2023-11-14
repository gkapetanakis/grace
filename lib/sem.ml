open Ast
open Symbol
open Error

let verify_var_def (vd : var_def) =
  match vd.type_t with
  | Array (_, dims) ->
    if List.find_opt (
      fun dim -> match dim with
      | None -> false
      | Some n -> n <= 0
    ) dims <> None then raise (Semantic_error (vd.loc, "Array dimension must be positive"));
    if List.find_opt (
      fun dim -> match dim with
      | None -> true
      | _ -> false
    ) dims <> None then raise (Semantic_error (vd.loc, "Array dimension must be specified")); ()
  | _ -> ()

let verify_param_def (pd : param_def) = 
  match pd.type_t with
  | Array (_, dims) ->
    if List.find_opt (
      fun dim -> match dim with
      | None -> false
      | Some n -> n <= 0
    ) dims <> None then raise (Semantic_error (pd.loc, "Array dimension must be positive"));
    let tl_dims = List.tl dims in
    if List.find_opt (
      fun dim -> match dim with
      | None -> true
      | _ -> false
    ) tl_dims <> None then raise (Semantic_error (pd.loc, "Array dimension must be specified")); ()
  | _ -> ()

let comp_var_param_def (vd : var_def) (pd : param_def) =
  match vd.type_t, pd.type_t with
  | Array (t1, dims1), Array (t2, dims2) ->
    if t1 <> t2 then raise (Semantic_error (vd.loc, "Array element type mismatch"));
    if List.length dims1 <> List.length dims2 then raise (Semantic_error (vd.loc, "Array dimension count mismatch"));
    if List.hd dims2 = None then
      let tl_dims1, tl_dims2 = List.tl dims1, List.tl dims2 in
      List.iter2 (
        fun dim1 dim2 -> match dim1, dim2 with
        | None, None -> ()
        | Some n1, Some n2 -> if n1 <> n2 then raise (Semantic_error (vd.loc, "Array dimension size mismatch"))
        | _ -> ()
      ) tl_dims1 tl_dims2
  | t1, t2 -> if t1 <> t2 then raise (Semantic_error (vd.loc, "Type mismatch"))

let sem_var_def (vd : var_def) (sym_tbl : symbol_table) =
  verify_var_def vd;
  match lookup vd.id sym_tbl with
  | Some _ -> raise (Semantic_error (vd.loc, "Variable already defined in current scope"))
  | None -> ()

let ins_var_def (vd : var_def) (sym_tbl : symbol_table) =
  insert vd.loc vd.id (Variable (ref vd)) sym_tbl

let sem_param_def (pd : param_def) (sym_tbl : symbol_table) =
  verify_param_def pd;
  match pd.type_t, pd.pass_by with
  | Array _, Value -> raise (Semantic_error (pd.loc, "Array parameter must be passed by reference"))
  | _ -> ();
  match lookup pd.id sym_tbl with
  | Some _ -> raise (Semantic_error (pd.loc, "Parameter already defined in current scope"))
  | None -> ()

let ins_param_def (pd : param_def) (sym_tbl : symbol_table) =
  insert pd.loc pd.id (Parameter (ref pd)) sym_tbl

let rec sem_l_value (lv : l_value) (sym_tbl : symbol_table) = ()