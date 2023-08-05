(* token declarations *)
%token EOF

%token <string> ID
%token <int> LIT_INT
%token <char> LIT_CHAR
%token <string> LIT_STR

%token AND
%token CHAR
%token DIV
%token DO
%token ELSE
%token FUN
%token IF
%token INT
%token MOD
%token NOT
%token NOTHING
%token OR
%token REF
%token RETURN
%token THEN
%token VAR
%token WHILE

%token PLUS                     "+"
%token MINUS                    "-"
%token MULT                     "*"

%token EQ                       "="
%token NOT_EQ                   "#"
%token LESS                     "<"
%token MORE                     ">"
%token LESS_EQ                  "<="
%token MORE_EQ                  ">="
%token LEFT_PAR                 "("
%token RIGHT_PAR                ")"
%token LEFT_BRACKET             "["
%token RIGHT_BRACKET            "]"
%token LEFT_CURL                "{"
%token RIGHT_CURL               "}"
%token COMMA                    ","
%token SEMICOLON                ";"
%token COLON                    ":"
%token ASSIGN                   "<-"

%left OR
%left AND
%nonassoc UNOT
// %nonassoc UCOMP
%left "+" "-"
%left "*" DIV MOD
%nonassoc USIGN

%nonassoc THEN
%nonassoc ELSE

%start <unit> program
%type <unit> func_def
%type <unit> header
%type <unit> local_def
%type <unit> block
%type <unit> ret_type
%type <unit> fpar_def
%type <unit> fpar_type
%type <unit> data_type
%type <unit> var_type
%type <unit> func_decl
%type <unit> var_def
%type <unit> l_value
%type <unit> expr
%type <unit> func_call
%type <unit> cond

%%


let program :=
    func_def; EOF;
                                                                    { () }

let func_def :=   
    header; list(local_def); block;
                                                                    { () }

let header :=
    FUN; ID; "("; separated_list(";", fpar_def); ")"; ":"; ret_type;   
                                                                    { () }

let fpar_def :=
    option(REF); separated_nonempty_list(",", ID); ":"; fpar_type;
                                                                    { () }

let data_type :=
        INT;
                                                                    { () }
    |   CHAR;
                                                                    { () }

let var_type :=
    data_type; list(delimited("[", LIT_INT, "]"));
                                                                    { () }

let ret_type :=
        NOTHING;
                                                                    { () }
    |   data_type; 
                                                                    { () }

let fpar_type :=
        data_type; list(delimited("[", LIT_INT, "]"));
                                                                    { () }
    |   data_type; "["; "]"; list(delimited("[", LIT_INT, "]"));
                                                                    { () }


let local_def :=   
        func_def;
                                                                    { () }
    |   func_decl;
                                                                    { () }
    |   var_def;
                                                                    { () }

let func_decl :=   
    header; ";";                                      
                                                                    { () }

let var_def :=   
    VAR; separated_nonempty_list(",", ID); ":"; var_type; ";";                   
                                                                    { () }

let stmt :=   
        ";";                                             
                                                                    { () }
    |   l_value; "<-"; expr; ";";                           
                                                                    { () }
    |   block;                                           
                                                                    { () }
    |   func_call; ";";                                   
                                                                    { () }
    |   IF; cond; THEN; stmt;                               
                                                                    { () }
    |   IF; cond; THEN; stmt; ELSE; stmt;                     
                                                                    { () }
    |   WHILE; cond; DO; stmt;                        
                                                                    { () }
    |   RETURN; option(expr); ";";                              
                                                                    { () }

let block :=   
    "{"; list(stmt); "}";                                     
                                                                    { () }

let func_call :=   
    ID; "("; separated_list(",", expr); ")";                     
                                                                    { () }

let l_value :=   
        ID;                                              
                                                                    { () }
    |   LIT_STR;                                         
                                                                    { () }
    |   l_value; "["; expr; "]";                            
                                                                    { () }

let expr :=   
        LIT_INT;                                         
                                                                    { () }
    |   LIT_CHAR;                                        
                                                                    { () }
    |   l_value;                                         
                                                                    { () }
    |   "("; expr; ")";                                    
                                                                    { () }
    |   func_call;                                       
                                                                    { () }
    |   "+"; expr;  %prec USIGN                              
                                                                    { () }
    |   "-"; expr;  %prec USIGN                                      
                                                                    { () }
    |   expr;  "+"; expr;                            
                                                                    { () }
    |   expr;  "-"; expr;                            
                                                                    { () }    
    |   expr;  "*"; expr;                            
                                                                    { () }
    |   expr;  DIV; expr;                            
                                                                    { () }
    |   expr;  MOD; expr;                            
                                                                    { () }

let cond :=   
        "("; cond; ")";                                    
                                                                    { () }
    |   NOT; cond; %prec UNOT                                       
                                                                    { () }
    |   cond; AND; cond;                                  
                                                                    { () }
    |   cond; OR ; cond;                                      
                                                                    { () }
    |   expr; "=" ; expr; (* %prec UCOMP *)   
                                                                    { () }
    |   expr; "#" ; expr; (* %prec UCOMP *)   
                                                                    { () }
    |   expr; "<" ; expr; (* %prec UCOMP *)   
                                                                    { () }
    |   expr; ">" ; expr; (* %prec UCOMP *)   
                                                                    { () }
    |   expr; "<="; expr; (* %prec UCOMP *)   
                                                                    { () }
    |   expr; ">="; expr; (* %prec UCOMP *)   
                                                                    { () }