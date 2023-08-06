(* ast.ml *)
type arit_op =
    | Add
    | Subtract
    | Multiply
    | Divide
    | Modulo

let pprint_arit_op = function
    | Add -> "+"
    | Subtract -> "-"
    | Multiply -> "*"
    | Divide -> "div"
    | Modulo -> "mod"

type unary_arit_op =
    | Positive
    | Negative

let pprint_unitary_op = function
    | Positive -> "+"
    | Negative -> "-"

type comp_op = 
    | Equal
    | NotEqual
    | Less
    | More
    | LessEqual
    | MoreEqual

let pprint_comp_op = function
    | Equal -> "="
    | NotEqual -> "#"
    | Less -> "<"
    | More -> ">"
    | LessEqual -> "<="
    | MoreEqual -> ">="

type logic_op =
    | And
    | Or

let pprint_logic_op = function
    | And -> "and"
    | Or -> "or"

type data_type =
    | Int
    | Char

let pprint_data_type = function
    | Int -> "int"
    | Char -> "char"

type var_type =
    | DataType of data_type
    | Array of data_type * int list

let rec print_dims d =
    match d with
         [] -> ""
        | h::tt -> "[" ^ string_of_int h ^ "]" ^ print_dims tt

let pprint_var_type = function
    | DataType dt -> pprint_data_type dt
    | Array (dt, dim) -> pprint_data_type dt ^ print_dims dim

type ret_type =
    | Nothing
    | RetType of data_type

let pprint_ret_type = function
    | Nothing -> "nothing"
    | RetType rt -> pprint_data_type rt 

(* true means first dimension is not declared *)
type fpar_type =
    var_type * bool

let pprint_fpar_type fp =
    match fp with
         (vt, false) -> pprint_var_type vt
        | (Array (dt, dim), true) ->  pprint_data_type dt ^ "[]" ^ print_dims dim
        | (DataType dt, true) -> pprint_data_type dt ^ "[]"

type fpar_def = {
    ref: bool;
    ids: string list;
    fpar_type: fpar_type;
}

let pprint_fpar_def fpd =
    let rf = if fpd.ref = true then "ref " else  ""
    in
        rf ^ List.fold_left (fun init a -> (if init = "" then "" else init ^ ", ") ^ a) "" fpd.ids ^ ": " ^ pprint_fpar_type fpd.fpar_type

type var_def = {
    ids: string list;
    var_type: var_type;
}

let pprint_var_def vd =
    List.fold_left (fun init a -> (if init = "" then "" else init ^ ", ") ^ a) "" vd.ids ^ ": " ^ pprint_var_type vd.var_type ^ ";\n"

type l_value =
    | Identifier of string
    | LambdaString of string
    | ArrayAccess of l_value * expr


and expr =
    | LiteralInt of int
    | LiteralChar of char
    | LValue of l_value
    | FuncCall of func_call
    | Signed of unary_arit_op * expr
    | AritOp of expr * arit_op * expr

and func_call = {
    name: string;
    params: expr list;
}

let rec pprint_lvalue lv =
    match lv with
          Identifier s -> s
        | LambdaString s -> s
        | ArrayAccess (lvv, expr) -> pprint_lvalue lvv ^ "[" ^ pprint_expr expr ^ "]"

and pprint_expr ex =
    match ex with
          LiteralInt i -> string_of_int i
        | LiteralChar c -> String.make 1 c
        | LValue lvvv -> pprint_lvalue lvvv
        | FuncCall fc -> pprint_func_call fc
        | Signed (s, n) -> pprint_unitary_op s ^ " " ^ pprint_expr n
        | AritOp (e1, op, e2) -> pprint_expr e1 ^ " " ^ pprint_arit_op op ^ " " ^ pprint_expr e2 

and pprint_func_call f =
    f.name ^ "(" ^ List.fold_left (fun init a -> (if init = "" then "" else init ^ ", ") ^ pprint_expr a) "" f.params ^ ")"

type cond =
    | LogicalNot of cond
    | LogicOp of cond * logic_op * cond
    | CompOp of expr * comp_op * expr

let rec pprint_cond cc =
    match cc with
          LogicalNot c -> "not " ^ pprint_cond c 
        | LogicOp (c1, op, c2) -> pprint_cond c1 ^ " " ^ pprint_logic_op op ^ " " ^ pprint_cond c2
        | CompOp (e1, op, e2) -> pprint_expr e1 ^ " " ^ pprint_comp_op op ^ " " ^ pprint_expr e2

type stmt =
    | EmptyStatement
    | Assign of l_value * expr
    | Block of block
    | FuncCall of func_call
    | IfThenElse of cond * stmt * stmt option
    | WhileLoop of cond * stmt
    | ReturnExpr of expr option

and block = stmt list

let rec pprint_stmt st =
    match st with
          EmptyStatement -> ";\n"
        | Assign (lv, expr) -> pprint_lvalue lv ^ "<-" ^ pprint_expr expr ^ "\n"
        | Block b -> pprint_block b
        | FuncCall fc -> pprint_func_call fc ^ ";\n"
        | IfThenElse (c, st1, o_st2) -> "if " ^ pprint_cond c ^ "\nthen " ^ pprint_stmt st1 ^ (
            if Option.is_none o_st2 then "\n"
            else "\nelse " ^ " " ^ pprint_stmt (Option.get o_st2) ^ "\n"
        )
        | WhileLoop (c, stmt) -> "while " ^ pprint_cond c ^ "\n" ^ pprint_stmt stmt ^ "\n"
        | ReturnExpr e -> "return " ^ (if Option.is_none e then "" else pprint_expr (Option.get e)) ^ ";\n"

and pprint_block b =
   "{" ^ List.fold_left (fun init a -> (if init = "" then "" else init ^ ";\n") ^ pprint_stmt a) "" b ^ "}"

type header = {
    name: string;
    fpar_defs: fpar_def list;
    ret_type: ret_type;
}

let pprint_header h =
    "fun " ^ h.name ^ "(" ^ List.fold_left (fun init a -> (if init = "" then "" else init ^ "; ") ^ pprint_fpar_def a) "" h.fpar_defs ^ ") : " ^ pprint_ret_type h.ret_type

type func_decl = header

let pprint_func_decl dcl = pprint_header dcl ^ ";\n"

type func_def = {
    header: header;
    local_defs: local_def list;
    block: block;
}

and local_def =
    | LocalFuncDef of func_def
    | LocalFuncDecl of func_decl
    | LocalVarDef of var_def

let rec pprint_func_def fd =
    pprint_header fd.header ^ "\n" ^
    List.fold_left (fun init a -> (if init = "" then "" else init ^ ";\n") ^ pprint_local_def a) "" fd.local_defs ^
    pprint_block fd.block

and pprint_local_def ld =
    match ld with
          LocalFuncDef fdd -> pprint_func_def fdd
        | LocalFuncDecl fdc -> pprint_func_decl fdc
        | LocalVarDef vd -> pprint_var_def vd

type program = MainFunction of func_def

let pprint_program a_program =
    match a_program with
        MainFunction pg -> pprint_func_def pg