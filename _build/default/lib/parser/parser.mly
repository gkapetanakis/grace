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

%start <program> program

%type <func_def> func_def
%type <header> header
%type <local_def> local_def
%type <unit> block
%type <unit> ret_type
%type <unit> fpar_def
%type <unit> fpar_type
%type <data_type> data_type
%type <fpar_type> var_type
%type <func_decl> func_decl
%type <var_def> var_def
%type <unit> l_value
%type <unit> expr
%type <unit> func_call
%type <unit> cond

%%

let program :=
    ~ = func_def; EOF;
    <>

let func_def :=   
    ~ = header; local_defs = list(local_def); ~ = block;
    { { func_header = header; func_locals = local_defs; func_body = block } }

let header :=
    FUN; id = ID; LEFT_PAR; fpar_defs = separated_list(SEMICOLON, fpar_def); RIGHT_PAR; COLON; ~ = ret_type;   
    { { func_name = id; func_parameters = fpar_defs; func_return_type = ret_type} }

let fpar_def :=
    option(REF); separated_nonempty_list(COMMA, ID); COLON; fpar_type;
    { () }

let data_type :=
        INT;
    { Int }
    |   CHAR;
    { Char }

let var_type :=
    ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    { (data_type, dimensions) }

let ret_type :=
        NOTHING;
    { () }
    |   data_type; 
    { () }

let fpar_type :=
        data_type; list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    { () }
    |   data_type; LEFT_BRACKET; RIGHT_BRACKET; list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    { () }


let local_def :=   
        ~ = func_def;
    { LocalFuncDef func_def }
    |   ~ = func_decl;
    { LocalFuncDecl func_decl }
    |   ~ = var_def;
    { LocalVarDef var_def }

let func_decl :=   
    ~ = header; SEMICOLON;                                      
    <>

let var_def :=   
    VAR; ids = separated_nonempty_list(COMMA, ID); COLON; ~ = var_type; SEMICOLON;                   
    { { ids = ids; var_type = var_type } }

let stmt :=   
        SEMICOLON;                                             
    { () }
    |   l_value; ASSIGN; expr; SEMICOLON;                           
    { () }
    |   block;                                           
    { () }
    |   func_call; SEMICOLON;                                   
    { () }
    |   IF; cond; THEN; stmt;                               
    { () }
    |   IF; cond; THEN; stmt; ELSE; stmt;                     
    { () }
    |   WHILE; cond; DO; stmt;                        
    { () }
    |   RETURN; option(expr); SEMICOLON;                              
    { () }

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