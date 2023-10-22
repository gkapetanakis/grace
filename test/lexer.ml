let () =
  let dirname = "programs/" in
  let filenames = [ "program1.grc" ] in
  let test filename =
    let chan = open_in (dirname ^ filename) in
    let lexbuf = Lexing.from_channel chan in
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
      with Grace_lib.Error.Lexer_error (_, msg) -> print_endline msg
    in
    tokenize_and_print ()
  in
  List.iter test filenames

(*
  while true do
    print_endline "Give some input, or use Ctrl+C to quit:";
    let input_string = read_line () in
    let lexbuf = Lexing.from_string input_string in
  done
*)
