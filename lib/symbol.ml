open Error
open Ast

let start = 1

type entry_type =
  | Variable of var_def ref
  | Parameter of param_def ref
  | Function of func ref

type entry = {
  id : string;
  type_t : entry_type;
  scope : scope ref;
}

and scope = {
  mutable next_offset : int;
  mutable entries : entry list;
}

type symbol_table = {
  mutable scopes : scope list;
  table : (string, entry) Hashtbl.t;
}

let type_of_entry {type_t;_} =
  match type_t with
  | Variable v -> !v.type_t
  | Parameter p -> !p.type_t
  | Function f -> !f.type_t

let insert loc (id : string) (type_t : entry_type) (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> raise (Symbol_table_error (loc, "Tried to insert into empty symbol table"))
  | hd :: _ ->
    let entry = {id;type_t;scope = ref hd} in
    Hashtbl.add sym_tbl.table id entry;
    hd.entries <- entry :: hd.entries
    
let lookup (id : string) (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> None
  | hd :: _ ->
    match Hashtbl.find_opt sym_tbl.table id with
    | None -> None
    | Some entry -> if !(entry.scope) == hd then Some entry else None

let lookup_all (id : string) (sym_tbl : symbol_table) =
match sym_tbl.scopes with
| [] -> None
| _ -> Hashtbl.find_opt sym_tbl.table id

let open_scope (sym_tbl : symbol_table) = sym_tbl.scopes <- {next_offset = start; entries = []} :: sym_tbl.scopes

let close_scope loc (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> raise (Symbol_table_error (loc, "Tried to close empty symbol table"))
  | hd :: tl ->
    List.iter (fun entry -> Hashtbl.remove sym_tbl.table entry.id) hd.entries;
    sym_tbl.scopes <- tl