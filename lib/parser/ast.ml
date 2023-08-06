(* ast.ml *)
type arit_op =
    | Add
    | Subtract
    | Multiply
    | Divide
    | Modulo

type unary_arit_op =
    | Positive
    | Negative

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

type l_value =
    | Identifier of string
    | LambdaString of string
    | ArrayAccess of l_value * expr


and expr =
    | LiteralInt of int
    | LiteralChar of char
    | LValue of l_value
    | EFuncCall of func_call
    | Signed of unary_arit_op * expr
    | AritOp of expr * arit_op * expr

and func_call = {
    name: string;
    params: expr list;
}

type cond =
    | LogicalNot of cond
    | LogicOp of cond * logic_op * cond
    | CompOp of expr * comp_op * expr

type stmt =
    | EmptyStatement
    | Assign of l_value * expr
    | Block of block
    | SFuncCall of func_call
    | IfThenElse of cond * stmt * stmt option
    | WhileLoop of cond * stmt
    | ReturnExpr of expr option

and block = stmt list

type header = {
    name: string;
    fpar_defs: fpar_def list;
    ret_type: ret_type;
}

type func_decl = header

type func_def = {
    header: header;
    local_defs: local_def list;
    block: block;
}

and local_def =
    | LocalFuncDef of func_def
    | LocalFuncDecl of func_decl
    | LocalVarDef of var_def

type program = MainFunction of func_def