(* DONE *)
(* all symbol table related types and functions used during semantic analysis*)

open Error

(* the offset of a function frame struct at which we start adding fields *)
(* offset 0 is reserved for the (automatically-generated) frame struct pointer
   to the given function's parent function (used in nested functions) *)
let first_offset = 1

(* the name of the first scope that is opened *)
let global_scope_name = "main"

(* symbol table entry type type (see below to understand better) *)
type entry_type =
  | Variable of Ast.var_def ref
  | Parameter of Ast.param_def ref
  | Function of Ast.func ref

(* symbol table entry and scope types *)
type entry = { id : string; entry_type : entry_type; scope : scope ref }
and scope = { mutable next_offset : int; mutable entries : entry list }

(* symbol table type *)
type symbol_table = {
  mutable scopes : scope list;
  table : (string, entry) Hashtbl.t;
  mutable parent_path : string list;
}

let get_loc_entry_type (entry_type : entry_type) =
  match entry_type with
  | Variable v -> !v.loc
  | Parameter p -> !p.loc
  | Function f -> !f.loc

let get_data_type_entry_type (entry_type : entry_type) =
  match entry_type with
  | Variable v -> !v.var_type
  | Parameter p -> !p.param_type
  | Function f -> Scalar !f.ret_type

let get_return_type_entry_type (entry_type : entry_type) =
  match entry_type with
  | Function f -> !f.ret_type
  | _ ->
      raise (Internal_compiler_error "Tried to get return type of non-function")

let get_loc_entry (entry : entry) = get_loc_entry_type entry.entry_type

let get_data_type_entry (entry : entry) =
  get_data_type_entry_type entry.entry_type

let get_return_type_entry (entry : entry) =
  get_return_type_entry_type entry.entry_type

let get_and_increment_offset (sym_tbl : symbol_table) =
  let scope = List.hd sym_tbl.scopes in
  let offset = scope.next_offset in
  scope.next_offset <- scope.next_offset + 1;
  offset

(* insert into current scope *)
let insert loc (id : string) (entry_type : entry_type) (sym_tbl : symbol_table)
    =
  match sym_tbl.scopes with
  | [] ->
      raise
        (Symbol_table_error (loc, "Tried to insert into empty symbol table"))
  | hd :: _ ->
      let entry = { id; entry_type; scope = ref hd } in
      Hashtbl.add sym_tbl.table id entry;
      hd.entries <- entry :: hd.entries

(* lookup an id only in the current scope *)
let lookup (id : string) (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> None
  | hd :: _ -> (
      match Hashtbl.find_opt sym_tbl.table id with
      | None -> None
      | Some entry -> if !(entry.scope) == hd then Some entry else None)

(* lookup an id in all scopes *)
let lookup_all (id : string) (sym_tbl : symbol_table) =
  match sym_tbl.scopes with
  | [] -> None
  | _ -> Hashtbl.find_opt sym_tbl.table id

let open_scope (func_id : string) (sym_tbl : symbol_table) =
  let scope = { next_offset = first_offset; entries = [] } in
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

(* create an Ast.func object from the arguments and insert it into a symbol table *)
let declare_function
    ( (id : string),
      (params : Ast.param_def list),
      (ret_type : Ast.ret_type),
      (loc : loc),
      (sym_tbl : symbol_table) ) =
  let func_decl =
    Ast.
      {
        id;
        params;
        ret_type;
        local_defs = [];
        body = None;
        loc;
        parent_path = [];
        status = Declared;
      }
  in
  let entry_type = Function (ref func_decl) in
  insert loc id entry_type sym_tbl

(* insert Ast nodes that represent the functions of Grace's runtime into a symbol table *)
let declare_runtime (loc : loc) (sym_tbl : symbol_table) =
  let runtime_lib =
    [
      (* id, params, return type, loc, symbol table *)
      ("readChar", [], Ast.Char, loc, sym_tbl);
      ("readInteger", [], Ast.Int, loc, sym_tbl);
      ( "readString",
        [
          (* Ast.param_def *)
          Ast.
            {
              id = "n";
              param_type = Scalar Int;
              pass_by = Value;
              frame_offset = 1;
              parent_path = [ "readString" ];
              loc;
            };
          {
            id = "s";
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [ "readString" ];
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
            param_type = Scalar Char;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [ "writeChar" ];
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
            param_type = Scalar Int;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [ "writeInteger" ];
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
            param_type = Array (Char, [ None ]);
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
            param_type = Scalar Char;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [ "ascii" ];
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
            param_type = Scalar Int;
            pass_by = Value;
            frame_offset = 1;
            parent_path = [ "chr" ];
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
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [ "strcat" ];
            loc;
          };
          {
            id = "src";
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [ "strcat" ];
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
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [ "strcmp" ];
            loc;
          };
          {
            id = "s2";
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [ "strcmp" ];
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
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [ "strcpy" ];
            loc;
          };
          {
            id = "src";
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 2;
            parent_path = [ "strcpy" ];
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
            param_type = Array (Char, [ None ]);
            pass_by = Reference;
            frame_offset = 1;
            parent_path = [ "strlen" ];
            loc;
          };
        ],
        Int,
        loc,
        sym_tbl );
    ]
  in
  List.iter (fun func -> declare_function func) runtime_lib

(* remove the runtime nodes from a symbol table after parsing is done to
   not leave lingering definitions in it *)
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
