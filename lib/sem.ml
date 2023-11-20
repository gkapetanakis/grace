open Ast
open Symbol
open Error

let verify_var_def (vd : var_def) =
  match vd.type_t with
  | Array (_, dims) ->
      if
        List.find_opt
          (fun dim -> match dim with None -> false | Some n -> n <= 0)
          dims
        <> None
      then raise (Semantic_error (vd.loc, "Array dimension must be positive"))
      else if
        List.find_opt
          (fun dim -> match dim with None -> true | _ -> false)
          dims
        <> None
      then raise (Semantic_error (vd.loc, "Array dimension must be specified"))
      else ()
  | _ -> ()

let verify_param_def (pd : param_def) =
  match pd.type_t with
  | Array (_, dims) ->
      let tl_dims = List.tl dims in
      if
        List.find_opt
          (fun dim -> match dim with None -> false | Some n -> n <= 0)
          dims
        <> None
      then raise (Semantic_error (pd.loc, "Array dimension must be positive"))
      else if
        List.find_opt
          (fun dim -> match dim with None -> true | _ -> false)
          tl_dims
        <> None
      then raise (Semantic_error (pd.loc, "Array dimension must be specified"))
      else ()
  | _ -> ()

let comp_var_param_def (vd : var_def) (pd : param_def) =
  match (vd.type_t, pd.type_t) with
  | Array (t1, dims1), Array (t2, dims2) ->
      if t1 <> t2 then
        raise (Semantic_error (vd.loc, "Array element type mismatch"));
      if List.length dims1 <> List.length dims2 then
        raise (Semantic_error (vd.loc, "Array dimension count mismatch"));
      if List.hd dims2 = None then
        let tl_dims1, tl_dims2 = (List.tl dims1, List.tl dims2) in
        List.iter2
          (fun dim1 dim2 ->
            match (dim1, dim2) with
            | None, None -> ()
            | Some n1, Some n2 ->
                if n1 <> n2 then
                  raise
                    (Semantic_error (vd.loc, "Array dimension size mismatch"))
            | _ -> ())
          tl_dims1 tl_dims2
  | t1, t2 -> if t1 <> t2 then raise (Semantic_error (vd.loc, "Type mismatch"))

(* maybe check ref *)

(* maybe compare heads *)

let sem_var_def (vd : var_def) (sym_tbl : symbol_table) =
  verify_var_def vd;
  match lookup vd.id sym_tbl with
  | Some _ ->
      raise
        (Semantic_error (vd.loc, "Variable already defined in current scope"))
  | None -> ()

let ins_var_def (vd : var_def) (sym_tbl : symbol_table) =
  insert vd.loc vd.id (Variable (ref vd)) sym_tbl

let sem_param_def (pd : param_def) (sym_tbl : symbol_table) =
  verify_param_def pd;
  match (pd.type_t, pd.pass_by) with
  | Array _, Value ->
      raise
        (Semantic_error (pd.loc, "Array parameter must be passed by reference"))
  | _ -> (
      ();
      match lookup pd.id sym_tbl with
      | Some _ ->
          raise
            (Semantic_error
               (pd.loc, "Parameter already defined in current scope"))
      | None -> ())

let ins_param_def (pd : param_def) (sym_tbl : symbol_table) =
  insert pd.loc pd.id (Parameter (ref pd)) sym_tbl

let rec sem_l_value (lv : l_value) (sym_tbl : symbol_table) =
  match lv with
  | Id l_val_id -> (
      match lookup_all l_val_id.id sym_tbl with
      | None ->
          raise
            (Semantic_error (l_val_id.loc, "Variable not defined in any scope"))
      | Some { type_t; _ } -> (
          match type_t with
          | Variable vdr ->
              let vd = !vdr in
              l_val_id.type_t <- vd.type_t;
              l_val_id.pass_by <- Value;
              l_val_id.frame_offset <- vd.frame_offset;
              l_val_id.parent_path <- vd.parent_path
          | Parameter pdr ->
              let pd = !pdr in
              l_val_id.type_t <- pd.type_t;
              l_val_id.pass_by <- pd.pass_by;
              l_val_id.frame_offset <- pd.frame_offset;
              l_val_id.parent_path <- pd.parent_path
          | Function _ ->
              raise
                (Semantic_error
                   (l_val_id.loc, "Function cannot be used as l-value"))))
  | LString _ -> ()
  | ArrayAccess (l_val, expr_l) ->
      sem_l_value l_val sym_tbl;
      let loc = ref (Lexing.dummy_pos, Lexing.dummy_pos) in
      let dims =
        match l_val with
        | Id l_val_id -> (
            loc := l_val_id.loc;
            match l_val_id.type_t with
            | Array (_, dims) -> dims
            | _ -> raise (Semantic_error (!loc, "Not an array bro")))
        | LString l_val_str -> (
            loc := l_val_str.loc;
            match l_val_str.type_t with
            | Array (_, dims) -> dims
            | _ -> raise (Semantic_error (!loc, "Not an array bro")))
        | ArrayAccess _ ->
            raise
              (Semantic_error (!loc, "Implementation error, have a nice day"))
      in
      let expr_types = List.map (fun expr -> sem_expr expr sym_tbl) expr_l in
      if List.length dims <> List.length expr_types then
        raise (Semantic_error (!loc, "Array access dimension count mismatch"))
      else if List.length (List.filter (fun t -> t <> Int) expr_types) <> 0 then
        raise (Semantic_error (!loc, "Array access dimension must be integer"))

and sem_func_call { id; loc; _ } sym_tbl = ()
and sem_expr expr sym_tbl = Int

let sem_cond cond sym_tbl = ()
let sem_stmt stmt sym_tbl = ()
