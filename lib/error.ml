type loc = Lexing.position * Lexing.position

exception Symbol_table_exception of string
exception Semantic_error of loc * string
exception Lexer_error of loc * string

let string_of_loc
({Lexing.pos_fname = filename;
  Lexing.pos_lnum = line; Lexing.pos_bol = pos_bol;
  Lexing.pos_cnum = pos_cnum}, _) =
  let col = pos_cnum - pos_bol + 1 in
  Printf.sprintf "File: %s, line: %d, column: %d" filename line col

let pr_error = function
| Symbol_table_exception s -> print_string ("Symbol table exception: " ^ s)
| Semantic_error (l, s) -> print_string ("Semantic error at " ^ (string_of_loc l) ^ ": " ^ s)
| Lexer_error (l, s) -> print_string ("Lexer error at " ^ (string_of_loc l) ^ ": " ^ s)
| err -> raise err