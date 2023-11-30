let handle_incorrect_call () =
  print_endline "Usage: gracec [Options] file";
  print_endline "For more info, try: gracec --help";
  exit 1
  [@@ocamlformat "disable"]

let print_help_message () =
  print_endline "Usage: gracec [Options] filename";
  print_newline ();
  print_endline "Options:";
  print_endline "  -O  Enable optimizations.";
  print_endline "  -f  Get source code input from stdin and output compiled code to stdout.";
  print_endline "      File argument is not required in this case and will be ignored if provided.";
  print_endline "  -i  Get source code input from stdin and output intermediate code to stdout.";
  print_endline "      File argument is not required in this case and will be ignored if provided.";
  [@@ocamlformat "disable"]

(* input flags and filename *)
let optimizations = ref false
let compiled_stdin_stdout = ref false
let intermediate_stdin_stdout = ref false
let filename = ref ""
let debug = true

let () =
  if Array.length Sys.argv < 2 then handle_incorrect_call ();
  let argv = Sys.argv in
  let argc = Array.length Sys.argv in
  let filename_missing = ref true in
  for i = 1 to argc - 1 do
    match argv.(i) with
    | "--help" ->
        print_help_message ();
        exit 0
    | "-O" -> optimizations := true
    | "-f" -> compiled_stdin_stdout := true
    | "-i" -> intermediate_stdin_stdout := true
    | _ ->
        if i = argc - 1 then filename_missing := false
        else handle_incorrect_call ()
  done;
  if (not !compiled_stdin_stdout) && not !intermediate_stdin_stdout then (
    if !filename_missing then handle_incorrect_call ();
    filename := argv.(argc - 1));
  if debug then (
    print_string "Optimizations: ";
    print_endline (string_of_bool !optimizations);
    print_string "Program from stdin, compiled to stdout: ";
    print_endline (string_of_bool !compiled_stdin_stdout);
    print_string "Program from stdin, intermediate to stdout: ";
    print_endline (string_of_bool !intermediate_stdin_stdout);
    print_string "Filename: ";
    print_endline !filename)
