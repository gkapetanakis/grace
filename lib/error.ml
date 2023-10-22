type loc = Lexing.position * Lexing.position

type err_type =
  | Symbol_table_error
  | Semantic_error
  | Lexer_error

exception Grace_error of err_type * (loc * string)

let string_of_loc
    ( {
        Lexing.pos_fname = filename;
        Lexing.pos_lnum = line;
        Lexing.pos_bol;
        Lexing.pos_cnum;
      },
      _ ) =
  let col = pos_cnum - pos_bol + 1 in
  Printf.sprintf "File: %s, line: %d, column: %d" filename line col

let pr_error = function
  | Grace_error (t, (l, s)) -> (
    match t with
    | Symbol_table_error ->
      prerr_string ("Symbol table error at " ^ string_of_loc l ^ ": " ^ s)
    | Semantic_error ->
      prerr_string ("Semantic error at " ^ string_of_loc l ^ ": " ^ s)
    | Lexer_error ->
      prerr_string ("Lexer error at " ^ string_of_loc l ^ ": " ^ s)
  )
  | err -> raise err
