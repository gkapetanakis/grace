let () =
  let dirname = "programs/" in
  let filenames = [ "program1.grc" ] in
  let test filename =
    let chan = open_in (dirname ^ filename) in
    let lexbuf = Lexing.from_channel chan in
    let () = Lexing.set_filename lexbuf filename in
    try
      let ast_node = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
      print_string
        (Grace_lib.Print_ast.pr_func_def "" true (Grace_lib.Ast.get_node ast_node))
    with err -> Grace_lib.Error.pr_error err
  in
    List.iter test filenames
