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
  | ArrayAccess of l_value * expr

and expr =
  | LitInt of int
  | LitChar of char
  | LValue of l_value
  | EFuncCall of func_call
  | Signed of uarit * expr
  | AritOp of expr * arit * expr

and func_call = string * expr list

type cond =
  | Comp of expr * comp * expr
  | Logic of cond * logic * cond
  | Not of cond

type stmt =
  | Empty
  | Assign of l_value * expr
  | Block of block
  | SFuncCall of func_call
  | If of cond * stmt option * stmt option
  | While of cond * stmt
  | Return of expr option

and block = stmt list

type header = string * param list * data
type func_decl = header
type func_def = header * local_def list * block
and local_def =
| FuncDef of func_def
| FuncDecl of func_decl
| Var of var

type loc = Lexing.position * Lexing.position
(* parser rules will return <something> node types *)
type 'a node = { loc: loc; node: 'a }

let rec get_var_type dt dims =
  match dims with
  | [] -> dt
  | h::t -> Array ((get_var_type dt t), Some h)

let get_fpar_type dt dims x =
  match dims, x with
  | [], false -> dt
  | h::t, false -> Array ((get_var_type dt t), Some h)
  | dims, true -> Array ((get_var_type dt dims), None)