(* ast.ml *)
type data_type =
    | Int
    | Char

type var_type =
    | DataType of data_type
    | Array of data_type * int list

type ret_type =
    | Nothing
    | RetType of data_type

(* true means first dimension is not declared *)
type fpar_type =
    var_type * bool

type fpar_def = {
    ref: bool;
    ids: string list;
    fpar_type: fpar_type;
}

type var_def = {
    ids: string list;
    var_type: var_type;
}

type arit_op =
    | Add
    | Subtract
    | Multiply
    | Divide
    | Modulo

type comp_op = 
    | Equal
    | NotEqual
    | Less
    | More
    | LessEqual
    | MoreEqual

type logic_op =
    | And
    | Or

type l_value =
    | Identifier of string
    | LambdaString of string * bool
    | ArrayAccess of l_value * expr

(* we don't need Positive of expr *)
and expr =
    | LiteralInt of int
    | LiteralChar of char
    | LValue of l_value
    | Expression of expr
    | Negative of expr
    | AritOp of expr * arit_op * expr

type cond =
    | LogicalNot of cond
    | LogicOp of cond * logic_op * cond
    | CompOp of expr * comp_op * expr

type func_call = {
    name: string;
    params: expr list;
}

type stmt =
    | EmptyStatement
    | Assign of l_value * expr
    | Block of block
    | FuncCall of func_call
    | IfThenElse of cond * stmt * stmt option
    | WhileLoop of cond * stmt
    | ReturnStmt of stmt option

and block = stmt list

type header = {
    name: string;
    fpar_defs: fpar_def list;
    ret_type: ret_type;
}

type func_def = {
    header: header;
    local_defs: local_def list;
    block: block;
}

and local_def =
    | LocalFuncDef of func_def
    | LocalFuncDecl of func_decl
    | LocalVarDef of var_def

and func_decl = header

type program = MainFunction of func_def