# 2 "lib/lexer/lexer.mll"
 
    open Tokens_lib.Tokens
    open Utils

# 7 "lib/lexer/lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\227\255\228\255\229\255\230\255\078\000\088\000\234\255\
    \235\255\236\255\237\255\238\255\239\255\240\255\241\255\242\255\
    \243\255\244\255\002\000\166\000\249\255\250\255\251\255\001\000\
    \254\255\006\000\002\000\253\255\233\255\248\255\247\255\010\000\
    \252\255\253\255\254\255\011\000\255\255\235\000\252\255\253\255\
    \254\255\255\255\107\000\254\255\255\255\076\001\251\255\252\255\
    \253\255\254\255\255\255\169\001\247\255\171\001\249\255\250\255\
    \251\255\252\255\253\255\254\255\255\255\197\001\248\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\255\255\255\255\024\000\023\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\010\000\009\000\255\255\255\255\255\255\003\000\
    \255\255\000\000\003\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\002\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\008\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_default =
   "\001\000\000\000\000\000\000\000\000\000\255\255\255\255\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\255\255\255\255\000\000\000\000\000\000\026\000\
    \000\000\255\255\026\000\000\000\000\000\000\000\000\000\033\000\
    \000\000\000\000\000\000\255\255\000\000\038\000\000\000\000\000\
    \000\000\000\000\043\000\000\000\000\000\046\000\000\000\000\000\
    \000\000\000\000\000\000\052\000\000\000\255\255\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\255\255\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\025\000\024\000\255\255\255\255\025\000\000\000\025\000\
    \000\000\000\000\000\000\025\000\034\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \025\000\000\000\003\000\016\000\023\000\027\000\025\000\004\000\
    \015\000\014\000\020\000\022\000\009\000\021\000\035\000\036\000\
    \005\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
    \005\000\005\000\007\000\008\000\019\000\017\000\018\000\030\000\
    \000\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\013\000\000\000\012\000\000\000\006\000\
    \000\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\011\000\000\000\010\000\005\000\005\000\
    \005\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\044\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\000\000\000\000\000\000\000\000\006\000\
    \000\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\028\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\029\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \002\000\255\255\255\255\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\032\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\041\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\000\000\255\255\048\000\048\000\050\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \049\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\054\000\000\000\000\000\000\000\000\000\
    \055\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\057\000\000\000\061\000\061\000\061\000\061\000\061\000\
    \061\000\061\000\061\000\061\000\061\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\039\000\061\000\061\000\061\000\061\000\
    \061\000\061\000\000\000\000\000\000\000\062\000\062\000\062\000\
    \062\000\062\000\062\000\062\000\062\000\062\000\062\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\056\000\062\000\062\000\
    \062\000\062\000\062\000\062\000\061\000\061\000\061\000\061\000\
    \061\000\061\000\000\000\000\000\000\000\000\000\000\000\060\000\
    \000\000\000\000\000\000\058\000\000\000\059\000\000\000\000\000\
    \000\000\053\000\000\000\000\000\000\000\000\000\062\000\062\000\
    \062\000\062\000\062\000\062\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\047\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\255\255\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\023\000\026\000\000\000\255\255\025\000\
    \255\255\255\255\255\255\025\000\031\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\000\000\000\000\000\000\023\000\025\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\031\000\035\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\018\000\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\255\255\000\000\255\255\000\000\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\255\255\000\000\005\000\005\000\
    \005\000\005\000\005\000\005\000\005\000\005\000\005\000\005\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\042\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\255\255\255\255\255\255\255\255\006\000\
    \255\255\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
    \006\000\006\000\006\000\019\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\019\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\023\000\026\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\031\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\037\000\037\000\037\000\037\000\037\000\037\000\
    \037\000\037\000\255\255\042\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\051\000\255\255\255\255\255\255\255\255\
    \051\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\051\000\255\255\053\000\053\000\053\000\053\000\053\000\
    \053\000\053\000\053\000\053\000\053\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\037\000\053\000\053\000\053\000\053\000\
    \053\000\053\000\255\255\255\255\255\255\061\000\061\000\061\000\
    \061\000\061\000\061\000\061\000\061\000\061\000\061\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\051\000\061\000\061\000\
    \061\000\061\000\061\000\061\000\053\000\053\000\053\000\053\000\
    \053\000\053\000\255\255\255\255\255\255\255\255\255\255\051\000\
    \255\255\255\255\255\255\051\000\255\255\051\000\255\255\255\255\
    \255\255\051\000\255\255\255\255\255\255\255\255\061\000\061\000\
    \061\000\061\000\061\000\061\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\045\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\051\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec token lexbuf =
   __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 18 "lib/lexer/lexer.mll"
                                    ( token lexbuf                                          )
