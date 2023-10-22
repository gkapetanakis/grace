type loc = Lexing.position * Lexing.position

(* parser rules will return <something> node types *)
type 'a node = { loc : loc; node : 'a }

let get_loc n = n.loc
let get_node n = n.node

type arit = Add | Sub | Mul | Div | Mod
type uarit = Pos | Neg
type comp = Eq | Neq | Lt | Leq | Gt | Geq
type logic = And | Or
type data = Int | Char | Nothing | Array of data * int option
type var = string * data
type pass = ByValue | ByReference
type param = string * data * pass

type l_value =
  | Id of string
  | LString of string
  | ArrayAccess of l_value node * expr node

and expr =
  | LitInt of int
  | LitChar of char
  | LValue of l_value node
  | EFuncCall of func_call node
  | Signed of uarit * expr node
  | AritOp of expr node * arit * expr node

and func_call = string * expr node list

type cond =
  | Comp of expr node * comp * expr node
  | Logic of cond node * logic * cond node
  | Not of cond node

type stmt =
  | Empty
  | Assign of l_value node * expr node
  | Block of block node
  | SFuncCall of func_call node
  | If of cond node * stmt node option * stmt node option
  | While of cond node * stmt node
  | Return of expr node option

and block = stmt node list

type header = string * param node list * data
type func_decl = header node

type func_def = header node * local_def node list * block node

and local_def =
  | FuncDef of func_def node
  | FuncDecl of func_decl node
  | Var of var node

let rec get_var dt dims =
  match dims with [] -> dt | h :: t -> Array (get_var dt t, Some h)

let get_param dt dims x =
  match (dims, x) with
  | [], false -> dt
  | h :: t, false -> Array (get_var dt t, Some h)
  | dims, true -> Array (get_var dt dims, None)

let rec l_value_dep_on_l_string = function
  | Id _ -> false
  | LString _ -> true
  | ArrayAccess (lv, _) -> l_value_dep_on_l_string (get_node lv)