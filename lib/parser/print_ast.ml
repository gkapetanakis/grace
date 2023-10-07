open Ast

let pprint_arit_op offset = function
    | Add -> offset ^ "Add"
    | Subtract -> offset ^ "Subtract"
    | Multiply -> offset ^ "Multiply"
    | Divide -> offset ^ "Divide"
    | Modulo -> offset ^ "Modulo"

let pprint_unitary_op offset = function
    | Positive -> offset ^ "Positive"
    | Negative -> offset ^ "Negative"

let pprint_comp_op offset = function
    | Equal -> offset ^ "Equal"
    | NotEqual -> offset ^ "NotEqual"
    | Less -> offset ^ "Less"
    | More -> offset ^ "More"
    | LessEqual -> offset ^ "LessEqual"
    | MoreEqual -> offset ^ "MoreEqual"

let pprint_data_type offset = function
    | Int -> offset ^ "Int"
    | Char -> offset ^ "Char"

let pprint_logic_op offset = function
    | And -> offset ^ "And"
    | Or -> offset ^ "Or"

let rec print_dims d =
    match d with
         [] -> ""
        | h::t -> "[" ^ string_of_int h ^ "]" ^ print_dims t

let pprint_var_type offset = function
    | DataType dt -> offset ^ "DataType:\n" ^
                    pprint_data_type (offset ^ "--") dt ^ "\n"
    | Array (dt, dim) -> offset ^ "Array:\n" ^
                    pprint_data_type (offset ^ "--") dt ^
                    print_dims dim ^ "\n"

let pprint_ret_type offset = function
    | Nothing -> offset ^ "Nothing\n"
    | RetType rt -> offset ^ "RetType:\n" ^
                    pprint_data_type (offset ^ "--") rt ^ "\n"

let pprint_fpar_type offset fp =
    match fp with
    | (vt, false) -> pprint_var_type offset vt
    | (Array (dt, dim), true) -> offset ^ "Array:\n" ^
                pprint_data_type (offset ^ "--") dt ^ "[]" ^
                print_dims dim ^ "\n"
    | (DataType dt, true) -> offset ^ "Array:\n" ^
                pprint_data_type (offset ^ "--") dt ^ "[]\n"

let rec pprint_lvalue offset lv =
    match lv with
    | Identifier s -> offset ^ "Identifier:\n" ^ offset ^ "--" ^ s ^ "\n"
    | LambdaString s -> offset ^ "LambdaString:\n" ^ offset ^ "--" ^ s ^ "\n"
    | ArrayAccess (lvv, expr) -> offset ^ "ArrayAccess:\n" ^
                                pprint_lvalue (offset ^ "--") lvv ^ "\n" ^
                                pprint_expr (offset ^ "--") expr ^ "\n"

and pprint_expr offset expr =
    match expr with
    | LiteralInt i -> offset ^ "LiteralInt:\n" ^ offset ^ "--" ^ string_of_int i ^ "\n"
    | LiteralChar c -> offset ^ "LiteralChar:\n" ^ offset ^ "--" ^ String.make 1 c ^ "\n"
    | LValue l -> offset ^ "LValue:\n" ^ pprint_lvalue (offset ^ "--") l ^ "\n"
    | EFuncCall fc -> offset ^ "EFuncCall:\n" ^ pprint_func_call (offset ^ "--") fc ^ "\n"
    | Signed (s, e) -> offset ^ "Signed:\n" ^ pprint_unitary_op (offset  ^ "--") s ^ " " ^ pprint_expr "" e ^ "\n"
    | AritOp (e1, o, e2) -> offset ^ "AritOp:\n" ^
                            pprint_expr (offset ^ "--") e1 ^ "\n" ^
                            pprint_arit_op (offset ^ "--") o ^ "\n" ^
                            pprint_expr (offset ^ "--") e2 ^ "\n"
    
and pprint_func_call offset f =
    offset ^ "FuncCall:\n" ^
    offset ^ "--" ^ "Name: " ^ f.name ^ "\n" ^
    offset ^ "--" ^ "Parameters:" ^
    List.fold_left (fun init param ->
        init ^ "\n" ^ pprint_expr (offset ^ "--" ^ "--") param) "" f.params ^ "\n"

let pprint_fpar_def offset fpd =
    offset ^ "FParDef:" ^ (if fpd.ref then " (pass by reference)" else "") ^ "\n" ^
    List.fold_left (fun init fparam ->
    init ^ "\n" ^ offset ^ "--" ^ fparam) "" fpd.ids ^ "\n" ^ offset ^ "--" ^
    "Function Parameter Type:\n" ^ pprint_fpar_type (offset ^ "--" ^ "--") fpd.fpar_type ^ "\n"

