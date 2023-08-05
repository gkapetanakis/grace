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

%token PLUS         
%token MINUS        
%token MULT         

%token EQ           
%token NOT_EQ       
%token LESS         
%token MORE         
%token LESS_EQ      
%token MORE_EQ      
%token LEFT_PAR     
%token RIGHT_PAR    
%token LEFT_BRACKET 
%token RIGHT_BRACKET
%token LEFT_CURL    
%token RIGHT_CURL   
%token COMMA        
%token SEMICOLON    
%token COLON        
%token ASSIGN

%%