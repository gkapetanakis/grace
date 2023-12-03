let compile filename =
  try
    let inchan = open_in filename in
    let lexbuf = Lexing.from_channel inchan in
    Lexing.set_filename lexbuf filename;
    true
  with
  | Not_found -> false

let () =
  let path = "test/semantic/" in
  let compile filename =
    try
      let inchan = open_in filename in
      let lexbuf = Lexing.from_channel inchan in
      Lexing.set_filename lexbuf filename;
      try
        ignore (Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf)
      with
      | Grace_lib.Error.Lexing_error (loc, msg) ->
          Grace_lib.Error.pr_lexing_error (loc, msg);
          Grace_lib.Print_symbol.pr_symbol_table "" true Grace_lib.Wrapper.tbl
          |> print_endline
      | Grace_lib.Parser.Error ->
          (* built-in Menhir error... *)
          Grace_lib.Error.pr_parser_error
            ( (Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf),
              "Syntax error" );
          Grace_lib.Print_symbol.pr_symbol_table "" true Grace_lib.Wrapper.tbl
          |> print_endline
      | Grace_lib.Error.Semantic_error (loc, msg) ->
          Grace_lib.Error.pr_semantic_error (loc, msg);
          Grace_lib.Print_symbol.pr_symbol_table "" true Grace_lib.Wrapper.tbl
          |> print_endline
      | Grace_lib.Error.Symbol_table_error (loc, msg) ->
          Grace_lib.Error.pr_symbol_table_error (loc, msg);
          Grace_lib.Print_symbol.pr_symbol_table "" true Grace_lib.Wrapper.tbl
          |> print_endline
      | Grace_lib.Error.Internal_compiler_error msg ->
          Grace_lib.Error.pr_internal_compiler_error msg;
          Grace_lib.Print_symbol.pr_symbol_table "" true Grace_lib.Wrapper.tbl
          |> print_endline
    with Not_found -> print_endline ("File not found: " ^ filename)
  in
  ()
