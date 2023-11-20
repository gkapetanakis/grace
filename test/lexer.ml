open Grace_lib
open Arg

let filenames = ref []

let usage_msg =
  "Usage: parser --file <filename> --files <filename1> <filename2> ..."

let speclist =
  [
    ( "--file",
      String (fun str -> filenames := str :: !filenames),
      "Input file name" );
    ( "--files",
      Rest (fun str -> filenames := str :: !filenames),
      "Input file names" );
  ]

let () =
  Arg.parse speclist (fun _ -> ()) usage_msg;
  let test filename =
    let chan = open_in filename in
    let lexbuf = Lexing.from_channel chan in
    Lexing.set_filename lexbuf filename;
    let rec tokenize_and_print () =
      try
        (* call the lexer's 'token' rule (tokenize input) *)
        let token = Lexer.token lexbuf in
        (* print found tokens *)
        match token with
        | Tokens.EOF -> ()
        | _ ->
            Lexer_utils.string_of_token token |> print_endline;
            tokenize_and_print ()
      with Error.Lexing_error (loc, msg) -> Error.pr_lexing_error (loc, msg)
    in
    print_endline filename;
    tokenize_and_print ();

    print_string "\n====================\n\n"
  in
  List.iter test !filenames
