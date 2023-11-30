let handle_incorrect_call () =
  print_endline "Usage: gracec [Options] file";
  print_endline "For more info, try: gracec --help";
  exit (-1)
  [@@ocamlformat "disable"]

let print_help_message () =
  print_endline "Usage: gracec [Options] file";
  print_newline ();
  print_endline "Options:";
  print_endline "  -O  Enable optimizations.";
  print_endline "  -f  Get source code input from stdin and output compiled code to stdout.";
  print_endline "      File argument is not required in this case and will be ignored if provided.";
  print_endline "  -i  Get source code input from stdin and output intermediate code to stdout.";
  print_endline "      File argument is not required in this case and will be ignored if provided."
  [@@ocamlformat "disable"]

(* input flags and filename *)
let optimizations = ref false
let compiled_stdin_stdout = ref false
let intermediate_stdin_stdout = ref false
let filename = ref ""

let () =
  if Array.length Sys.argv < 2 then handle_incorrect_call ();
  for i = 1 to Array.length Sys.argv - 2 do
    match Sys.argv.(i) with
    | "--help" -> print_help_message ()
    | "-O" -> optimizations := true
    | "-f" -> compiled_stdin_stdout := true
    | "-i" -> intermediate_stdin_stdout := true
    | _ -> handle_incorrect_call ()
  done;
  if (not !compiled_stdin_stdout) && not !intermediate_stdin_stdout then
    filename := Sys.argv.(Array.length Sys.argv - 1)
