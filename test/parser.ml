let () =
  let dirname = "programs/" in
  let filenames = [ "program1.grc" ] in
  let test filename =
    let chan = open_in (dirname ^ filename) in
    let lexbuf = Lexing.from_channel chan in
    try
      let ast_node = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
      print_string
      (Grace_lib.Print_ast.pr_func_def "" true (Grace_lib.Ast.get_node ast_node))
    with
    | Grace_lib.Error.Lexer_error (_, msg) -> prerr_endline msg
    | Grace_lib.Parser.Error ->
        prerr_endline
          (Printf.sprintf "Parse error at line %d:\n" lexbuf.lex_curr_p.pos_lnum)
  in
  List.iter test filenames