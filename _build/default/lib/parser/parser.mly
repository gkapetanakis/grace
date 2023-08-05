%{ open Ast %}

%left OR
%left AND
%nonassoc UNOT
// %nonassoc UCOMP
%left PLUS MINUS
%left MULT DIV MOD
%nonassoc USIGN

%nonassoc THEN
%nonassoc ELSE

%start <program>    program

%type <func_def>    func_def
%type <header>      header
%type <local_def>   local_def
%type <block>       block
%type <ret_type>    ret_type
%type <fpar_def>    fpar_def
%type <fpar_type>   fpar_type
%type <data_type>   data_type
%type <var_type>    var_type
%type <func_decl>   func_decl
%type <var_def>     var_def
%type <l_value>     l_value
%type <expr>        expr
%type <func_call>   func_call
%type <cond>        cond

%%

let program :=
    ~ = func_def; EOF;
    { MainFunction func_def }

let func_def :=   
    ~ = header; local_defs = list(local_def); ~ = block;
    { { header = header ; local_defs = local_defs ; block = block } }

let header :=
    FUN; id = ID; LEFT_PAR; fpar_defs = separated_list(SEMICOLON, fpar_def); RIGHT_PAR; COLON; ~ = ret_type;   
    { { name = id ; fpar_defs = fpar_defs ; ret_type = ret_type } }

let fpar_def :=
    ref = option(REF); ids = separated_nonempty_list(COMMA, ID); COLON; ~ = fpar_type;
    { { ref = Option.is_some ref ; ids = ids ; fpar_type = fpar_type } }

let data_type :=
        INT;
    { Int }
    |   CHAR;
    { Char }

let var_type :=
    ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {   if List.length dimensions = 0
        then DataType data_type
        else Array (data_type, dimensions) }

let ret_type :=
        NOTHING;
    { Nothing }
    |   ~ = data_type; 
    { RetType data_type }

let fpar_type :=
        ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {   if List.length dimensions = 0
        then (DataType data_type, false)
        else (Array (data_type, dimensions), false) }
    
    |   ~ = data_type; LEFT_BRACKET; RIGHT_BRACKET; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    { (Array (data_type, dimensions), true) }


let local_def :=   
        ~ = func_def;
    { LocalFuncDef func_def }
    |   ~ = func_decl;
    { LocalFuncDecl func_decl }
    |   ~ = var_def;
    { LocalVarDef var_def }

let func_decl :=   
    ~ = header; SEMICOLON;                                      
    { header }

let var_def :=   
    VAR; ids = separated_nonempty_list(COMMA, ID); COLON; ~ = var_type; SEMICOLON;                   
    { { ids = ids ; var_type = var_type } }

let stmt :=   
        SEMICOLON;                                             
    { EmptyStatement }
    |   ~ = l_value; ASSIGN; ~ = expr; SEMICOLON;                           
    { Assign (l_value, expr) }
    |   ~ = block;                                           
    { Block block }
    |   ~ = func_call; SEMICOLON;                                   
    { FuncCall func_call }
    |   IF; ~ = cond; THEN; ~ = stmt;                               
    { IfThenElse (cond, stmt, None) }
    |   IF; ~ = cond; THEN; stmt1 = stmt; ELSE; stmt2 = stmt;                     
    { IfThenElse (cond, stmt1, Some stmt2) }
    |   WHILE; ~ = cond; DO; ~ = stmt;                        
    { WhileLoop (cond, stmt) }
    |   RETURN; expr_o = option(expr); SEMICOLON;                              
    { ReturnStmt expr_o }

let block :=   
    LEFT_CURL; stmt_list = list(stmt); RIGHT_CURL;                                     
    { stmt_list }

let func_call :=   
    id = ID; LEFT_PAR; expr_list = separated_list(COMMA, expr); RIGHT_PAR;                     
    { { name = id ; params = expr_list } }

let l_value :=   
        id = ID;                                              
    { Identifier id }
    |   lambda_string = LIT_STR;                                         
    { LambdaString lambda_string }
    |   ~ = l_value; LEFT_BRACKET; ~ = expr; RIGHT_BRACKET;                            
    { ArrayAccess (l_value, expr) }

let expr :=   
        lit_int = LIT_INT;                                         
    { LiteralInt lit_int }
    |   lit_char = LIT_CHAR;                                        
    { LiteralChar lit_char }
    |   ~ = l_value;                                         
    { LValue l_value }
    |   LEFT_PAR; ~ = expr; RIGHT_PAR;                                    
    { expr }
    |   ~ = func_call;                                       
    { FuncCall func_call }
    |   PLUS; ~ = expr;  %prec USIGN                              
    { Signed (Positive, expr) }
    |   MINUS; ~ = expr;  %prec USIGN                                      
    { Signed (Negative, expr) }
    |  e1 = expr;  PLUS; e2 = expr;                            
    { AritOp (e1, Add, e2) }
    |   e1 = expr;  MINUS; e2 = expr;                            
    { AritOp (e1, Subtract, e2) }    
    |   e1 = expr;  MULT; e2 = expr;                            
    { AritOp (e1, Multiply, e2) }
    |   e1 = expr;  DIV; e2 = expr;                            
    { AritOp (e1, Divide, e2) }
    |   e1 = expr;  MOD; e2 = expr;                            
    { AritOp (e1, Modulo, e2) }

let cond :=   
        LEFT_PAR; ~ = cond; RIGHT_PAR;                                    
    { cond }
    |   NOT; ~ = cond; %prec UNOT                                       
    { LogicalNot cond }
    |   c1 = cond; AND; c2 = cond;                                  
    { LogicOp (c1, And, c2) }
    |   c1 = cond; OR ; c2 = cond;                                      
    { LogicOp (c1, Or, c2) }
    |   e1 = expr; EQ ; e2 = expr; (* %prec UCOMP *)   
    { CompOp (e1, Equal, e2) }
    |   e1 = expr; NOT_EQ ; e2 = expr; (* %prec UCOMP *)   
    { CompOp (e1, NotEqual, e2) }
    |   e1 = expr; LESS ; e2 = expr; (* %prec UCOMP *)   
    { CompOp (e1, Less, e2) }
    |   e1 = expr; MORE ; e2 = expr; (* %prec UCOMP *)   
    { CompOp (e1, More, e2) }
    |   e1 = expr; LESS_EQ; e2 = expr; (* %prec UCOMP *)   
    { CompOp (e1, LessEqual, e2) }
    |   e1 = expr; MORE_EQ; e2 = expr; (* %prec UCOMP *)   
    { CompOp (e1, MoreEqual, e2) }