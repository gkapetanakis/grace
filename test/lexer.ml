open Lex_lib.Lexer
open Lex_lib.Utils
open Tokens_lib.Tokens

let to_string = function
  | WHILE           -> "WHILE"
  | VAR             -> "VAR"
  | THEN            -> "THEN"
  | SEMICOLON       -> "SEMICOLON"
  | RIGHT_PAR       -> "RIGHT_PAR"
  | RIGHT_CURL      -> "RIGHT_CURL"
  | RIGHT_BRACKET   -> "RIGHT_BRACKET"
  | RETURN          -> "RETURN"
  | REF             -> "REF"
  | PLUS            -> "PLUS"
  | OR              -> "OR"
  | NOT_EQ          -> "NOT_EQ"
  | NOTHING         -> "NOTHING"
  | NOT             -> "NOT"
  | MULT            -> "MULT"
  | MORE_EQ         -> "MORE_EQ"
  | MORE            -> "MORE"
  | MOD             -> "MOD"
  | MINUS           -> "MINUS"
  | LIT_STR(s)      -> "LIT_STR(\"" ^ s ^ "\")"
  | LIT_INT(i)      -> "LIT_INT(" ^ string_of_int i ^ ")"
  | LIT_CHAR(c)     -> "LIT_CHAR('" ^ String.make 1 c ^ "')"
  | LESS_EQ         -> "LESS_EQ"
  | LESS            -> "LESS"
  | LEFT_PAR        -> "LEFT_PAR"
  | LEFT_CURL       -> "LEFT_CURL"
  | LEFT_BRACKET    -> "LEFT_BRACKET"
  | INT             -> "INT"
  | IF              -> "IF"
  | ID(s)           -> "ID(" ^ s ^ ")"
  | FUN             -> "FUN"
  | EQ              -> "EQ"
  | EOF             -> "EOF"
  | ELSE            -> "ELSE"
  | DO              -> "DO"
  | DIV             -> "DIV"
  | COMMA           -> "COMMA"
  | COLON           -> "COLON"
  | CHAR            -> "CHAR"
  | ASSIGN          -> "ASSIGN"
  | AND             -> "AND"

let main () =
  let cin =
    if Array.length Sys.argv > 1
    then open_in Sys.argv.(1)
    else stdin
  in 
  let lexbuf = Lexing.from_channel cin in
  let rec loop acc =  function
      | EOF   ->  to_string EOF :: acc |> List.rev
      | x     ->  loop (to_string x :: acc) (token lexbuf)
  in
      loop [] (token lexbuf) 
      |> String.concat " " 
      |> print_endline

let () =
  try main () with
  Lex_err err -> print_lex_err err