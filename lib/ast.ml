(* DONE *)
(* loc is a type representing the position (line, column) of an AST node in the source file *)
type loc = Error.loc
type scalar = Int | Char | Nothing
type data_type = Scalar of scalar | Array of scalar * int option list
type un_arit_op = Pos | Neg
type bin_arit_op = Add | Sub | Mul | Div | Mod
type un_logic_op = Not
type bin_logic_op = And | Or
type comp_op = Eq | Neq | Gt | Lt | Geq | Leq
type var_type = data_type
type param_type = data_type
type ret_type = scalar
type pass_by = Value | Reference
type func_status = Defined | Declared

type var_def = {
  (* explicit information for variable definitions *)
  id : string;
  var_type : var_type;
  loc : loc;

  (* implicit information for variable definitions
   * fields used for semantic error checking and code generation *)
  frame_offset : int;
  parent_path : string list;
}

type param_def = {
  (* explicit information for parameter definitions *)
  id : string;
  param_type : param_type;
  pass_by : pass_by;
  loc : loc;

  (* implicit information for parameter definitions
   * fields used for semantic error checking and code generation *)
  mutable frame_offset : int;
  mutable parent_path : string list;
}

type l_value_id = {
  (* explicit information for l-value (type: identifier) *)
  id : string;
  loc : loc;

  (* implicit information used in code generation.
   * These fields are set during the semantic analysis and
   * they match the same information of the identifier they refer to *)
  mutable data_type : data_type;
  mutable passed_by : pass_by;
  mutable frame_offset : int;
  mutable parent_path : string list;
}

type l_value_lstring = { id : string; data_type : data_type; loc : loc }

type l_value_array_access = {
  simple_l_value : simple_l_value;
  exprs : expr list;
}

and simple_l_value = Id of l_value_id | LString of l_value_lstring
and l_value = Simple of simple_l_value | ArrayAccess of l_value_array_access

and func_call = {
  (* explicit information for function call immediately obvious from parsed data *)
  id : string;
  loc : loc;

  (* implicit information set by semantic analysis. These fields are
   * usefull for code generation. *)
  mutable args : (expr * pass_by) list;
  mutable ret_type : ret_type;
  mutable callee_path : string list;
  caller_path : string list;
}

and expr =
  | LitInt of { value : int; loc : loc }
  | LitChar of { value : char; loc : loc }
  | LValue of l_value
  | EFuncCall of func_call
  | UnAritOp of un_arit_op * expr
  | BinAritOp of expr * bin_arit_op * expr

type cond =
  | UnLogicOp of un_logic_op * cond
  | BinLogicOp of cond * bin_logic_op * cond
  | CompOp of expr * comp_op * expr

type block = { stmts : stmt list; loc : loc }

and stmt =
  | Empty of loc
  | Assign of l_value * expr
  | Block of block
  | SFuncCall of func_call
  | If of cond * stmt option * stmt option
  | While of cond * stmt
  | Return of { expr_o : expr option; loc : loc }

type func = {
  id : string;
  params : param_def list;
  ret_type : ret_type;
  mutable local_defs : local_def list;
  mutable body : block option;
  loc : loc;
  status : func_status;

  (* implicit information used in code generation. This field is used in
   * code generation *)
  parent_path : string list;
}

and local_def = VarDef of var_def | FuncDecl of func | FuncDef of func

type program = MainFunc of func

(* auxillary functions to extract the location
   of various AST types *)

let get_loc_simple_l_value = function
  | Id id -> id.loc
  | LString lstring -> lstring.loc

let get_loc_l_value = function
  | Simple simple_l_value -> get_loc_simple_l_value simple_l_value
  | ArrayAccess { simple_l_value; _ } -> get_loc_simple_l_value simple_l_value

let rec get_loc_expr = function
  | LitInt lit_int -> lit_int.loc
  | LitChar lit_char -> lit_char.loc
  | LValue l_value -> get_loc_l_value l_value
  | EFuncCall func_call -> func_call.loc
  | UnAritOp (_, expr) -> get_loc_expr expr
  | BinAritOp (expr1, _, _) -> get_loc_expr expr1

let rec get_loc_cond = function
  | UnLogicOp (_, cond) -> get_loc_cond cond
  | BinLogicOp (cond1, _, _) -> get_loc_cond cond1
  | CompOp (expr1, _, _) -> get_loc_expr expr1

let get_loc_stmt = function
  | Empty loc -> loc
  | Assign (l_value, _) -> get_loc_l_value l_value
  | Block block -> block.loc
  | SFuncCall func_call -> func_call.loc
  | If (cond, _, _) -> get_loc_cond cond
  | While (cond, _) -> get_loc_cond cond
  | Return { loc; _ } -> loc

let get_loc_local_def = function
  | VarDef var_def -> var_def.loc
  | FuncDecl func -> func.loc
  | FuncDef func -> func.loc

(* returns true if an l-value type (which is recursive)
   contains a string literal at its lowest level *)
let contains_str_literal l_val =
  let aux = function Id _ -> false | LString _ -> true in
  match l_val with
  | Simple simple_l_value -> aux simple_l_value
  | ArrayAccess { simple_l_value; _ } -> aux simple_l_value

let reorganize_local_defs (local_defs : local_def list) =
  let rec reorganize_local_defs' (local_defs : local_def list)
      (vars : var_def list) (decls : func list) (funcs : func list) =
    match local_defs with
    | [] -> (vars, decls, funcs)
    | VarDef v :: local_defs ->
        reorganize_local_defs' local_defs (v :: vars) decls funcs
    | FuncDecl d :: local_defs ->
        reorganize_local_defs' local_defs vars (d :: decls) funcs
    | FuncDef f :: local_defs ->
        reorganize_local_defs' local_defs vars decls (f :: funcs)
  in
  let vars, decls, funcs = reorganize_local_defs' local_defs [] [] [] in
  (List.rev vars, List.rev decls, List.rev funcs)

(*
  fun f(): nothing
    fun g(): nothing
  {}
  
  the parent name of f will be <Symbol.global_scope_name>
  the parent name of g will be <Symbol.global_scope_name>.f
*)
let get_parent_name (func : func) =
  let parent_path = List.filter (fun x -> x <> "") func.parent_path in
  String.concat "." (List.rev parent_path)

(*
  fun f(): nothing
    fun g(): nothing
  {}
  
  the name of f will be <Symbol.global_scope_name>.f
  the name of g will be <Symbol.global_scope_name>.f.g
*)
let get_func_name (func : func) =
  let full_path = [ get_parent_name func; func.id ] in
  let full_path = List.filter (fun x -> x <> "") full_path in
  String.concat "." full_path

(* used when renaming functions to avoid name conflicts in codegen *)
let get_proper_parent_func_name (func : func) = get_parent_name func
let get_proper_func_name (func : func) = get_func_name func
let get_proper_func_call_name (func_call : func_call) =
  let full_path = List.rev func_call.callee_path @ [ func_call.id ] in
  let full_path = List.filter (fun x -> x <> "") full_path in
  String.concat "." full_path

(* used when creating the function struct types *)
let get_parent_frame_name (func : func) = "frame__" ^ get_parent_name func
let get_frame_name (func : func) = "frame__" ^ get_func_name func
