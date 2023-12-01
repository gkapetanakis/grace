open Error
open Ast

let start = 1

type entry_type =
  | Variable of var_def ref
  | Parameter of param_def ref
  | Function of func ref

let get_loc_entry_type (entry_type : entry_type) =
  match entry_type with
  | Variable v -> !v.loc
  | Parameter p -> !p.loc
  | Function f -> !f.loc

let get_data_type_entry_type (entry_type : entry_type) =
  match entry_type with
  | Variable v -> !v.type_t
  | Parameter p -> !p.type_t
  | Function f -> Scalar !f.type_t

let get_return_type_entry_type (entry_type : entry_type) =
  match entry_type with
  | Function f -> !f.type_t
  | _ ->
      raise (Internal_compiler_error "Tried to get return type of non-function")

type entry = { id : string; type_t : entry_type; scope : scope ref }
and scope = { mutable next_offset : int; mutable entries : entry list }

let get_loc_entry (entry : entry) = get_loc_entry_type entry.type_t
let get_data_type_entry (entry : entry) = get_data_type_entry_type entry.type_t

let get_return_type_entry (entry : entry) =
  get_return_type_entry_type entry.type_t

type symbol_table = {
  mutable scopes : scope list;
  table : (string, entry) Hashtbl.t;
  mutable parent_path : string list; (*mutable depth : int; *)
}

let get_and_increment_offset (sym_tbl : symbol_table) =
  let scope = List.hd sym_tbl.scopes in
  let offset = scope.next_offset in
  scope.next_offset <- scope.next_offset + 1;
  offset

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
  | hd :: tl -> (
      List.iter (fun entry -> Hashtbl.remove sym_tbl.table entry.id) hd.entries;
      sym_tbl.scopes <- tl;
      match sym_tbl.parent_path with
      | _ :: t -> sym_tbl.parent_path <- t
      | _ -> ())

let declare_function
    ( (id : string),
      (params : param_def list),
      (type_t : ret_type),
      (loc : loc),
      (sym_tbl : symbol_table) ) =
  let func_decl =
    {
      id;
      params;
      type_t;
      local_defs = [];
      body = None;
      loc;
      parent_path = [];
      status = Declared;
    }
  in
  let entry_type = Function (ref func_decl) in
  insert loc id entry_type sym_tbl

let declare_runtime (loc : loc) (sym_tbl : symbol_table) =
  let runtime_lib =
    [
      ("readChar", [], Char, loc, sym_tbl);
      ("readInteger", [], Int, loc, sym_tbl);
      ( "readString",
        [
          {
            id = "n";
            type_t = Scalar Int;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
          {
            id = "s";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [];
            loc;
          };
        ],
        Nothing,
        loc,
        sym_tbl );
      ( "writeChar",
        [
          {
            id = "c";
            type_t = Scalar Char;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
        ],
        Nothing,
        loc,
        sym_tbl );
      ( "writeInteger",
        [
          {
            id = "i";
            type_t = Scalar Int;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
        ],
        Nothing,
        loc,
        sym_tbl );
      ( "writeString",
        [
          {
            id = "s";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [ "writeString" ];
            loc;
          };
        ],
        Nothing,
        loc,
        sym_tbl );
      ( "ascii",
        [
          {
            id = "c";
            type_t = Scalar Char;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
        ],
        Int,
        loc,
        sym_tbl );
      ( "chr",
        [
          {
            id = "i";
            type_t = Scalar Int;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
        ],
        Char,
        loc,
        sym_tbl );
      ( "strcat",
        [
          {
            id = "trg";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
          {
            id = "src";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [];
            loc;
          };
        ],
        Nothing,
        loc,
        sym_tbl );
      ( "strcmp",
        [
          {
            id = "s1";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
          {
            id = "s2";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [];
            loc;
          };
        ],
        Int,
        loc,
        sym_tbl );
      ( "strcpy",
        [
          {
            id = "trg";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
          {
            id = "src";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [];
            loc;
          };
        ],
        Nothing,
        loc,
        sym_tbl );
      ( "strlen",
        [
          {
            id = "s";
            type_t = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [];
            loc;
          };
        ],
        Int,
        loc,
        sym_tbl );
    ]
  in
  List.iter (fun func -> declare_function func) runtime_lib

let remove_runtime (sym_tbl : symbol_table) =
  let runtime_lib =
    [
      "readChar";
      "readInteger";
      "readString";
      "writeChar";
      "writeInteger";
      "writeString";
      "ascii";
      "chr";
      "strcat";
      "strcmp";
      "strcpy";
      "strlen";
    ]
  in
  List.iter (fun id -> Hashtbl.remove sym_tbl.table id) runtime_lib;
  match sym_tbl.scopes with
  | [] ->
      raise
        (Internal_compiler_error
           "Tried to remove runtime from empty symbol table")
  | hd :: _ ->
      hd.entries <-
        List.filter
          (fun entry -> not (List.mem entry.id runtime_lib))
          hd.entries
