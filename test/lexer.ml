let () =
  let dirname = "programs/" in
  let filenames = [ "program1.grc"; "program2.grc" ] in
  let test filename =
    let chan = open_in (dirname ^ filename) in
    let lexbuf = Lexing.from_channel chan in
    let () = Lexing.set_filename lexbuf filename in
    let rec tokenize_and_print () =
      try
        (* call the lexer's 'token' rule (tokenize input) *)
        let token = Grace_lib.Lexer.token lexbuf in
        (* print found tokens *)
        match token with
        | Grace_lib.Tokens.EOF -> ()
        | _ ->
            print_endline (Grace_lib.Lexer_utils.string_of_token token);
            tokenize_and_print ()
      with err -> Grace_lib.Error.pr_error err
    in
      print_endline filename;
      tokenize_and_print ()
  in
    List.iteri (fun i f -> test f; if i < List.length filenames - 1 then print_newline ()) filenames
