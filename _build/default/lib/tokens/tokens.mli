
(* The type of tokens. *)

type token = 
  | WHILE
  | VAR
  | THEN
  | SEMICOLON
  | RIGHT_PAR
  | RIGHT_CURL
  | RIGHT_BRACKET
  | RETURN
  | REF
  | PLUS
  | OR
  | NOT_EQ
  | NOTHING
  | NOT
  | MULT
  | MORE_EQ
  | MORE
  | MOD
  | MINUS
  | LIT_STR of (string)
  | LIT_INT of (int)
  | LIT_CHAR of (char)
  | LESS_EQ
  | LESS
  | LEFT_PAR
  | LEFT_CURL
  | LEFT_BRACKET
  | INT
  | IF
  | ID of (string)
  | FUN
  | EQ
  | EOF
  | ELSE
  | DO
  | DIV
  | COMMA
  | COLON
  | CHAR
  | ASSIGN
  | AND
