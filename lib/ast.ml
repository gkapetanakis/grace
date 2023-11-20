type loc = Lexing.position * Lexing.position
type data_type = Int | Char | Nothing | Array of data_type * int option list

type data_type_rec =
  | RInt
  | RChar
  | RNothing
  | RArray of data_type_rec * int option

type un_arit_op = Pos | Neg
type bin_arit_op = Add | Sub | Mul | Div | Mod
type un_logic_op = Not
type bin_logic_op = And | Or
type comp_op = Eq | Neq | Gt | Lt | Geq | Leq
type var_type = data_type
type param_type = data_type
type ret_type = data_type
type pass_by = Value | Reference
type func_status = Defined | Declared

type var_def = {
  id : string;
  type_t : var_type;
  frame_offset : int;
  parent_path : string list;
  loc : loc;
}

type param_def = {
  id : string;
  type_t : param_type;
  pass_by : pass_by;
  frame_offset : int;
  parent_path : string list;
  loc : loc;
}

type l_value_id = {
  id : string;
  mutable type_t : data_type;
  mutable pass_by : pass_by;
  mutable frame_offset : int;
  mutable parent_path : string list;
  loc : loc;
}

type l_value_lstring = { id : string; type_t : data_type; loc : loc }

type l_value =
  | Id of l_value_id
  | LString of l_value_lstring
  | ArrayAccess of l_value * expr list

and func_call = {
  id : string;
  mutable args : (expr * pass_by) list;
  mutable type_t : ret_type;
  mutable callee_path : string list;
  caller_path : string list;
  loc : loc;
}

and expr =
  | LitInt of { lit_int : int; loc : loc }
  | LitChar of { lit_char : char; loc : loc }
  | LValue of l_value
  | EFuncCall of func_call
  | UnAritOp of un_arit_op * expr
  | BinAritOp of expr * bin_arit_op * expr

type cond =
  | UnLogicOp of un_logic_op * cond
  | BinLogicOp of cond * bin_logic_op * cond
  | CompOp of expr * comp_op * expr

type block = stmt list

and stmt =
  | Empty
  | Assign of l_value * expr
  | Block of block
  | SFuncCall of func_call
  | If of cond * stmt option * stmt option
  | While of cond * stmt
  | Return of { expr_o : expr option; loc : loc }

type func = {
  id : string;
  params : param_def list;
  type_t : ret_type;
  local_defs : local_def list;
  body : block option;
  loc : loc;
  parent_path : string list;
  status : func_status;
}

and local_def = VarDef of var_def | FuncDecl of func | FuncDef of func

type program = MainFunc of func

let create_var_type dt dims =
  match dims with [] -> dt | _ -> Array (dt, List.map (fun x -> Some x) dims)

let create_param_type dt dims flexible =
  match (dims, flexible) with
  | [], false -> dt
  | (_ :: _ as dims), false -> Array (dt, List.map (fun x -> Some x) dims)
  | dims, true -> Array (dt, None :: List.map (fun x -> Some x) dims)

let rec l_string_dependence = function
  | Id _ -> false
  | LString _ -> true
  | ArrayAccess (lv, _) -> l_string_dependence lv

let reorganize_local_defs (local_defs : local_def list) =
  let rec reorganize_local_defs' (local_defs : local_def list)
      (vars : var_def list) (decls : func list) (funcs : func list) =
    match local_defs with
    | [] -> (vars, funcs, decls)
    | VarDef v :: local_defs ->
        reorganize_local_defs' local_defs (v :: vars) decls funcs
    | FuncDecl f :: local_defs ->
        reorganize_local_defs' local_defs vars (f :: decls) funcs
    | FuncDef f :: local_defs ->
        reorganize_local_defs' local_defs vars decls (f :: funcs)
  in
  let vars, funcs, decls = reorganize_local_defs' local_defs [] [] [] in
  (List.rev vars, List.rev decls, List.rev funcs)

let rec data_type_to_rec = function
  | Int -> RInt
  | Char -> RChar
  | Nothing -> RNothing
  | Array (dt, dims) ->
      let rec aux dt dims =
        match dims with
        | [] -> data_type_to_rec dt
        | dim :: dims -> RArray (aux dt dims, dim)
      in
      aux dt dims

let rec rec_data_type_to_normal = function
  | RInt -> Int
  | RChar -> Char
  | RNothing -> Nothing
  | RArray (dt, dim) -> (
      match rec_data_type_to_normal dt with
      | Array (dt, dims) -> Array (dt, dim :: dims)
      | dt -> Array (dt, [ dim ]))
