open Ast
open Symbol

exception Semantic_error of loc * string

let verify_var {loc; node = (_, t)} =
  let rec data_walk = function
  | Array(_, None) -> raise (Semantic_error (loc, "Array must have size"))
  | Array(t, _) -> data_walk t
  | _ -> ()
  in data_walk t

let verify_param {loc; node = (id, t, _)} =
  match t with
  | Array(t, None) -> verify_var {loc; node = (id, t)}
  | t -> verify_var {loc; node = (id, t)}

let comp_var_param va par =
  verify_var va;
  verify_param par;
  match va, par with
  | {node = (_, t1);_}, {node = (_, t2, _);_} ->
    match t1, t2 with
    | Array(t1, _), Array(t2, None) -> t1 = t2
    | _ -> t1 = t2

let sem_var ({loc; node = (id, t)} as var : Ast.var Ast.node) sym_tbl =
  verify_var var;
  match lookup id sym_tbl with
  | Some _ -> raise (Semantic_error (loc, "Variable already declared"))
  | None -> insert {id = id; info = Variable (id, t)} sym_tbl

let sem_param ({loc; node = (id, t, pass)} as param : Ast.param Ast.node) sym_tbl =
  verify_param param;
  let check_type () = match t, pass with
  | Array _, ByValue ->
    raise (Semantic_error (loc, "Array must be passed by reference"))
  | _ -> ()
  in check_type ();
  match lookup id sym_tbl with
  | Some _ -> raise (Semantic_error (loc, "Parameter already declared"))
  | None -> insert {id = id; info = Parameter (id, t, pass)} sym_tbl

let rec sem_l_value ({loc; node = lv} : Ast.l_value Ast.node) sym_tbl =
  match lv with
  | Id id ->
    begin match lookup_all id sym_tbl with
    | None -> raise (Semantic_error (loc, "Variable not defined in any scope"))
    | Some entry -> entry_type entry (* fix later *)
    end
  | LString ls -> Array (Char, Some (String.length ls + 1))
  | ArrayAccess (lv, e) ->
    if sem_expr {loc = loc; node = e} sym_tbl = Int then
      match sem_l_value {loc = loc; node = lv} sym_tbl with
      | Array (t, _) -> t
      | _ -> raise (Semantic_error (loc, "Array access must be of type array"))
    else raise (Semantic_error (loc, "Array access index must be of type int"))

and sem_expr ({loc; node = ex } : Ast.expr Ast.node) sym_tbl = 
    match ex with
    | LitInt _ -> Int
    | LitChar _ -> Char
    | LValue lv -> sem_l_value {loc = loc; node = lv} sym_tbl
    | EFuncCall fc -> sem_func_call {loc = loc; node = fc} sym_tbl
    | Signed (_, e) ->
      if sem_expr {loc = loc; node = e} sym_tbl = Int then Int
      else raise (Semantic_error (loc, "Signed expression must be of type int"))
    | AritOp (e1, _, e2) ->
      if
        sem_expr {loc = loc; node = e1} sym_tbl = Int &&
        sem_expr {loc = loc; node = e2} sym_tbl = Int
      then Int
      else raise (Semantic_error (loc, "Arithmetic operators must be of type int"))

and sem_func_call ({loc; node = (id, el)} : Ast.func_call Ast.node) sym_tbl =
  let rec check_params (args : Ast.expr list) (param_list : Ast.param list) =
    match args, param_list with
    | [], [] -> true
    | [], _ -> raise (Semantic_error (loc, "Too few arguments"))
    | _, [] -> raise (Semantic_error (loc, "Too many arguments"))
    | arg :: args, param :: params ->
      if comp_var_param
        {loc = loc; node = ("", sem_expr {loc = loc; node = arg} sym_tbl)}
        {loc = loc; node = param}
      then check_params args params
      else raise (Semantic_error (loc, "Argument type mismatch")) in
    match lookup_all id sym_tbl with
    | None -> raise (Semantic_error (loc, "Function not defined in any scope"))
    | Some {info; _} ->
      begin match info with
      | Function { header = (_, params, data); _} ->
        if check_params el params then data
        else raise (Semantic_error (loc, "Function call type mismatch"))
      | _ -> raise (Semantic_error (loc, "Name is not a function"))
      end

let sem_cond ({loc; node} : Ast.cond Ast.node) sym_tbl =
  match node with
  | Comp (e1, _, e2) ->
    let aux e1 e2 tt =
      sem_expr {loc = loc; node = e1} sym_tbl = tt &&
      sem_expr {loc = loc; node = e2} sym_tbl = tt in
    if aux e1 e2 Int || aux e1 e2 Char then ()
    else raise (Semantic_error (loc, "Comparison must be of type int or char"))
  | _ -> ()

let sem_stmt ({loc; node} : Ast.stmt Ast.node) sym_tbl =
  match node with
  | Assign (lv, e) ->
    let aux t1 t2 tt = t1 = tt && t2 = tt in
    let t1 = sem_l_value {loc = loc; node = lv} sym_tbl in
    let t2 = sem_expr {loc = loc; node = e} sym_tbl in
    if aux t1 t2 Int || aux t1 t2 Char then ()
    else raise (Semantic_error (loc, "Assignment type mismatch"))
  | Return ex -> (
    let ex_typ = match ex with
    | None -> Nothing
    | Some e -> sem_expr {loc = loc; node = e} sym_tbl in
    let sc = List.hd !sym_tbl in
    let entry = List.hd sc.entries in
    match entry.info with
    | Function _ ->
      if ex_typ = entry_type entry then ()
      else raise (Semantic_error (loc, "Return type mismatch"))
    | _ -> raise (Semantic_error (loc, "Return statement outside function"))
    )
  | _ -> ()

let sem_header ({loc; node = (_, _, data) } : Ast.header Ast.node) _ =
  match data with
  | Array _ -> raise (Semantic_error (loc, "Return type can't be an array"))
  | _ -> ()

let sem_func_decl ({loc; node = ((id,_,_) as head)} : Ast.func_decl Ast.node) sym_tbl =
  match lookup id sym_tbl with
  | Some _ -> raise (Semantic_error (loc, "Function already declared"))
  | None -> insert {id = id; info = Function {header = head; status = Declared}} sym_tbl

let compare_heads
  ((id1, pl1, d1) : Ast.header)
  ((id2, pl2, d2) : Ast.header) =
  let skin params = List.map (fun (_, t, p) -> (t, p)) params in
  let p1, p2 = skin pl1, skin pl2 in
  id1 = id2 && p1 = p2 && d1 = d2

let sem_func_def
  ({loc; node = (((id,_,_) as head), _, _)} : Ast.func_def Ast.node)
  sym_tbl =
  match lookup id sym_tbl with
  | None -> raise (Semantic_error (loc, "Function not declared"))
  | Some {info; _} -> (
    match info with
    | Function ({header;_} as f) ->
      if f.status = Defined
      then raise (Semantic_error (loc, "Function already defined"))
      else if compare_heads head header then f.status <- Defined
      else raise (Semantic_error (loc, "Function declaration and definition mismatch"))
    | _ -> raise (Semantic_error (loc, "Name is not a function"))
  )

let sem_local_def _ _ = ()