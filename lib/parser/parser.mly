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
    { { ref = is_some ref ; ids = ids ; fpar_type = fpar_type } }

let data_type :=
        INT;
    { Int }
    |   CHAR;
    { Char }

let var_type :=
    ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {   if length dimensions = 0
        then DataType data_type
        else Array (data_type, dimensions) }

let ret_type :=
        NOTHING;
    { Nothing }
    |   ~ = data_type; 
    { RetType data_type }

let fpar_type :=
        ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {   if length dimensions = 0
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
    LEFT_CURL; list(stmt); RIGHT_CURL;                                     
    { () }

let func_call :=   
    ID; LEFT_PAR; separated_list(COMMA, expr); RIGHT_PAR;                     
    { () }

let l_value :=   
        ID;                                              
    { () }
    |   LIT_STR;                                         
    { () }
    |   l_value; LEFT_BRACKET; expr; RIGHT_BRACKET;                            
    { () }

let expr :=   
        LIT_INT;                                         
    { () }
    |   LIT_CHAR;                                        
    { () }
    |   l_value;                                         
    { () }
    |   LEFT_PAR; expr; RIGHT_PAR;                                    
    { () }
    |   func_call;                                       
    { () }
    |   PLUS; expr;  %prec USIGN                              
    { () }
    |   MINUS; expr;  %prec USIGN                                      
    { () }
    |   expr;  PLUS; expr;                            
    { () }
    |   expr;  MINUS; expr;                            
    { () }    
    |   expr;  MULT; expr;                            
    { () }
    |   expr;  DIV; expr;                            
    { () }
    |   expr;  MOD; expr;                            
    { () }

let cond :=   
        LEFT_PAR; cond; RIGHT_PAR;                                    
    { () }
    |   NOT; cond; %prec UNOT                                       
    { () }
    |   cond; AND; cond;                                  
    { () }
    |   cond; OR ; cond;                                      
    { () }
    |   expr; EQ ; expr; (* %prec UCOMP *)   
    { () }
    |   expr; NOT_EQ ; expr; (* %prec UCOMP *)   
    { () }
    |   expr; LESS ; expr; (* %prec UCOMP *)   
    { () }
    |   expr; MORE ; expr; (* %prec UCOMP *)   
    { () }
    |   expr; LESS_EQ; expr; (* %prec UCOMP *)   
    { () }
    |   expr; MORE_EQ; expr; (* %prec UCOMP *)   
    { () }