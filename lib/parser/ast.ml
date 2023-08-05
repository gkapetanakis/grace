(* ast.ml *)

type op =
    | Add
    | Subtract
    | Multiply
    | Divide
    | Modulo
    | Equal
    | NotEqual
    | Less
    | LessEqual
    | Greater
    | GreaterEqual
    | And
    | Or

type unary_op =
    | Plus
    | Minus
    | Not

type data_type =
    | Int
    | Char

type fpar_type =
    data_type * int list

type ret_type =
    | Nothing
    | DataType of data_type

type expr =
    | LiteralInt of int
    | LiteralChar of char
    | LiteralString of string
    | LValue of l_value
    | FunctionCall of string * expr list
    | UnaryOp of unary_op * expr
    | BinaryOp of expr * op * expr

and l_value =
    | Identifier of string
    | LambdaString of string
    | ArrayAccess of l_value * expr

type cond =
    | Parenthesized of cond
    | Not of cond
    | BinaryCond of expr * op * expr
    | AndCond of cond * cond
    | OrCond of cond * cond

type stmt =
    | Empty
    | Assignment of l_value * expr
    | Block of stmt list
    | FunctionCallStmt of expr
    | If of cond * stmt * stmt option
    | While of cond * stmt
    | Return of expr option

type local_def =
    | LocalFuncDef of func_def
    | LocalFuncDecl of header
    | LocalVarDef of var_def

and func_def = {
    func_header : header;
    func_locals : local_def list;
    func_body : stmt list;
}

and header = {
    func_name : string;
    func_parameters : (bool * string list) list;  (* bool indicates if the parameter is passed by reference *)
    func_return_type : ret_type;
}

and var_def = {
    ids: string list;
    var_type: fpar_type;
}

type func_decl = header

type program = func_def
