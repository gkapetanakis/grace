
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = Tokens_lib.Tokens.token
  
end

include MenhirBasics

# 1 "lib/parser/parser.mly"
   open Ast 
# 19 "lib/parser/parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_program) _menhir_state
    (** State 000.
        Stack shape : .
        Start symbol: program. *)

  | MenhirState003 : (('s, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_ID, _menhir_box_program) _menhir_state
    (** State 003.
        Stack shape : FUN ID.
        Start symbol: program. *)

  | MenhirState006 : (('s, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_state
    (** State 006.
        Stack shape : option(REF).
        Start symbol: program. *)

  | MenhirState008 : (('s, _menhir_box_program) _menhir_cell1_ID, _menhir_box_program) _menhir_state
    (** State 008.
        Stack shape : ID.
        Start symbol: program. *)

  | MenhirState011 : ((('s, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_state
    (** State 011.
        Stack shape : option(REF) separated_nonempty_list(COMMA,ID).
        Start symbol: program. *)

  | MenhirState015 : (((('s, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_state
    (** State 015.
        Stack shape : option(REF) separated_nonempty_list(COMMA,ID) data_type.
        Start symbol: program. *)

  | MenhirState017 : ((((('s, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_cell1_LEFT_BRACKET, _menhir_box_program) _menhir_state
    (** State 017.
        Stack shape : option(REF) separated_nonempty_list(COMMA,ID) data_type LEFT_BRACKET.
        Start symbol: program. *)

  | MenhirState020 : (('s, _menhir_box_program) _menhir_cell1_LEFT_BRACKET _menhir_cell0_LIT_INT, _menhir_box_program) _menhir_state
    (** State 020.
        Stack shape : LEFT_BRACKET LIT_INT.
        Start symbol: program. *)

  | MenhirState026 : ((('s, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_ID, _menhir_box_program) _menhir_cell1_loption_separated_nonempty_list_SEMICOLON_fpar_def__, _menhir_box_program) _menhir_state
    (** State 026.
        Stack shape : FUN ID loption(separated_nonempty_list(SEMICOLON,fpar_def)).
        Start symbol: program. *)

  | MenhirState031 : (('s, _menhir_box_program) _menhir_cell1_fpar_def, _menhir_box_program) _menhir_state
    (** State 031.
        Stack shape : fpar_def.
        Start symbol: program. *)

  | MenhirState034 : (('s, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_state
    (** State 034.
        Stack shape : header.
        Start symbol: program. *)

  | MenhirState035 : (('s, _menhir_box_program) _menhir_cell1_VAR, _menhir_box_program) _menhir_state
    (** State 035.
        Stack shape : VAR.
        Start symbol: program. *)

  | MenhirState037 : ((('s, _menhir_box_program) _menhir_cell1_VAR, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_state
    (** State 037.
        Stack shape : VAR separated_nonempty_list(COMMA,ID).
        Start symbol: program. *)

  | MenhirState040 : (((('s, _menhir_box_program) _menhir_cell1_VAR, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_state
    (** State 040.
        Stack shape : VAR separated_nonempty_list(COMMA,ID) data_type.
        Start symbol: program. *)

  | MenhirState043 : (('s, _menhir_box_program) _menhir_cell1_local_def, _menhir_box_program) _menhir_state
    (** State 043.
        Stack shape : local_def.
        Start symbol: program. *)

  | MenhirState045 : (('s, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_state
    (** State 045.
        Stack shape : header.
        Start symbol: program. *)

  | MenhirState047 : ((('s, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_cell1_list_local_def_, _menhir_box_program) _menhir_state
    (** State 047.
        Stack shape : header list(local_def).
        Start symbol: program. *)

  | MenhirState048 : (('s, _menhir_box_program) _menhir_cell1_LEFT_CURL, _menhir_box_program) _menhir_state
    (** State 048.
        Stack shape : LEFT_CURL.
        Start symbol: program. *)

  | MenhirState049 : (('s, _menhir_box_program) _menhir_cell1_WHILE, _menhir_box_program) _menhir_state
    (** State 049.
        Stack shape : WHILE.
        Start symbol: program. *)

  | MenhirState050 : (('s, _menhir_box_program) _menhir_cell1_PLUS, _menhir_box_program) _menhir_state
    (** State 050.
        Stack shape : PLUS.
        Start symbol: program. *)

  | MenhirState051 : (('s, _menhir_box_program) _menhir_cell1_MINUS, _menhir_box_program) _menhir_state
    (** State 051.
        Stack shape : MINUS.
        Start symbol: program. *)

  | MenhirState055 : (('s, _menhir_box_program) _menhir_cell1_LEFT_PAR, _menhir_box_program) _menhir_state
    (** State 055.
        Stack shape : LEFT_PAR.
        Start symbol: program. *)

  | MenhirState057 : (('s, _menhir_box_program) _menhir_cell1_ID, _menhir_box_program) _menhir_state
    (** State 057.
        Stack shape : ID.
        Start symbol: program. *)

  | MenhirState062 : (('s, _menhir_box_program) _menhir_cell1_l_value, _menhir_box_program) _menhir_state
    (** State 062.
        Stack shape : l_value.
        Start symbol: program. *)

  | MenhirState066 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 066.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState068 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 068.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState070 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 070.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState072 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 072.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState074 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 074.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState077 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 077.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState083 : (('s, _menhir_box_program) _menhir_cell1_NOT, _menhir_box_program) _menhir_state
    (** State 083.
        Stack shape : NOT.
        Start symbol: program. *)

  | MenhirState084 : (('s, _menhir_box_program) _menhir_cell1_LEFT_PAR, _menhir_box_program) _menhir_state
    (** State 084.
        Stack shape : LEFT_PAR.
        Start symbol: program. *)

  | MenhirState086 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 086.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState088 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 088.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState090 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 090.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState092 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 092.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState094 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 094.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState096 : (('s, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 096.
        Stack shape : expr.
        Start symbol: program. *)

  | MenhirState100 : (('s, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 100.
        Stack shape : cond.
        Start symbol: program. *)

  | MenhirState103 : (('s, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 103.
        Stack shape : cond.
        Start symbol: program. *)

  | MenhirState107 : ((('s, _menhir_box_program) _menhir_cell1_WHILE, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 107.
        Stack shape : WHILE cond.
        Start symbol: program. *)

  | MenhirState109 : (('s, _menhir_box_program) _menhir_cell1_RETURN, _menhir_box_program) _menhir_state
    (** State 109.
        Stack shape : RETURN.
        Start symbol: program. *)

  | MenhirState113 : (('s, _menhir_box_program) _menhir_cell1_IF, _menhir_box_program) _menhir_state
    (** State 113.
        Stack shape : IF.
        Start symbol: program. *)

  | MenhirState115 : ((('s, _menhir_box_program) _menhir_cell1_IF, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_state
    (** State 115.
        Stack shape : IF cond.
        Start symbol: program. *)

  | MenhirState117 : (((('s, _menhir_box_program) _menhir_cell1_IF, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_cell1_stmt, _menhir_box_program) _menhir_state
    (** State 117.
        Stack shape : IF cond stmt.
        Start symbol: program. *)

  | MenhirState120 : (('s, _menhir_box_program) _menhir_cell1_l_value, _menhir_box_program) _menhir_state
    (** State 120.
        Stack shape : l_value.
        Start symbol: program. *)

  | MenhirState127 : (('s, _menhir_box_program) _menhir_cell1_stmt, _menhir_box_program) _menhir_state
    (** State 127.
        Stack shape : stmt.
        Start symbol: program. *)


and ('s, 'r) _menhir_cell1_cond = 
  | MenhirCell1_cond of 's * ('s, 'r) _menhir_state * (Ast.cond)

and ('s, 'r) _menhir_cell1_data_type = 
  | MenhirCell1_data_type of 's * ('s, 'r) _menhir_state * (Ast.data_type)

and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (Ast.expr)

and ('s, 'r) _menhir_cell1_fpar_def = 
  | MenhirCell1_fpar_def of 's * ('s, 'r) _menhir_state * (Ast.fpar_def)

and ('s, 'r) _menhir_cell1_header = 
  | MenhirCell1_header of 's * ('s, 'r) _menhir_state * (Ast.header)

and ('s, 'r) _menhir_cell1_l_value = 
  | MenhirCell1_l_value of 's * ('s, 'r) _menhir_state * (Ast.l_value)

and ('s, 'r) _menhir_cell1_list_local_def_ = 
  | MenhirCell1_list_local_def_ of 's * ('s, 'r) _menhir_state * (Ast.local_def list)

and ('s, 'r) _menhir_cell1_local_def = 
  | MenhirCell1_local_def of 's * ('s, 'r) _menhir_state * (Ast.local_def)

and ('s, 'r) _menhir_cell1_loption_separated_nonempty_list_SEMICOLON_fpar_def__ = 
  | MenhirCell1_loption_separated_nonempty_list_SEMICOLON_fpar_def__ of 's * ('s, 'r) _menhir_state * (Ast.fpar_def list)

and ('s, 'r) _menhir_cell1_option_REF_ = 
  | MenhirCell1_option_REF_ of 's * ('s, 'r) _menhir_state * (unit option)

and ('s, 'r) _menhir_cell1_separated_nonempty_list_COMMA_ID_ = 
  | MenhirCell1_separated_nonempty_list_COMMA_ID_ of 's * ('s, 'r) _menhir_state * (string list)

and ('s, 'r) _menhir_cell1_stmt = 
  | MenhirCell1_stmt of 's * ('s, 'r) _menhir_state * (Ast.stmt)

and ('s, 'r) _menhir_cell1_FUN = 
  | MenhirCell1_FUN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_ID = 
  | MenhirCell1_ID of 's * ('s, 'r) _menhir_state * (
# 4 "lib/tokens/tokens.mly"
       (string)
# 301 "lib/parser/parser.ml"
)

and 's _menhir_cell0_ID = 
  | MenhirCell0_ID of 's * (
# 4 "lib/tokens/tokens.mly"
       (string)
# 308 "lib/parser/parser.ml"
)

and ('s, 'r) _menhir_cell1_IF = 
  | MenhirCell1_IF of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LEFT_BRACKET = 
  | MenhirCell1_LEFT_BRACKET of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LEFT_CURL = 
  | MenhirCell1_LEFT_CURL of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LEFT_PAR = 
  | MenhirCell1_LEFT_PAR of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_LIT_INT = 
  | MenhirCell0_LIT_INT of 's * (
# 5 "lib/tokens/tokens.mly"
       (int)
# 327 "lib/parser/parser.ml"
)

and ('s, 'r) _menhir_cell1_MINUS = 
  | MenhirCell1_MINUS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_NOT = 
  | MenhirCell1_NOT of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_PLUS = 
  | MenhirCell1_PLUS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_RETURN = 
  | MenhirCell1_RETURN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_VAR = 
  | MenhirCell1_VAR of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_WHILE = 
  | MenhirCell1_WHILE of 's * ('s, 'r) _menhir_state

and _menhir_box_program = 
  | MenhirBox_program of (Ast.program) [@@unboxed]

let _menhir_action_01 =
  fun _1 _3 stmt_list ->
    (
# 114 "lib/parser/parser.mly"
    ( stmt_list )
# 356 "lib/parser/parser.ml"
     : (Ast.block))

let _menhir_action_02 =
  fun _1 _3 cond ->
    (
# 156 "lib/parser/parser.mly"
    ( cond )
# 364 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_03 =
  fun _1 cond ->
    (
# 158 "lib/parser/parser.mly"
    ( LogicalNot cond )
# 372 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_04 =
  fun _2 c1 c2 ->
    (
# 160 "lib/parser/parser.mly"
    ( LogicOp (c1, And, c2) )
# 380 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_05 =
  fun _2 c1 c2 ->
    (
# 162 "lib/parser/parser.mly"
    ( LogicOp (c1, Or, c2) )
# 388 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_06 =
  fun _2 e1 e2 ->
    (
# 164 "lib/parser/parser.mly"
    ( CompOp (e1, Equal, e2) )
# 396 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_07 =
  fun _2 e1 e2 ->
    (
# 166 "lib/parser/parser.mly"
    ( CompOp (e1, NotEqual, e2) )
# 404 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_08 =
  fun _2 e1 e2 ->
    (
# 168 "lib/parser/parser.mly"
    ( CompOp (e1, Less, e2) )
# 412 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_09 =
  fun _2 e1 e2 ->
    (
# 170 "lib/parser/parser.mly"
    ( CompOp (e1, More, e2) )
# 420 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_10 =
  fun _2 e1 e2 ->
    (
# 172 "lib/parser/parser.mly"
    ( CompOp (e1, LessEqual, e2) )
# 428 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_11 =
  fun _2 e1 e2 ->
    (
# 174 "lib/parser/parser.mly"
    ( CompOp (e1, MoreEqual, e2) )
# 436 "lib/parser/parser.ml"
     : (Ast.cond))

let _menhir_action_12 =
  fun _1 ->
    (
# 52 "lib/parser/parser.mly"
    ( Int )
# 444 "lib/parser/parser.ml"
     : (Ast.data_type))

let _menhir_action_13 =
  fun _1 ->
    (
# 54 "lib/parser/parser.mly"
    ( Char )
# 452 "lib/parser/parser.ml"
     : (Ast.data_type))

let _menhir_action_14 =
  fun lit_int ->
    (
# 130 "lib/parser/parser.mly"
    ( LiteralInt lit_int )
# 460 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_15 =
  fun lit_char ->
    (
# 132 "lib/parser/parser.mly"
    ( LiteralChar lit_char )
# 468 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_16 =
  fun l_value ->
    (
# 134 "lib/parser/parser.mly"
    ( LValue l_value )
# 476 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_17 =
  fun _1 _3 expr ->
    (
# 136 "lib/parser/parser.mly"
    ( expr )
# 484 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_18 =
  fun func_call ->
    (
# 138 "lib/parser/parser.mly"
    ( FuncCall func_call )
# 492 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_19 =
  fun _1 expr ->
    (
# 140 "lib/parser/parser.mly"
    ( Signed (Positive, expr) )
# 500 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_20 =
  fun _1 expr ->
    (
# 142 "lib/parser/parser.mly"
    ( Signed (Negative, expr) )
# 508 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_21 =
  fun _2 e1 e2 ->
    (
# 144 "lib/parser/parser.mly"
    ( AritOp (e1, Add, e2) )
# 516 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_22 =
  fun _2 e1 e2 ->
    (
# 146 "lib/parser/parser.mly"
    ( AritOp (e1, Subtract, e2) )
# 524 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_23 =
  fun _2 e1 e2 ->
    (
# 148 "lib/parser/parser.mly"
    ( AritOp (e1, Multiply, e2) )
# 532 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_24 =
  fun _2 e1 e2 ->
    (
# 150 "lib/parser/parser.mly"
    ( AritOp (e1, Divide, e2) )
# 540 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_25 =
  fun _2 e1 e2 ->
    (
# 152 "lib/parser/parser.mly"
    ( AritOp (e1, Modulo, e2) )
# 548 "lib/parser/parser.ml"
     : (Ast.expr))

let _menhir_action_26 =
  fun _3 fpar_type ids ref ->
    (
# 48 "lib/parser/parser.mly"
    ( { ref = Option.is_some ref ; ids = ids ; fpar_type = fpar_type } )
# 556 "lib/parser/parser.ml"
     : (Ast.fpar_def))

let _menhir_action_27 =
  fun data_type dimensions ->
    (
# 70 "lib/parser/parser.mly"
    (   if List.length dimensions = 0
        then (DataType data_type, false)
        else (Array (data_type, dimensions), false) )
# 566 "lib/parser/parser.ml"
     : (Ast.fpar_type))

let _menhir_action_28 =
  fun _2 _3 data_type dimensions ->
    (
# 75 "lib/parser/parser.mly"
    ( (Array (data_type, dimensions), true) )
# 574 "lib/parser/parser.ml"
     : (Ast.fpar_type))

let _menhir_action_29 =
  fun _2 _4 id xs ->
    let expr_list = 
# 229 "<standard.mly>"
    ( xs )
# 582 "lib/parser/parser.ml"
     in
    (
# 118 "lib/parser/parser.mly"
    ( { name = id ; params = expr_list } )
# 587 "lib/parser/parser.ml"
     : (Ast.func_call))

let _menhir_action_30 =
  fun _2 header ->
    (
# 88 "lib/parser/parser.mly"
    ( header )
# 595 "lib/parser/parser.ml"
     : (Ast.header))

let _menhir_action_31 =
  fun block header local_defs ->
    (
# 40 "lib/parser/parser.mly"
    ( { header = header ; local_defs = local_defs ; block = block } )
# 603 "lib/parser/parser.ml"
     : (Ast.func_def))

let _menhir_action_32 =
  fun _1 _3 _5 _6 id ret_type xs ->
    let fpar_defs = 
# 229 "<standard.mly>"
    ( xs )
# 611 "lib/parser/parser.ml"
     in
    (
# 44 "lib/parser/parser.mly"
    ( { name = id ; fpar_defs = fpar_defs ; ret_type = ret_type } )
# 616 "lib/parser/parser.ml"
     : (Ast.header))

let _menhir_action_33 =
  fun id ->
    (
# 122 "lib/parser/parser.mly"
    ( Identifier id )
# 624 "lib/parser/parser.ml"
     : (Ast.l_value))

let _menhir_action_34 =
  fun lambda_string ->
    (
# 124 "lib/parser/parser.mly"
    ( LambdaString lambda_string )
# 632 "lib/parser/parser.ml"
     : (Ast.l_value))

let _menhir_action_35 =
  fun _2 _4 expr l_value ->
    (
# 126 "lib/parser/parser.mly"
    ( ArrayAccess (l_value, expr) )
# 640 "lib/parser/parser.ml"
     : (Ast.l_value))

let _menhir_action_36 =
  fun () ->
    (
# 208 "<standard.mly>"
    ( [] )
# 648 "lib/parser/parser.ml"
     : (int list))

let _menhir_action_37 =
  fun x xs ->
    let x = 
# 197 "<standard.mly>"
    ( x )
# 656 "lib/parser/parser.ml"
     in
    (
# 210 "<standard.mly>"
    ( x :: xs )
# 661 "lib/parser/parser.ml"
     : (int list))

let _menhir_action_38 =
  fun () ->
    (
# 208 "<standard.mly>"
    ( [] )
# 669 "lib/parser/parser.ml"
     : (Ast.local_def list))

let _menhir_action_39 =
  fun x xs ->
    (
# 210 "<standard.mly>"
    ( x :: xs )
# 677 "lib/parser/parser.ml"
     : (Ast.local_def list))

let _menhir_action_40 =
  fun () ->
    (
# 208 "<standard.mly>"
    ( [] )
# 685 "lib/parser/parser.ml"
     : (Ast.block))

let _menhir_action_41 =
  fun x xs ->
    (
# 210 "<standard.mly>"
    ( x :: xs )
# 693 "lib/parser/parser.ml"
     : (Ast.block))

let _menhir_action_42 =
  fun func_def ->
    (
# 80 "lib/parser/parser.mly"
    ( LocalFuncDef func_def )
# 701 "lib/parser/parser.ml"
     : (Ast.local_def))

let _menhir_action_43 =
  fun func_decl ->
    (
# 82 "lib/parser/parser.mly"
    ( LocalFuncDecl func_decl )
# 709 "lib/parser/parser.ml"
     : (Ast.local_def))

let _menhir_action_44 =
  fun var_def ->
    (
# 84 "lib/parser/parser.mly"
    ( LocalVarDef var_def )
# 717 "lib/parser/parser.ml"
     : (Ast.local_def))

let _menhir_action_45 =
  fun () ->
    (
# 139 "<standard.mly>"
    ( [] )
# 725 "lib/parser/parser.ml"
     : (Ast.expr list))

let _menhir_action_46 =
  fun x ->
    (
# 141 "<standard.mly>"
    ( x )
# 733 "lib/parser/parser.ml"
     : (Ast.expr list))

let _menhir_action_47 =
  fun () ->
    (
# 139 "<standard.mly>"
    ( [] )
# 741 "lib/parser/parser.ml"
     : (Ast.fpar_def list))

let _menhir_action_48 =
  fun x ->
    (
# 141 "<standard.mly>"
    ( x )
# 749 "lib/parser/parser.ml"
     : (Ast.fpar_def list))

let _menhir_action_49 =
  fun () ->
    (
# 111 "<standard.mly>"
    ( None )
# 757 "lib/parser/parser.ml"
     : (unit option))

let _menhir_action_50 =
  fun x ->
    (
# 113 "<standard.mly>"
    ( Some x )
# 765 "lib/parser/parser.ml"
     : (unit option))

let _menhir_action_51 =
  fun () ->
    (
# 111 "<standard.mly>"
    ( None )
# 773 "lib/parser/parser.ml"
     : (Ast.expr option))

let _menhir_action_52 =
  fun x ->
    (
# 113 "<standard.mly>"
    ( Some x )
# 781 "lib/parser/parser.ml"
     : (Ast.expr option))

let _menhir_action_53 =
  fun _2 func_def ->
    (
# 36 "lib/parser/parser.mly"
    ( MainFunction func_def )
# 789 "lib/parser/parser.ml"
     : (Ast.program))

let _menhir_action_54 =
  fun _1 ->
    (
# 64 "lib/parser/parser.mly"
    ( Nothing )
# 797 "lib/parser/parser.ml"
     : (Ast.ret_type))

let _menhir_action_55 =
  fun data_type ->
    (
# 66 "lib/parser/parser.mly"
    ( RetType data_type )
# 805 "lib/parser/parser.ml"
     : (Ast.ret_type))

let _menhir_action_56 =
  fun x ->
    (
# 238 "<standard.mly>"
    ( [ x ] )
# 813 "lib/parser/parser.ml"
     : (string list))

let _menhir_action_57 =
  fun x xs ->
    (
# 240 "<standard.mly>"
    ( x :: xs )
# 821 "lib/parser/parser.ml"
     : (string list))

let _menhir_action_58 =
  fun x ->
    (
# 238 "<standard.mly>"
    ( [ x ] )
# 829 "lib/parser/parser.ml"
     : (Ast.expr list))

let _menhir_action_59 =
  fun x xs ->
    (
# 240 "<standard.mly>"
    ( x :: xs )
# 837 "lib/parser/parser.ml"
     : (Ast.expr list))

let _menhir_action_60 =
  fun x ->
    (
# 238 "<standard.mly>"
    ( [ x ] )
# 845 "lib/parser/parser.ml"
     : (Ast.fpar_def list))

let _menhir_action_61 =
  fun x xs ->
    (
# 240 "<standard.mly>"
    ( x :: xs )
# 853 "lib/parser/parser.ml"
     : (Ast.fpar_def list))

let _menhir_action_62 =
  fun _1 ->
    (
# 96 "lib/parser/parser.mly"
    ( EmptyStatement )
# 861 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_63 =
  fun _2 _4 expr l_value ->
    (
# 98 "lib/parser/parser.mly"
    ( Assign (l_value, expr) )
# 869 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_64 =
  fun block ->
    (
# 100 "lib/parser/parser.mly"
    ( Block block )
# 877 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_65 =
  fun _2 func_call ->
    (
# 102 "lib/parser/parser.mly"
    ( FuncCall func_call )
# 885 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_66 =
  fun _1 _3 cond stmt ->
    (
# 104 "lib/parser/parser.mly"
    ( IfThenElse (cond, stmt, None) )
# 893 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_67 =
  fun _1 _3 _5 cond stmt1 stmt2 ->
    (
# 106 "lib/parser/parser.mly"
    ( IfThenElse (cond, stmt1, Some stmt2) )
# 901 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_68 =
  fun _1 _3 cond stmt ->
    (
# 108 "lib/parser/parser.mly"
    ( WhileLoop (cond, stmt) )
# 909 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_69 =
  fun _1 _3 expr_o ->
    (
# 110 "lib/parser/parser.mly"
    ( ReturnStmt expr_o )
# 917 "lib/parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_70 =
  fun _1 _3 _5 ids var_type ->
    (
# 92 "lib/parser/parser.mly"
    ( { ids = ids ; var_type = var_type } )
# 925 "lib/parser/parser.ml"
     : (Ast.var_def))

let _menhir_action_71 =
  fun data_type dimensions ->
    (
# 58 "lib/parser/parser.mly"
    (   if List.length dimensions = 0
        then DataType data_type
        else Array (data_type, dimensions) )
# 935 "lib/parser/parser.ml"
     : (Ast.var_type))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | Tokens_lib.Tokens.AND ->
        "AND"
    | Tokens_lib.Tokens.ASSIGN ->
        "ASSIGN"
    | Tokens_lib.Tokens.CHAR ->
        "CHAR"
    | Tokens_lib.Tokens.COLON ->
        "COLON"
    | Tokens_lib.Tokens.COMMA ->
        "COMMA"
    | Tokens_lib.Tokens.DIV ->
        "DIV"
    | Tokens_lib.Tokens.DO ->
        "DO"
    | Tokens_lib.Tokens.ELSE ->
        "ELSE"
    | Tokens_lib.Tokens.EOF ->
        "EOF"
    | Tokens_lib.Tokens.EQ ->
        "EQ"
    | Tokens_lib.Tokens.FUN ->
        "FUN"
    | Tokens_lib.Tokens.ID _ ->
        "ID"
    | Tokens_lib.Tokens.IF ->
        "IF"
    | Tokens_lib.Tokens.INT ->
        "INT"
    | Tokens_lib.Tokens.LEFT_BRACKET ->
        "LEFT_BRACKET"
    | Tokens_lib.Tokens.LEFT_CURL ->
        "LEFT_CURL"
    | Tokens_lib.Tokens.LEFT_PAR ->
        "LEFT_PAR"
    | Tokens_lib.Tokens.LESS ->
        "LESS"
    | Tokens_lib.Tokens.LESS_EQ ->
        "LESS_EQ"
    | Tokens_lib.Tokens.LIT_CHAR _ ->
        "LIT_CHAR"
    | Tokens_lib.Tokens.LIT_INT _ ->
        "LIT_INT"
    | Tokens_lib.Tokens.LIT_STR _ ->
        "LIT_STR"
    | Tokens_lib.Tokens.MINUS ->
        "MINUS"
    | Tokens_lib.Tokens.MOD ->
        "MOD"
    | Tokens_lib.Tokens.MORE ->
        "MORE"
    | Tokens_lib.Tokens.MORE_EQ ->
        "MORE_EQ"
    | Tokens_lib.Tokens.MULT ->
        "MULT"
    | Tokens_lib.Tokens.NOT ->
        "NOT"
    | Tokens_lib.Tokens.NOTHING ->
        "NOTHING"
    | Tokens_lib.Tokens.NOT_EQ ->
        "NOT_EQ"
    | Tokens_lib.Tokens.OR ->
        "OR"
    | Tokens_lib.Tokens.PLUS ->
        "PLUS"
    | Tokens_lib.Tokens.REF ->
        "REF"
    | Tokens_lib.Tokens.RETURN ->
        "RETURN"
    | Tokens_lib.Tokens.RIGHT_BRACKET ->
        "RIGHT_BRACKET"
    | Tokens_lib.Tokens.RIGHT_CURL ->
        "RIGHT_CURL"
    | Tokens_lib.Tokens.RIGHT_PAR ->
        "RIGHT_PAR"
    | Tokens_lib.Tokens.SEMICOLON ->
        "SEMICOLON"
    | Tokens_lib.Tokens.THEN ->
        "THEN"
    | Tokens_lib.Tokens.VAR ->
        "VAR"
    | Tokens_lib.Tokens.WHILE ->
        "WHILE"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_134 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _v _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.EOF ->
          let (_2, func_def) = ((), _v) in
          let _v = _menhir_action_53 _2 func_def in
          MenhirBox_program _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_001 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_FUN (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.ID _v ->
          let _menhir_stack = MenhirCell0_ID (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.LEFT_PAR ->
              let _menhir_s = MenhirState003 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | Tokens_lib.Tokens.REF ->
                  _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | Tokens_lib.Tokens.RIGHT_PAR ->
                  let _v = _menhir_action_47 () in
                  _menhir_goto_loption_separated_nonempty_list_SEMICOLON_fpar_def__ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | Tokens_lib.Tokens.ID _ ->
                  _menhir_reduce_49 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_004 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let x = () in
      let _v = _menhir_action_50 x in
      _menhir_goto_option_REF_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_option_REF_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_option_REF_ (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.ID _v_0 ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState006
      | _ ->
          _eRR ()
  
  and _menhir_run_007 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.COMMA ->
          let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState008 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.ID _v ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.COLON ->
          let x = _v in
          let _v = _menhir_action_56 x in
          _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_ID_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState035 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState006 ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState008 ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_036 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_VAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_separated_nonempty_list_COMMA_ID_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState037 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.INT ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.CHAR ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_012 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = () in
      let _v = _menhir_action_12 _1 in
      _menhir_goto_data_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_data_type : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState037 ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState026 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState011 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_040 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_VAR, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_data_type (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.LEFT_BRACKET ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState040
      | Tokens_lib.Tokens.SEMICOLON ->
          let _v_0 = _menhir_action_36 () in
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_018 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LEFT_BRACKET (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_019 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LEFT_BRACKET -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _menhir_stack = MenhirCell0_LIT_INT (_menhir_stack, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.RIGHT_BRACKET ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.LEFT_BRACKET ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState020
          | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.SEMICOLON ->
              let _v_0 = _menhir_action_36 () in
              _menhir_run_021 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_021 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LEFT_BRACKET _menhir_cell0_LIT_INT -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell0_LIT_INT (_menhir_stack, x) = _menhir_stack in
      let MenhirCell1_LEFT_BRACKET (_menhir_stack, _menhir_s) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_37 x xs in
      _menhir_goto_list_delimited_LEFT_BRACKET_LIT_INT_RIGHT_BRACKET__ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_list_delimited_LEFT_BRACKET_LIT_INT_RIGHT_BRACKET__ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState040 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState015 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState017 ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState020 ->
          _menhir_run_021 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_041 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_VAR, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_cell1_data_type -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_data_type (_menhir_stack, _, data_type) = _menhir_stack in
      let dimensions = _v in
      let _v = _menhir_action_71 data_type dimensions in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.SEMICOLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_separated_nonempty_list_COMMA_ID_ (_menhir_stack, _, ids) = _menhir_stack in
          let MenhirCell1_VAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let (_1, _5, _3, var_type) = ((), (), (), _v) in
          let _v = _menhir_action_70 _1 _3 _5 ids var_type in
          let var_def = _v in
          let _v = _menhir_action_44 var_def in
          _menhir_goto_local_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_local_def : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_local_def (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.VAR ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState043
      | Tokens_lib.Tokens.FUN ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState043
      | Tokens_lib.Tokens.LEFT_CURL ->
          let _v_0 = _menhir_action_38 () in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_035 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_VAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState035 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_044 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_local_def -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_local_def (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_39 x xs in
      _menhir_goto_list_local_def_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_list_local_def_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState034 ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState045 ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState043 ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_047 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_header as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_list_local_def_ (_menhir_stack, _menhir_s, _v) in
      _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState047
  
  and _menhir_run_048 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LEFT_CURL (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.WHILE ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | Tokens_lib.Tokens.SEMICOLON ->
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | Tokens_lib.Tokens.RETURN ->
          _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState048
      | Tokens_lib.Tokens.LEFT_CURL ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | Tokens_lib.Tokens.IF ->
          _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState048
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState048
      | Tokens_lib.Tokens.RIGHT_CURL ->
          let _v = _menhir_action_40 () in
          _menhir_run_129 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_049 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_WHILE (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState049 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.NOT ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_050 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_PLUS (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState050 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_051 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_MINUS (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState051 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_052 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let lambda_string = _v in
      let _v = _menhir_action_34 lambda_string in
      _menhir_goto_l_value _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_l_value : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState048 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState127 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState107 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState115 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState117 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState113 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState109 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState049 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState103 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState100 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState094 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState090 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState086 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState050 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState051 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState070 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState068 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState066 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_119 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_l_value (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.LEFT_BRACKET ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.ASSIGN ->
          let _menhir_s = MenhirState120 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.PLUS ->
              _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.MINUS ->
              _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.LIT_STR _v ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LIT_INT _v ->
              _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LIT_CHAR _v ->
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LEFT_PAR ->
              _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.ID _v ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_062 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_l_value -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState062 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_053 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let lit_int = _v in
      let _v = _menhir_action_14 lit_int in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState120 ->
          _menhir_run_121 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState109 ->
          _menhir_run_112 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState113 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState049 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState103 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState100 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState094 ->
          _menhir_run_095 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState090 ->
          _menhir_run_091 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState086 ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState050 ->
          _menhir_run_082 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState051 ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState055 ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState070 ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState068 ->
          _menhir_run_069 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState066 ->
          _menhir_run_067 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_121 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_l_value as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.SEMICOLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_l_value (_menhir_stack, _menhir_s, l_value) = _menhir_stack in
          let (_2, expr, _4) = ((), _v, ()) in
          let _v = _menhir_action_63 _2 _4 expr l_value in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_goto_stmt : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState127 ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState048 ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState107 ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState117 ->
          _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState115 ->
          _menhir_run_116 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_127 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_stmt (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.WHILE ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState127
      | Tokens_lib.Tokens.SEMICOLON ->
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState127
      | Tokens_lib.Tokens.RETURN ->
          _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState127
      | Tokens_lib.Tokens.LIT_STR _v_0 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState127
      | Tokens_lib.Tokens.LEFT_CURL ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState127
      | Tokens_lib.Tokens.IF ->
          _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState127
      | Tokens_lib.Tokens.ID _v_1 ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState127
      | Tokens_lib.Tokens.RIGHT_CURL ->
          let _v_2 = _menhir_action_40 () in
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2
      | _ ->
          _eRR ()
  
  and _menhir_run_108 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = () in
      let _v = _menhir_action_62 _1 in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_109 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_RETURN (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState109 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.SEMICOLON ->
          let _v = _menhir_action_51 () in
          _menhir_goto_option_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_054 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let lit_char = _v in
      let _v = _menhir_action_15 lit_char in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_055 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LEFT_PAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState055 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_056 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.LEFT_PAR ->
          let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState057 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.PLUS ->
              _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.MINUS ->
              _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.LIT_STR _v ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LIT_INT _v ->
              _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LIT_CHAR _v ->
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LEFT_PAR ->
              _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.ID _v ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.RIGHT_PAR ->
              let _v = _menhir_action_45 () in
              _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.ASSIGN | Tokens_lib.Tokens.COMMA | Tokens_lib.Tokens.DIV | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.EQ | Tokens_lib.Tokens.LEFT_BRACKET | Tokens_lib.Tokens.LESS | Tokens_lib.Tokens.LESS_EQ | Tokens_lib.Tokens.MINUS | Tokens_lib.Tokens.MOD | Tokens_lib.Tokens.MORE | Tokens_lib.Tokens.MORE_EQ | Tokens_lib.Tokens.MULT | Tokens_lib.Tokens.NOT_EQ | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.PLUS | Tokens_lib.Tokens.RIGHT_BRACKET | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.SEMICOLON | Tokens_lib.Tokens.THEN ->
          let id = _v in
          let _v = _menhir_action_33 id in
          _menhir_goto_l_value _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_ID -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_ID (_menhir_stack, _menhir_s, id) = _menhir_stack in
      let (xs, _2, _4) = (_v, (), ()) in
      let _v = _menhir_action_29 _2 _4 id xs in
      _menhir_goto_func_call _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_func_call : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState048 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState127 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState107 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState115 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState117 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState113 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState109 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState049 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState103 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState100 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState094 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState090 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState086 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState050 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState051 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState072 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState070 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState068 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState066 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_123 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.SEMICOLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let (_2, func_call) = ((), _v) in
          let _v = _menhir_action_65 _2 func_call in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_063 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let func_call = _v in
      let _v = _menhir_action_18 func_call in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_option_expr_ : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_RETURN -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_RETURN (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, _3, expr_o) = ((), (), _v) in
      let _v = _menhir_action_69 _1 _3 expr_o in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_113 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_IF (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState113 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.NOT ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_083 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_NOT (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState083 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.NOT ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_084 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LEFT_PAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState084 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.NOT ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_128 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_stmt -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_stmt (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_41 x xs in
      _menhir_goto_list_stmt_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_list_stmt_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState048 ->
          _menhir_run_129 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState127 ->
          _menhir_run_128 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_129 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LEFT_CURL -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_LEFT_CURL (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, _3, stmt_list) = ((), (), _v) in
      let _v = _menhir_action_01 _1 _3 stmt_list in
      _menhir_goto_block _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_block : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState047 ->
          _menhir_run_131 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState048 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState127 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState107 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState115 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState117 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_131 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_header, _menhir_box_program) _menhir_cell1_list_local_def_ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_list_local_def_ (_menhir_stack, _, local_defs) = _menhir_stack in
      let MenhirCell1_header (_menhir_stack, _menhir_s, header) = _menhir_stack in
      let block = _v in
      let _v = _menhir_action_31 block header local_defs in
      _menhir_goto_func_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_func_def : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_134 _menhir_stack _v _tok
      | MenhirState034 ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState043 ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState045 ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_132 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let func_def = _v in
      let _v = _menhir_action_42 func_def in
      _menhir_goto_local_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_125 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let block = _v in
      let _v = _menhir_action_64 block in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_126 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_WHILE, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_cond (_menhir_stack, _, cond) = _menhir_stack in
      let MenhirCell1_WHILE (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, _3, stmt) = ((), (), _v) in
      let _v = _menhir_action_68 _1 _3 cond stmt in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_118 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_IF, _menhir_box_program) _menhir_cell1_cond, _menhir_box_program) _menhir_cell1_stmt -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_stmt (_menhir_stack, _, stmt1) = _menhir_stack in
      let MenhirCell1_cond (_menhir_stack, _, cond) = _menhir_stack in
      let MenhirCell1_IF (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, _5, _3, stmt2) = ((), (), (), _v) in
      let _v = _menhir_action_67 _1 _3 _5 cond stmt1 stmt2 in
      _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_116 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_IF, _menhir_box_program) _menhir_cell1_cond as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.ELSE ->
          let _menhir_stack = MenhirCell1_stmt (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState117 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.WHILE ->
              _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.SEMICOLON ->
              _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.RETURN ->
              _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.LIT_STR _v ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LEFT_CURL ->
              _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.IF ->
              _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.ID _v ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.ID _ | Tokens_lib.Tokens.IF | Tokens_lib.Tokens.LEFT_CURL | Tokens_lib.Tokens.LIT_STR _ | Tokens_lib.Tokens.RETURN | Tokens_lib.Tokens.RIGHT_CURL | Tokens_lib.Tokens.SEMICOLON | Tokens_lib.Tokens.WHILE ->
          let MenhirCell1_cond (_menhir_stack, _, cond) = _menhir_stack in
          let MenhirCell1_IF (_menhir_stack, _menhir_s) = _menhir_stack in
          let (_1, _3, stmt) = ((), (), _v) in
          let _v = _menhir_action_66 _1 _3 cond stmt in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_066 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState066 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_068 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState068 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_070 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState070 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_074 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState074 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_072 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState072 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_112 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_RETURN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.SEMICOLON ->
          let x = _v in
          let _v = _menhir_action_52 x in
          _menhir_goto_option_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_101 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.NOT_EQ ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MORE_EQ ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MORE ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.LESS_EQ ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.LESS ->
          _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.EQ ->
          _menhir_run_096 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_086 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState086 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_088 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState088 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_090 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState090 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_092 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState092 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_094 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState094 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_096 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState096 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_097 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_06 _2 e1 e2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_cond : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState113 ->
          _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState049 ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState083 ->
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState103 ->
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState100 ->
          _menhir_run_102 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_098 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_114 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_IF as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.THEN ->
          let _menhir_s = MenhirState115 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.WHILE ->
              _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.SEMICOLON ->
              _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.RETURN ->
              _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.LIT_STR _v ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LEFT_CURL ->
              _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.IF ->
              _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.ID _v ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.OR ->
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND ->
          _menhir_run_103 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_100 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState100 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.NOT ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_103 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState103 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.NOT ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.LIT_STR _v ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_INT _v ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LIT_CHAR _v ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | Tokens_lib.Tokens.LEFT_PAR ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.ID _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_106 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_WHILE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.OR ->
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DO ->
          let _menhir_s = MenhirState107 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.WHILE ->
              _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.SEMICOLON ->
              _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.RETURN ->
              _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.LIT_STR _v ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LEFT_CURL ->
              _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.IF ->
              _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.ID _v ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.AND ->
          _menhir_run_103 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_105 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_NOT -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_NOT (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, cond) = ((), _v) in
      let _v = _menhir_action_03 _1 cond in
      _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_104 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_cond -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_cond (_menhir_stack, _menhir_s, c1) = _menhir_stack in
      let (_2, c2) = ((), _v) in
      let _v = _menhir_action_04 _2 c1 c2 in
      _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_102 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_cond as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.AND ->
          let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
          _menhir_run_103 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_cond (_menhir_stack, _menhir_s, c1) = _menhir_stack in
          let (_2, c2) = ((), _v) in
          let _v = _menhir_action_05 _2 c1 c2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_098 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_LEFT_PAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.RIGHT_PAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LEFT_PAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let (_1, _3, cond) = ((), (), _v) in
          let _v = _menhir_action_02 _1 _3 cond in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | Tokens_lib.Tokens.OR ->
          let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND ->
          let _menhir_stack = MenhirCell1_cond (_menhir_stack, _menhir_s, _v) in
          _menhir_run_103 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_095 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_08 _2 e1 e2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_093 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_10 _2 e1 e2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_091 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_09 _2 e1 e2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_089 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_11 _2 e1 e2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_087 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_07 _2 e1 e2 in
          _menhir_goto_cond _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_085 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_LEFT_PAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.RIGHT_PAR ->
          _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.NOT_EQ ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MORE_EQ ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MORE ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.LESS_EQ ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.LESS ->
          _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.EQ ->
          _menhir_run_096 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_080 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_LEFT_PAR, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_expr (_menhir_stack, _, expr) = _menhir_stack in
      let MenhirCell1_LEFT_PAR (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, _3) = ((), ()) in
      let _v = _menhir_action_17 _1 _3 expr in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_082 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_PLUS -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_PLUS (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, expr) = ((), _v) in
      let _v = _menhir_action_19 _1 expr in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_081 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_MINUS -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_MINUS (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, expr) = ((), _v) in
      let _v = _menhir_action_20 _1 expr in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_079 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_LEFT_PAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.RIGHT_PAR ->
          _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.PLUS ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_076 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.COMMA ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState077 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.PLUS ->
              _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.MINUS ->
              _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.LIT_STR _v ->
              _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LIT_INT _v ->
              _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LIT_CHAR _v ->
              _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | Tokens_lib.Tokens.LEFT_PAR ->
              _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.ID _v ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.RIGHT_PAR ->
          let x = _v in
          let _v = _menhir_action_58 x in
          _menhir_goto_separated_nonempty_list_COMMA_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_expr_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState077 ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState057 ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_078 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_59 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_expr_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_058 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_ID -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let x = _v in
      let _v = _menhir_action_46 x in
      _menhir_goto_loption_separated_nonempty_list_COMMA_expr__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_run_075 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.COMMA | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.EQ | Tokens_lib.Tokens.LESS | Tokens_lib.Tokens.LESS_EQ | Tokens_lib.Tokens.MINUS | Tokens_lib.Tokens.MORE | Tokens_lib.Tokens.MORE_EQ | Tokens_lib.Tokens.NOT_EQ | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.PLUS | Tokens_lib.Tokens.RIGHT_BRACKET | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.SEMICOLON | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_22 _2 e1 e2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_073 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let (_2, e2) = ((), _v) in
      let _v = _menhir_action_24 _2 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_071 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let (_2, e2) = ((), _v) in
      let _v = _menhir_action_25 _2 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_069 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let (_2, e2) = ((), _v) in
      let _v = _menhir_action_23 _2 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_067 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.COMMA | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.EQ | Tokens_lib.Tokens.LESS | Tokens_lib.Tokens.LESS_EQ | Tokens_lib.Tokens.MINUS | Tokens_lib.Tokens.MORE | Tokens_lib.Tokens.MORE_EQ | Tokens_lib.Tokens.NOT_EQ | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.PLUS | Tokens_lib.Tokens.RIGHT_BRACKET | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.SEMICOLON | Tokens_lib.Tokens.THEN ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let (_2, e2) = ((), _v) in
          let _v = _menhir_action_21 _2 e1 e2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_064 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_l_value as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.RIGHT_BRACKET ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_l_value (_menhir_stack, _menhir_s, l_value) = _menhir_stack in
          let (_2, expr, _4) = ((), _v, ()) in
          let _v = _menhir_action_35 _2 _4 expr l_value in
          _menhir_goto_l_value _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | Tokens_lib.Tokens.PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MULT ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MOD ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.DIV ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_061 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.LEFT_BRACKET ->
          let _menhir_stack = MenhirCell1_l_value (_menhir_stack, _menhir_s, _v) in
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer
      | Tokens_lib.Tokens.AND | Tokens_lib.Tokens.COMMA | Tokens_lib.Tokens.DIV | Tokens_lib.Tokens.DO | Tokens_lib.Tokens.EQ | Tokens_lib.Tokens.LESS | Tokens_lib.Tokens.LESS_EQ | Tokens_lib.Tokens.MINUS | Tokens_lib.Tokens.MOD | Tokens_lib.Tokens.MORE | Tokens_lib.Tokens.MORE_EQ | Tokens_lib.Tokens.MULT | Tokens_lib.Tokens.NOT_EQ | Tokens_lib.Tokens.OR | Tokens_lib.Tokens.PLUS | Tokens_lib.Tokens.RIGHT_BRACKET | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.SEMICOLON | Tokens_lib.Tokens.THEN ->
          let l_value = _v in
          let _v = _menhir_action_16 l_value in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_023 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_cell1_data_type -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_data_type (_menhir_stack, _, data_type) = _menhir_stack in
      let dimensions = _v in
      let _v = _menhir_action_27 data_type dimensions in
      _menhir_goto_fpar_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_goto_fpar_type : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_separated_nonempty_list_COMMA_ID_ (_menhir_stack, _, ids) = _menhir_stack in
      let MenhirCell1_option_REF_ (_menhir_stack, _menhir_s, ref) = _menhir_stack in
      let (_3, fpar_type) = ((), _v) in
      let _v = _menhir_action_26 _3 fpar_type ids ref in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.SEMICOLON ->
          let _menhir_stack = MenhirCell1_fpar_def (_menhir_stack, _menhir_s, _v) in
          let _menhir_s = MenhirState031 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.REF ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | Tokens_lib.Tokens.ID _ ->
              _menhir_reduce_49 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.RIGHT_PAR ->
          let x = _v in
          let _v = _menhir_action_60 x in
          _menhir_goto_separated_nonempty_list_SEMICOLON_fpar_def_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_reduce_49 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s _tok ->
      let _v = _menhir_action_49 () in
      _menhir_goto_option_REF_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_separated_nonempty_list_SEMICOLON_fpar_def_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState031 ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState003 ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_032 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_fpar_def -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_fpar_def (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_61 x xs in
      _menhir_goto_separated_nonempty_list_SEMICOLON_fpar_def_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_005 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_ID as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let x = _v in
      let _v = _menhir_action_48 x in
      _menhir_goto_loption_separated_nonempty_list_SEMICOLON_fpar_def__ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_loption_separated_nonempty_list_SEMICOLON_fpar_def__ : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_ID as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_loption_separated_nonempty_list_SEMICOLON_fpar_def__ (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.COLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.NOTHING ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _1 = () in
              let _v = _menhir_action_54 _1 in
              _menhir_goto_ret_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | Tokens_lib.Tokens.INT ->
              _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState026
          | Tokens_lib.Tokens.CHAR ->
              _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState026
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_ret_type : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_ID, _menhir_box_program) _menhir_cell1_loption_separated_nonempty_list_SEMICOLON_fpar_def__ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_loption_separated_nonempty_list_SEMICOLON_fpar_def__ (_menhir_stack, _, xs) = _menhir_stack in
      let MenhirCell0_ID (_menhir_stack, id) = _menhir_stack in
      let MenhirCell1_FUN (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_1, ret_type, _6, _5, _3) = ((), _v, (), (), ()) in
      let _v = _menhir_action_32 _1 _3 _5 _6 id ret_type xs in
      _menhir_goto_header _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_header : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState034 ->
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState045 ->
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState043 ->
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState000 ->
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_045 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.VAR ->
          let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | Tokens_lib.Tokens.SEMICOLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let (_2, header) = ((), _v) in
          let _v = _menhir_action_30 _2 header in
          let func_decl = _v in
          let _v = _menhir_action_43 func_decl in
          _menhir_goto_local_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | Tokens_lib.Tokens.FUN ->
          let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | Tokens_lib.Tokens.LEFT_CURL ->
          let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
          let _v_0 = _menhir_action_38 () in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState045
      | _ ->
          _eRR ()
  
  and _menhir_run_034 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_header (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.VAR ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | Tokens_lib.Tokens.FUN ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
      | Tokens_lib.Tokens.LEFT_CURL ->
          let _v_0 = _menhir_action_38 () in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState034
      | _ ->
          _eRR ()
  
  and _menhir_run_013 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = () in
      let _v = _menhir_action_13 _1 in
      _menhir_goto_data_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_022 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_, _menhir_box_program) _menhir_cell1_data_type, _menhir_box_program) _menhir_cell1_LEFT_BRACKET -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_LEFT_BRACKET (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_data_type (_menhir_stack, _, data_type) = _menhir_stack in
      let (_2, _3, dimensions) = ((), (), _v) in
      let _v = _menhir_action_28 _2 _3 data_type dimensions in
      _menhir_goto_fpar_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_029 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_FUN _menhir_cell0_ID, _menhir_box_program) _menhir_cell1_loption_separated_nonempty_list_SEMICOLON_fpar_def__ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let data_type = _v in
      let _v = _menhir_action_55 data_type in
      _menhir_goto_ret_type _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_015 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_option_REF_, _menhir_box_program) _menhir_cell1_separated_nonempty_list_COMMA_ID_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_data_type (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.LEFT_BRACKET ->
          let _menhir_stack = MenhirCell1_LEFT_BRACKET (_menhir_stack, MenhirState015) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | Tokens_lib.Tokens.RIGHT_BRACKET ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | Tokens_lib.Tokens.LEFT_BRACKET ->
                  _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState017
              | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.SEMICOLON ->
                  let _v_0 = _menhir_action_36 () in
                  _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 _tok
              | _ ->
                  _eRR ())
          | Tokens_lib.Tokens.LIT_INT _v_1 ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1
          | _ ->
              _eRR ())
      | Tokens_lib.Tokens.RIGHT_PAR | Tokens_lib.Tokens.SEMICOLON ->
          let _v_2 = _menhir_action_36 () in
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_010 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_option_REF_ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_separated_nonempty_list_COMMA_ID_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState011 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.INT ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | Tokens_lib.Tokens.CHAR ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_009 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_ID -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_ID (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_57 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState000 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | Tokens_lib.Tokens.FUN ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let program =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_program v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