# 237 "lib/lexer/lexer.ml"

  | 1 ->
# 19 "lib/lexer/lexer.mll"
                                    ( Lexing.new_line lexbuf; token lexbuf                  )
# 242 "lib/lexer/lexer.ml"

  | 2 ->
# 20 "lib/lexer/lexer.mll"
                                    ( comment lexbuf                                        )
# 247 "lib/lexer/lexer.ml"

  | 3 ->
# 21 "lib/lexer/lexer.mll"
                                    ( token lexbuf                                          )
# 252 "lib/lexer/lexer.ml"

  | 4 ->
# 23 "lib/lexer/lexer.mll"
                                    ( PLUS                                                  )
# 257 "lib/lexer/lexer.ml"

  | 5 ->
# 24 "lib/lexer/lexer.mll"
                                    ( MINUS                                                 )
# 262 "lib/lexer/lexer.ml"

  | 6 ->
# 25 "lib/lexer/lexer.mll"
                                    ( MULT                                                  )
# 267 "lib/lexer/lexer.ml"

  | 7 ->
# 27 "lib/lexer/lexer.mll"
                                    ( LESS_EQ                                               )
# 272 "lib/lexer/lexer.ml"

  | 8 ->
# 28 "lib/lexer/lexer.mll"
                                    ( MORE_EQ                                               )
# 277 "lib/lexer/lexer.ml"

  | 9 ->
# 29 "lib/lexer/lexer.mll"
                                    ( LESS                                                  )
# 282 "lib/lexer/lexer.ml"

  | 10 ->
# 30 "lib/lexer/lexer.mll"
                                    ( MORE                                                  )
# 287 "lib/lexer/lexer.ml"

  | 11 ->
# 31 "lib/lexer/lexer.mll"
                                    ( EQ                                                    )
# 292 "lib/lexer/lexer.ml"

  | 12 ->
# 32 "lib/lexer/lexer.mll"
                                    ( NOT_EQ                                                )
# 297 "lib/lexer/lexer.ml"

  | 13 ->
# 33 "lib/lexer/lexer.mll"
                                    ( LEFT_PAR                                              )
# 302 "lib/lexer/lexer.ml"

  | 14 ->
# 34 "lib/lexer/lexer.mll"
                                    ( RIGHT_PAR                                             )
# 307 "lib/lexer/lexer.ml"

  | 15 ->
# 35 "lib/lexer/lexer.mll"
                                    ( LEFT_BRACKET                                          )
# 312 "lib/lexer/lexer.ml"

  | 16 ->
# 36 "lib/lexer/lexer.mll"
                                    ( RIGHT_BRACKET                                         )
# 317 "lib/lexer/lexer.ml"

  | 17 ->
# 37 "lib/lexer/lexer.mll"
                                    ( LEFT_CURL                                             )
# 322 "lib/lexer/lexer.ml"

  | 18 ->
# 38 "lib/lexer/lexer.mll"
                                    ( RIGHT_CURL                                            )
# 327 "lib/lexer/lexer.ml"

  | 19 ->
# 39 "lib/lexer/lexer.mll"
                                    ( COMMA                                                 )
