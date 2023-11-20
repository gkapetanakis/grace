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
    try
      print_endline filename;
      let ast_node = Parser.program Grace_lib.Lexer.token lexbuf in
      ast_node |> Print_ast.pr_program |> print_string;

      print_string "\n====================\n\n"
    with
    | Error.Lexing_error (loc, msg) ->
        Error.pr_lexing_error (loc, msg);
        Print_symbol.pr_symbol_table "" true Wrapper.tbl |> print_endline
    | Error.Semantic_error (loc, msg) ->
        Error.pr_semantic_error (loc, msg);
        Print_symbol.pr_symbol_table "" true Wrapper.tbl |> print_endline
    | Error.Symbol_table_error (loc, msg) ->
        Error.pr_symbol_table_error (loc, msg);
        Print_symbol.pr_symbol_table "" true Wrapper.tbl |> print_endline
  in

  List.iter test !filenames
