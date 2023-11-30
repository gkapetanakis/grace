(* debug flag *)
let debug = true

let dev_null =
  if Sys.os_type = "Unix" then "/dev/null"
  else if Sys.os_type = "Win32" || Sys.os_type = "Cygwin" then "NUL"
  else failwith ("Unsupported operating system: " ^ Sys.os_type)

(* input flags and filename *)
let optimizations = ref false
let compiled_stdin_stdout = ref false
let intermediate_stdin_stdout = ref false
let filename = ref ""

(* helper functions *)
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

let remove_extension filename =
  let final_dot_index = String.rindex filename '.' in
  String.sub filename 0 final_dot_index

let process_arguments () =
  let argv = Sys.argv in
  let argc = Array.length Sys.argv in
  if argc < 2 then handle_incorrect_call ();
  let missing_filename = ref true in
  for i = 1 to argc - 1 do
    match argv.(i) with
    | "--help" ->
        print_help_message ();
        exit 0
    | "-O" -> optimizations := true
    | "-f" -> compiled_stdin_stdout := true
    | "-i" -> intermediate_stdin_stdout := true
    | _ ->
        if i = argc - 1 then missing_filename := false
        else handle_incorrect_call ()
  done;
  if not (!compiled_stdin_stdout || !intermediate_stdin_stdout) then
    if !missing_filename then handle_incorrect_call ()
    else filename := argv.(argc - 1)

let open_in_channel () =
  if !compiled_stdin_stdout || !intermediate_stdin_stdout then stdin
  else open_in !filename

let open_intermediate_out_channel () =
  (* -f flag has precedence over -i flag *)
  if !compiled_stdin_stdout then open_out dev_null
  else if !intermediate_stdin_stdout then stdout
  else open_out (remove_extension !filename ^ ".imm")

let open_compiled_out_channel () =
  (* -f flag has precedence over -i flag *)
  if !compiled_stdin_stdout then stdout
  else if !intermediate_stdin_stdout then open_out dev_null
  else open_out (remove_extension !filename ^ ".asm")

(* main *)
let () =
  process_arguments ();
  if debug then (
    print_string "Optimizations: ";
    print_endline (string_of_bool !optimizations);
    print_string "Program from stdin, compiled to stdout: ";
    print_endline (string_of_bool !compiled_stdin_stdout);
    print_string "Program from stdin, intermediate to stdout: ";
    print_endline (string_of_bool !intermediate_stdin_stdout);
    print_string "Filename: ";
    print_endline !filename);
  let inchan = open_in_channel () in
  let ir_outchan = open_intermediate_out_channel () in
  let comp_outchan = open_compiled_out_channel () in
  let lexbuf = Lexing.from_channel inchan in
  let ast = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
  Grace_lib.Codegen.codegen ast !optimizations ir_outchan comp_outchan