# 332 "lib/lexer/lexer.ml"

  | 20 ->
# 40 "lib/lexer/lexer.mll"
                                    ( SEMICOLON                                             )
# 337 "lib/lexer/lexer.ml"

  | 21 ->
# 41 "lib/lexer/lexer.mll"
                                    ( COLON                                                 )
# 342 "lib/lexer/lexer.ml"

  | 22 ->
# 42 "lib/lexer/lexer.mll"
                                    ( ASSIGN                                                )
# 347 "lib/lexer/lexer.ml"

  | 23 ->
let
# 44 "lib/lexer/lexer.mll"
              word
# 353 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 44 "lib/lexer/lexer.mll"
                                    (   try (* keyword_table is from Utils module *)
                                            let tok = Hashtbl.find keyword_table word in
                                                tok
                                        with
                                            Not_found -> ID word                            )
# 361 "lib/lexer/lexer.ml"

  | 24 ->
let
# 49 "lib/lexer/lexer.mll"
                  num
# 367 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 49 "lib/lexer/lexer.mll"
                                    ( LIT_INT (int_of_string num)                           )
# 371 "lib/lexer/lexer.ml"

  | 25 ->
# 50 "lib/lexer/lexer.mll"
                                    ( character lexbuf                                      )
# 376 "lib/lexer/lexer.ml"

  | 26 ->
# 51 "lib/lexer/lexer.mll"
                                    (   let buf = Buffer.create 17 in
                                            str buf lexbuf                                  )
# 382 "lib/lexer/lexer.ml"

  | 27 ->
# 53 "lib/lexer/lexer.mll"
                                    ( EOF                                                   )
# 387 "lib/lexer/lexer.ml"

  | 28 ->
let
# 54 "lib/lexer/lexer.mll"
             c
# 393 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 54 "lib/lexer/lexer.mll"
                                    ( fail ("Bad character: '"^(String.make 1 c)^"'") lexbuf)
# 397 "lib/lexer/lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_token_rec lexbuf __ocaml_lex_state

and comment lexbuf =
   __ocaml_lex_comment_rec lexbuf 31
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 56 "lib/lexer/lexer.mll"
                                    ( token lexbuf                                          )
# 409 "lib/lexer/lexer.ml"

  | 1 ->
# 57 "lib/lexer/lexer.mll"
                                    ( Lexing.new_line lexbuf; comment lexbuf                )
# 414 "lib/lexer/lexer.ml"

  | 2 ->
# 58 "lib/lexer/lexer.mll"
                                    ( comment lexbuf                                        )
# 419 "lib/lexer/lexer.ml"

  | 3 ->
# 59 "lib/lexer/lexer.mll"
                                    ( fail "Multiline comment does not terminate" lexbuf    )
# 424 "lib/lexer/lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

and character lexbuf =
   __ocaml_lex_character_rec lexbuf 37
and __ocaml_lex_character_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 62 "lib/lexer/lexer.mll"
                                    ( escape end_character lexbuf                           )
# 436 "lib/lexer/lexer.ml"

  | 1 ->
let
# 63 "lib/lexer/lexer.mll"
               c
# 442 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 63 "lib/lexer/lexer.mll"
                                    ( end_character c lexbuf                                )
# 446 "lib/lexer/lexer.ml"

  | 2 ->
# 64 "lib/lexer/lexer.mll"
                                    ( fail "Improper use of character syntax" lexbuf        )
# 451 "lib/lexer/lexer.ml"

  | 3 ->
let
# 65 "lib/lexer/lexer.mll"
             c
# 457 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 65 "lib/lexer/lexer.mll"
                                    ( fail ("Bad character: '"^(String.make 1 c)^"'") lexbuf)
# 461 "lib/lexer/lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_character_rec lexbuf __ocaml_lex_state

and end_character c lexbuf =
   __ocaml_lex_end_character_rec c lexbuf 42
