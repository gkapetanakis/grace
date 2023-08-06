open Ast

let pprint_arit_op = function
    | Add -> "+"
    | Subtract -> "-"
    | Multiply -> "*"
    | Divide -> "div"
    | Modulo -> "mod"

let pprint_unitary_op = function
    | Positive -> "+"
    | Negative -> "-"

let pprint_comp_op = function
    | Equal -> "="
    | NotEqual -> "#"
    | Less -> "<"
    | More -> ">"
    | LessEqual -> "<="
    | MoreEqual -> ">="

let pprint_data_type = function
    | Int -> "Int"
    | Char -> "Char"

let pprint_logic_op = function
    | And -> "And"
    | Or -> "Or"

let rec print_dims d =
    match d with
         [] -> ""
        | h::tt -> "[" ^ string_of_int h ^ "]" ^ print_dims tt

let pprint_var_type = function
    | DataType dt -> "DataType(" ^ pprint_data_type dt ^ ")"
    | Array (dt, dim) -> "Array(" ^ pprint_data_type dt ^ print_dims dim ^ ")"

let pprint_ret_type = function
    | Nothing -> "Nothing"
    | RetType rt -> "RetType(" ^ pprint_data_type rt ^ ")" 

let pprint_fpar_type fp =
    match fp with
         (vt, false) -> pprint_var_type vt
        | (Array (dt, dim), true) ->  "Array(" ^ pprint_data_type dt ^ "[]" ^ print_dims dim ^ ")"
        | (DataType dt, true) -> "Array(" ^ pprint_data_type dt ^ "[]" ^ ")" (* it really is Array here. *)


let rec pprint_lvalue lv =
    match lv with
          Identifier s -> "Identifier(" ^ s ^ ")"
        | LambdaString s -> "LambdaString(\"" ^ s ^ "\")"
        | ArrayAccess (lvv, expr) -> "ArrayAccess(" ^ pprint_lvalue lvv ^ "[" ^ pprint_expr expr ^ "]" ^ ")"

and pprint_expr ex =
    match ex with
          LiteralInt i -> "LiteralInt(" ^ string_of_int i ^ ")"
        | LiteralChar c -> "LiteralChar('" ^ String.make 1 c ^ "')"
        | LValue lvvv -> "LValue(" ^ pprint_lvalue lvvv ^ ")"
        | EFuncCall fc -> "FuncCall(" ^ pprint_func_call fc ^ ")"
        | Signed (s, n) -> "Signed(" ^ pprint_unitary_op s ^ " " ^ pprint_expr n ^ ")"
        | AritOp (e1, op, e2) -> "AritOp(" ^ pprint_expr e1 ^ " " ^ pprint_arit_op op ^ " " ^ pprint_expr e2 ^ ")" 

and pprint_func_call f =
    f.name ^
    "(" ^ List.fold_left (fun init a -> (if init = "" then "" else init ^ ", ") ^ pprint_expr a) "" f.params ^ ")"


let pprint_fpar_def fpd =
    let rf = if fpd.ref = true then "ref " else  ""
    in
        "FParDef(" ^ rf ^
        List.fold_left (fun init a -> (if init = "" then "" else init ^ ", ") ^ a) "" fpd.ids ^ ": " ^
        pprint_fpar_type fpd.fpar_type ^ ")"
    

let pprint_var_def vd =
    "VarDef(" ^ List.fold_left (fun init a -> (if init = "" then "" else init ^ ", ") ^ a) "" vd.ids ^ ": " ^
    pprint_var_type vd.var_type ^ ")"


let rec pprint_cond cc =
    match cc with
          LogicalNot c -> "LogicalNot(" ^ pprint_cond c ^ ")"
        | LogicOp (c1, op, c2) -> "LogicOp(" ^ pprint_cond c1 ^ " " ^ pprint_logic_op op ^ " " ^ pprint_cond c2 ^ ")"
        | CompOp (e1, op, e2) -> "CompOp(" ^ pprint_expr e1 ^ " " ^ pprint_comp_op op ^ " " ^ pprint_expr e2 ^ ")"


let rec pprint_stmt st =
    match st with
          EmptyStatement -> ""
        | Assign (lv, expr) -> "Assign(" ^ pprint_lvalue lv ^ "<-" ^ pprint_expr expr ^ ")"
        | Block b -> "Block(" ^ pprint_block b ^ ")"
        | SFuncCall fc -> "FuncCall(" ^ pprint_func_call fc ^ ")"
        | IfThenElse (c, st1, o_st2) -> "IfThenElse(If(" ^ pprint_cond c ^ "), Then(" ^ pprint_stmt st1 ^ (
            if Option.is_none o_st2 then "))"
            else "), Else(" ^ pprint_stmt (Option.get o_st2) ^ "))"
        )
        | WhileLoop (c, stmt) -> "WhileLoop(Cond(" ^ pprint_cond c ^ "), Stmt(" ^ pprint_stmt stmt ^ "))"
        | ReturnExpr e -> "ReturnExpr(" ^ (if Option.is_none e then "" else pprint_expr (Option.get e)) ^ ")"

and pprint_block b =
   List.fold_left (fun init a -> init(*(if init = "" then "" else init ^ ";\n") *) ^ pprint_stmt a) "" b

   
let pprint_header h =
    "Header(Name(" ^ h.name ^ ", Params(" ^
    List.fold_left (fun init a -> (if init = "" then "" else init ^ "; ") ^ pprint_fpar_def a) "" h.fpar_defs ^
    "), RetType(" ^ pprint_ret_type h.ret_type ^ "))"

let pprint_func_decl dcl = "FuncDeclaration(" ^ pprint_header dcl ^ ")"


let rec pprint_func_def fd =
    "Function(" ^ pprint_header fd.header ^ "\n" ^
    List.fold_left (fun init a -> (if init = "" then "" else init ^ ", ") ^ pprint_local_def a) "" fd.local_defs ^ "\n" ^
    "Block(" ^ pprint_block fd.block ^ "))"

and pprint_local_def ld =
    match ld with
          LocalFuncDef fdd -> "LocalFuncDef(" ^ pprint_func_def fdd ^ ")"
        | LocalFuncDecl fdc -> "LocalFuncDecl(" ^ pprint_func_decl fdc ^ ")"
        | LocalVarDef vd -> "LocalVarDef(" ^ pprint_var_def vd ^ ")"

let pprint_program a_program =
    match a_program with
        MainFunction pg -> pprint_func_def pg
