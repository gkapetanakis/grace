open Error
open Ast

let start = 1
(* we might choose that offsets start at 0, but I think starting at 1 will prove to be a good idea, we'll find out later *)

type entry_type =
  | Variable of var_def ref
  | Parameter of param_def ref
  | Function of func ref

type entry = { id : string; type_t : entry_type; scope : scope ref }
and scope = { mutable next_offset : int; mutable entries : entry list }

type symbol_table = {
  mutable parent_path : string list;
  mutable scopes : scope list;
  table : (string, entry) Hashtbl.t;
}

let get_and_increment_offset (sym_tbl : symbol_table) =
  let scope = List.hd sym_tbl.scopes in
  let offset = scope.next_offset in
  scope.next_offset <- scope.next_offset + 1;
  offset

let type_of_entry { type_t; _ } =
  match type_t with
  | Variable v -> !v.type_t
  | Parameter p -> !p.type_t
  | Function f -> !f.type_t

let insert loc (id : string) (type_t : entry_type) (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] ->
      raise
        (Symbol_table_error (loc, "Tried to insert into empty symbol table"))
  | hd :: _ ->
      let entry = { id; type_t; scope = ref hd } in
      Hashtbl.add sym_tbl.table id entry;
      hd.entries <- entry :: hd.entries

let lookup (id : string) (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> None
  | hd :: _ -> (
      match Hashtbl.find_opt sym_tbl.table id with
      | None -> None
      | Some entry -> if !(entry.scope) == hd then Some entry else None)

let lookup_all (id : string) (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> None
  | _ -> Hashtbl.find_opt sym_tbl.table id

let open_scope (func_id : string) (sym_tbl : symbol_table) =
  let scope = { next_offset = start; entries = [] } in
  sym_tbl.scopes <- scope :: sym_tbl.scopes;
  sym_tbl.parent_path <-
    (if func_id = String.empty then sym_tbl.parent_path
     else func_id :: sym_tbl.parent_path)

let close_scope loc (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> raise (Symbol_table_error (loc, "Tried to close empty symbol table"))
  | hd :: tl ->
      List.iter (fun entry -> Hashtbl.remove sym_tbl.table entry.id) hd.entries;
      sym_tbl.scopes <- tl;
      match sym_tbl.parent_path with _ :: t -> sym_tbl.parent_path <- t | _ -> ()
