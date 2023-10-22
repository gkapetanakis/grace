open Error

type func_status = Defined | Declared

type entry_type =
  | Variable of Ast.var
  | Parameter of Ast.param
  | Function of { header : Ast.header; mutable status : func_status }

type entry = { id : string; info : entry_type }

let entry_type { info; _ } =
  match info with
  | Variable (_, t) -> t
  | Parameter (_, t, _) -> t
  | Function { header = _, _, data; _ } -> data

type scope = { mutable entries : entry list }
type symbol_table = scope list ref

let insert_to_scope (entry : entry) (scope : scope) =
  scope.entries <- entry :: scope.entries

let insert (entry : entry) (sym_tbl : symbol_table) =
  match !sym_tbl with
  | hd :: _ -> insert_to_scope entry hd
  | [] ->
      raise (Symbol_table_exception "Tried to insert into empty symbol table")

let lookup_in_scope (id : string) (scope : scope) =
  let rec aux id lst =
    match lst with
    | [] -> None
    | ({ id = entry_id; _ } as hd) :: tl ->
        if id = entry_id then Some hd else aux id tl
  in
  aux id scope.entries

let rec lookup_n n id sc_l =
  match (n, sc_l) with
  | _, [] -> None
  | n, _ when n < 0 -> None
  | n, hd :: tl -> (
      match lookup_in_scope id hd with
      | None -> lookup_n (n - 1) id tl
      | Some entry -> Some entry)

let lookup id sym_tbl = lookup_n 0 id !sym_tbl
let lookup_all id sym_tbl = lookup_n (List.length !sym_tbl - 1) id !sym_tbl
let open_scope sym_tbl = sym_tbl := { entries = [] } :: !sym_tbl

let close_scope sym_tbl =
  match !sym_tbl with
  | _ :: tl -> sym_tbl := tl
  | [] -> raise (Symbol_table_exception "Tried to close nonexistent scope")