and __ocaml_lex_end_character_rec c lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 68 "lib/lexer/lexer.mll"
                                    ( LIT_CHAR c                                            )
# 473 "lib/lexer/lexer.ml"

  | 1 ->
# 69 "lib/lexer/lexer.mll"
                                    ( fail "Improper use of character syntax" lexbuf        )
# 478 "lib/lexer/lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_end_character_rec c lexbuf __ocaml_lex_state

and str buf lexbuf =
   __ocaml_lex_str_rec buf lexbuf 45
and __ocaml_lex_str_rec buf lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 72 "lib/lexer/lexer.mll"
                                    ( LIT_STR (Buffer.contents buf)                         )
# 490 "lib/lexer/lexer.ml"

  | 1 ->
# 73 "lib/lexer/lexer.mll"
                                    (   let str_exec_func c lexbuf =
                                            Buffer.add_char buf c;
                                            str buf lexbuf
                                        in
                                        escape str_exec_func lexbuf                         )
# 499 "lib/lexer/lexer.ml"

  | 2 ->
let
# 78 "lib/lexer/lexer.mll"
               c
# 505 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 78 "lib/lexer/lexer.mll"
                                    ( Buffer.add_char buf c; str buf lexbuf                 )
# 509 "lib/lexer/lexer.ml"

  | 3 ->
# 79 "lib/lexer/lexer.mll"
                                    ( fail "String does not terminate" lexbuf               )
# 514 "lib/lexer/lexer.ml"

  | 4 ->
let
# 80 "lib/lexer/lexer.mll"
             c
# 520 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 80 "lib/lexer/lexer.mll"
                                    ( fail ("Bad character: '"^(String.make 1 c)^"'") lexbuf)
# 524 "lib/lexer/lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_str_rec buf lexbuf __ocaml_lex_state

and escape exec_func lexbuf =
   __ocaml_lex_escape_rec exec_func lexbuf 51
and __ocaml_lex_escape_rec exec_func lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 83 "lib/lexer/lexer.mll"
                                    ( exec_func '\n' lexbuf                                 )
# 536 "lib/lexer/lexer.ml"

  | 1 ->
# 84 "lib/lexer/lexer.mll"
                                    ( exec_func '\t' lexbuf                                 )
# 541 "lib/lexer/lexer.ml"

  | 2 ->
# 85 "lib/lexer/lexer.mll"
                                    ( exec_func '\r' lexbuf                                 )
# 546 "lib/lexer/lexer.ml"

  | 3 ->
# 86 "lib/lexer/lexer.mll"
                                    ( exec_func '\x00' lexbuf                               )
# 551 "lib/lexer/lexer.ml"

  | 4 ->
# 87 "lib/lexer/lexer.mll"
                                    ( exec_func '\\' lexbuf                                 )
# 556 "lib/lexer/lexer.ml"

  | 5 ->
# 88 "lib/lexer/lexer.mll"
                                    ( exec_func '\'' lexbuf                                 )
# 561 "lib/lexer/lexer.ml"

  | 6 ->
# 89 "lib/lexer/lexer.mll"
                                    ( exec_func '"' lexbuf                                  )
# 566 "lib/lexer/lexer.ml"

  | 7 ->
let
# 90 "lib/lexer/lexer.mll"
                             code
# 572 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos (lexbuf.Lexing.lex_start_pos + 3) in
# 90 "lib/lexer/lexer.mll"
                                    (
                                        let dec_code = int_of_string ("0"^code) in
                                        let ascii_char = char_of_int dec_code in
                                            exec_func ascii_char lexbuf                     )
# 579 "lib/lexer/lexer.ml"

  | 8 ->
let
# 94 "lib/lexer/lexer.mll"
             c
# 585 "lib/lexer/lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 94 "lib/lexer/lexer.mll"
                                    ( fail ("Bad escape: '\\"^(String.make 1 c)^"'") lexbuf )
# 589 "lib/lexer/lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_escape_rec exec_func lexbuf __ocaml_lex_state

;;

