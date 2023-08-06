open Printf

let main () =
  let cin =
    if Array.length Sys.argv > 1
    then open_in Sys.argv.(1)
    else stdin
  in
  let lexbuf = Lexing.from_channel cin in
    let res =
      try Parser_lib.Parser.program Lex_lib.Lexer.token lexbuf
      with
      | Lex_lib.Utils.Lex_err err -> Lex_lib.Utils.print_lex_err err;
        exit 1
      | Parser_lib.Parser.Error ->
        fprintf stderr "Parse error at line %d:\n" lexbuf.lex_curr_p.pos_lnum;
        exit 1
    in
      let _ = res in
      Printf.printf "%s\n" (Parser_lib.Ast.pprint_program res)

let () = main ()