let pprint_var_def offset vd =
    offset ^ "VarDef:\n" ^
    List.fold_left (fun init vr ->
        init ^ "\n" ^ offset ^ "--" ^ vr) ""  vd.ids ^ "\n" ^
    offset ^ "--" ^ "Variable Type:\n" ^ pprint_var_type (offset ^ "--" ^ "--") vd.var_type ^ "\n"

let rec pprint_cond offset cond =
    match cond with
    | LogicalNot c -> offset ^ "LogicalNot:\n" ^ pprint_cond (offset ^ "--") c ^ "\n"
    | LogicOp (c1, op, c2) -> offset ^ "LogicOp:\n" ^
        pprint_cond (offset ^ "--") c1 ^ "\n" ^
        pprint_logic_op (offset ^ "--") op ^ "\n" ^
        pprint_cond (offset ^ "--") c2 ^ "\n"
    | CompOp (e1, op, e2) -> offset ^ "CompOp:\n" ^
        pprint_expr (offset ^ "--") e1 ^ "\n" ^
        pprint_comp_op (offset ^ "--") op ^ "\n" ^
        pprint_expr (offset ^ "--") e2 ^ "\n"

let rec pprint_stmt offset st =
    match st with
    | EmptyStatement -> ""
    | Assign (lv, expr) -> offset ^ "Assign:\n" ^
        pprint_lvalue (offset ^ "--") lv ^ "\n" ^
        pprint_expr (offset ^ "--") expr ^ "\n"
    | Block b -> pprint_block (offset ^ "--") b
    | SFuncCall fc -> offset ^ "SFuncCall:\n" ^
        pprint_func_call (offset ^ "--") fc
    | IfThenElse (c, st1, o_st2) ->
        offset ^ "IfThenElse:\n" ^
        pprint_cond (offset ^ "--" ^ "--") c ^ "\n" ^
        offset ^ "--" ^ "Then:\n" ^
        pprint_stmt (offset ^ "--" ^ "--") st1 ^ "\n" ^
        (if Option.is_some o_st2
            then
            offset ^ "--" ^ "Else:\n" ^
            pprint_stmt (offset ^ "--" ^ "--") (Option.get o_st2) ^ "\n"
            else "")
    | WhileLoop (c, stmt) -> offset ^ "WhileLoop:\n" ^
        offset ^ "--" ^ "Cond:\n" ^
        pprint_cond (offset ^ "--" ^ "--") c ^ "\n" ^ offset ^ "--" ^ "Stmt:\n" ^
        pprint_stmt (offset ^ "--" ^ "--") stmt ^ "\n"
    | ReturnExpr e -> offset ^ "ReturnExpr:\n" ^
        (if Option.is_none e then "" else pprint_expr (offset ^ "--") (Option.get e) ^ "\n")

and pprint_block offset b =
    offset ^ "Block:\n" ^
    List.fold_left (fun init st -> 
        init ^ "\n" ^ pprint_stmt (offset ^ "--") st) "" b ^ "\n"

let pprint_header offset h =
    offset ^ "Header:\n" ^ offset ^ "--" ^ "Name: " ^ h.name ^ "\n" ^
    offset ^ "--" ^ "Function Parameter Definitions:\n" ^
    List.fold_left (fun init fpd ->
    init ^ "\n" ^ pprint_fpar_def (offset ^ "--" ^ "--") fpd) "" h.fpar_defs ^ "\n" ^
    offset ^ "--" ^ "ReturnType:\n" ^ pprint_ret_type (offset ^ "--" ^ "--") h.ret_type ^ "\n"

let pprint_func_decl offset dcl =
    offset ^ "Function Declaration:\n" ^ pprint_header (offset ^ "--") dcl ^ "\n"

let rec pprint_func_def offset fd =
    offset ^ "Function:\n" ^ pprint_header (offset ^ "--") fd.header ^ "\n" ^
    offset ^ "--" ^ "Local Definitions:\n" ^
    pprint_local_defs (offset ^ "--" ^ "--") fd.local_defs ^ "\n" ^
    pprint_block (offset ^ "--") fd.block ^ "\n"

and pprint_local_defs offset ldfs =
    List.fold_left (fun init ldf ->
    init ^ "\n" ^ pprint_local_def offset ldf) "" ldfs ^ "\n"

and pprint_local_def offset ldf =
    match ldf with
    | LocalFuncDef f -> offset ^ "LocalFuncDef:\n" ^ pprint_func_def (offset ^ "--") f ^ "\n"
    | LocalFuncDecl f -> offset ^ "LocalFuncDecl:\n" ^ pprint_func_decl (offset ^ "--") f ^ "\n"
    | LocalVarDef v -> offset ^ "LocalVarDef:\n" ^ pprint_var_def (offset ^ "--") v ^ "\n"

let pprint_program a_program =
    match a_program with
        MainFunction pg -> pprint_func_def "" pg