%{
  open Ast
  open Symbol
  open Gift
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

(* --- some ideas for what the final types will look like? --- *)
%start <Ast.func_def node> program

%type <Ast.func_def node> func_def
%type <Ast.header node> func_def_header
%type <Ast.header node> header
%type <Ast.param node list> fpar_def
%type <Ast.data> data_type
%type <Ast.data> var_type
%type <Ast.data> ret_type
%type <Ast.data> fpar_type
%type <Ast.local_def node> local_def
%type <Ast.func_decl node> func_decl
%type <Ast.var node list> var_def
%type <Ast.stmt node> stmt
%type <Ast.block node> block
%type <Ast.func_call node> func_call
%type <Ast.l_value node> l_value
%type <Ast.expr node> expr
%type <Ast.uarit> sign_op
%type <Ast.arit> arit_op
%type <Ast.cond node> cond
%type <Ast.logic_op> logic_op
%type <Ast.comp_op> comp_op

%%

let program :=
  | fd = func_def; EOF;
    { fd }

let func_def :=
  | h = header; ld = list(local_def); b = block;
    { wrap_func_def (*!!*) }

let header := 
  | FUN; id = ID; LEFT_PAR; fd = separated_list(SEMICOLON, fpar_def); RIGHT_PAR; COLON; rt = ret_type;   
    { wrap_header (*!!*) }

let fpar_def :=
  | ~ = pass; ids = separated_nonempty_list(COMMA, ID); COLON; dt = fpar_type;
    { List.map (fun id -> wrap_param $loc (id, dt, pass) (*sym_tbl*)) ids }

let var_type :=
  | dt = data_type; dims = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    { }

let ret_type :=
  | NOTHING; { Nothing }
  | ~ = data_type; { data_type }

let fpar_type :=
  | ~ = data_type; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {  }
      
  | ~ = data_type; LEFT_BRACKET; RIGHT_BRACKET; dimensions = list(delimited(LEFT_BRACKET, LIT_INT, RIGHT_BRACKET));
    {  }

let local_def :=   
  | fd = func_def;
    { fd }
  | fd = func_decl;
    { fd }
  | vd = var_def;
    { vd }

let func_decl :=   
  | ~ = header; SEMICOLON;                                      
    { wrap_func_decl $loc header (*!!*) }

let var_def :=   
  | VAR; ids = separated_nonempty_list(COMMA, ID); COLON; dt = var_type; SEMICOLON;                   
    { List.map (fun id -> wrap_param $loc (id, dt) (*sym_tbl*)) ids }

let stmt :=   
  | SEMICOLON;                                             
    { wrap_stmt (*!!*) }
  | ~ = l_value; ASSIGN; ~ = expr; SEMICOLON;                           
    { wrap_stmt (*!!*) }
  | ~ = block;                                           
    { wrap_stmt (*!!*) }
  | ~ = func_call; SEMICOLON;                                   
    { wrap_stmt (*!!*) }
  | IF; ~ = cond; THEN; ~ = stmt;                               
    { wrap_stmt (*!!*) }
  | IF; ~ = cond; THEN; stmt1 = stmt; ELSE; stmt2 = stmt;                     
    { wrap_stmt (*!!*) }
  | WHILE; ~ = cond; DO; ~ = stmt;                        
    { wrap_stmt (*!!*) }
  | RETURN; expr_o = option(expr); SEMICOLON;                              
    { wrap_stmt (*!!*) }

let block :=   
  | LEFT_CURL; stmt_list = list(stmt); RIGHT_CURL;                                    
    { stmt_list }

let func_call :=   
  | id = ID; LEFT_PAR; e_l = separated_list(COMMA, expr); RIGHT_PAR;                     
    { wrap_func_call $loc (id, e_l) }

let l_value :=   
  | id = ID;                                              
    { wrap_l_value $loc id (*!!*) }
  | str = LIT_STR;                                         
    { wrap_l_value $loc str (*!!*) }
  | lv = l_value; LEFT_BRACKET; e = expr; RIGHT_BRACKET;                            
    { wrap_l_value $loc (lv, e) (*!!*) }

let expr :=   
  | li = LIT_INT;                                         
    { wrap_expr $loc li (*!!*) }
  | lc = LIT_CHAR;                                        
    { wrap_expr $loc lc (*!!*) }
  | lv = l_value;                                         
    { wrap_expr $loc lv (*!!*) }
  | LEFT_PAR; ~ = expr; RIGHT_PAR;                                    
    { expr }
  | fc = func_call;                                       
    { wrap_expr $loc fc (*!!*) }
  | op = sign_op; e = expr; %prec USIGN
    { wrap_expr $loc (op, e) (*!!*) }  (* Semantic: expr should be int *)
  | e1 = expr;  op = arit_op; e2 = expr;                            
    { wrap_expr $loc (e1, op, e2) (*!!*) } (* Semantic: e{1,2} should be both int *)

let cond :=   
  | LEFT_PAR; ~ = cond; RIGHT_PAR;                                    
    { cond }
  | NOT; ~ = cond; %prec UNOT                                       
    { wrap_cond $loc cond (*!!*) }
  | c1 = cond; op = logic_op; c2 = cond;                                  
    { wrap_cond $loc (c1, op, c2) (*!!*) } (* AND/OR should be short-circuited, added after semantic analysis? *)
  | e1 = expr; op = comp_op ; e2 = expr; (* %prec UCOMP *)   
    { wrap_cond $loc (e1, op, e2) (*!!*) } (* Semantic: e{1,2} should be both int or both char *)

let data_type :=
  | INT; { Int }
  | CHAR; { Char }

let pass :=
  | { ByValue }
  | REF; { ByReference }

let sign_op ==
  | PLUS; { Pos }
  | MINUS; { Neg }

let arit_op ==
  | PLUS; { Add }
  | MINUS; { Sub }
  | MULT; { Mul }
  | DIV; { Div }
  | MOD; { Mod }

let logic_op ==
  | AND; { And }
  | OR; { Or }

let comp_op ==
  | EQ; { Eq }
  | NOT_EQ; { Neq }
  | LESS; { Lt }
  | MORE; { Gt }
  | LESS_EQ; { Leq }
  | MORE_EQ; { Geq }
