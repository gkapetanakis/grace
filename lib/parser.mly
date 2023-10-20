%{
    open Ast
    open Symbol
%}

%left OR
%left AND
%nonassoc UNOT
// %nonassoc UCOMP
%left PLUS MINUS
%left MULT DIV MOD
%nonassoc USIGN

%nonassoc THEN
%nonassoc ELSE

%start <unit> program

%%

let program :=
  | ~ = func_def; EOF;
    {  }

let func_def :=
  | header = func_def_header; local_defs = list(local_def); ~ = block;
    {  }

let func_def_header :=
  | ~ = header;
    {  }

let header := 
  | FUN; id = ID; LEFT_PAR; fpar_defs = separated_list(SEMICOLON, fpar_def); RIGHT_PAR; COLON; ~ = ret_type;   
    {  }

let fpar_def :=
  | ref = option(REF); ids = separated_nonempty_list(COMMA, ID); COLON; ~ = fpar_type;
    {  }

let data_type :=
  | INT;
    {  }
  | CHAR;
    {  }

let var_type :=
  | ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {  }

let ret_type :=
  | NOTHING;
    {  }
  | ~ = data_type; 
    {  }

let fpar_type :=
  | ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {  }
      
  | ~ = data_type; LEFT_BRACKET; RIGHT_BRACKET; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {  }

let local_def :=   
  | ~ = func_def;
    {  }
  | ~ = func_decl;
    {  }
  | ~ = var_def;
    {  }

let func_decl :=   
  | ~ = header; SEMICOLON;                                      
    {  }

let var_def :=   
  | VAR; ids = separated_nonempty_list(COMMA, ID); COLON; ~ = var_type; SEMICOLON;                   
    {  }

let stmt :=   
  | SEMICOLON;                                             
    {  }
  | ~ = l_value; ASSIGN; ~ = expr; SEMICOLON;                           
    {  }
  | ~ = block;                                           
    {  }
  | ~ = func_call; SEMICOLON;                                   
    {  }
  | IF; ~ = cond; THEN; ~ = stmt;                               
    {  }
  | IF; ~ = cond; THEN; stmt1 = stmt; ELSE; stmt2 = stmt;                     
    {  }
  | WHILE; ~ = cond; DO; ~ = stmt;                        
    {  }
  | RETURN; expr_o = option(expr); SEMICOLON;                              
    {  }

let block :=   
  | LEFT_CURL; stmt_list = list(stmt); RIGHT_CURL;                                    
    {  }

let func_call :=   
  | id = ID; LEFT_PAR; expr_list = separated_list(COMMA, expr); RIGHT_PAR;                     
    {  }

let l_value :=   
  | id = ID;                                              
    {  }
  | lambda_string = LIT_STR;                                         
    {  }
  | ~ = l_value; LEFT_BRACKET; ~ = expr; RIGHT_BRACKET;                            
    {  }

let expr :=   
  | lit_int = LIT_INT;                                         
    {  }
  | lit_char = LIT_CHAR;                                        
    {  }
  | ~ = l_value;                                         
    {  }
  | LEFT_PAR; ~ = expr; RIGHT_PAR;                                    
    {  }
  | ~ = func_call;                                       
    {  }
  | ~ = sign_op; ~ = expr;  %prec USIGN
    {  }  (* Semantic: expr should be int *)
  | e1 = expr;  ~ = arit_op; e2 = expr;                            
    {  } (* Semantic: e{1,2} should be both int *)

let sign_op ==
  | PLUS;
    {  }
  | MINUS;
    {  }

let arit_op ==
  | PLUS;
    {  }
  | MINUS;
    {  }
  | MULT;
    {  }
  | DIV;
    {  }
  | MOD;
    {  }

let cond :=   
  | LEFT_PAR; ~ = cond; RIGHT_PAR;                                    
    {  }
  | NOT; ~ = cond; %prec UNOT                                       
    {  }
  | c1 = cond; ~ = logic_op; c2 = cond;                                  
    {  } (* AND/OR should be short-circuited, added after semantic analysis? *)
  | e1 = expr; ~ = comp_op ; e2 = expr; (* %prec UCOMP *)   
    {  } (* Semantic: e{1,2} should be both int or both char *)

let logic_op ==
  | AND;
    {  }
  | OR;
    {  }

let comp_op ==
  | EQ;          
    {  }
  | NOT_EQ;      
    {  }
  | LESS;        
    {  }
  | MORE;        
    {  }
  | LESS_EQ;     
    {  }
  | MORE_EQ;     
    {  }
