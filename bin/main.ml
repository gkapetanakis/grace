(* debug flag *)
let debug = true

let dev_null =
  if Sys.os_type = "Unix" then "/dev/null"
  else if Sys.os_type = "Win32" || Sys.os_type = "Cygwin" then "NUL"
  else failwith ("Unsupported operating system: " ^ Sys.os_type)

let linker = "clang-14"

(* input flags and filename *)
let optimizations = ref false
let asm_stdin_stdout = ref false
let imm_stdin_stdout = ref false
let filename = ref String.empty

let print_debug_info () =
  print_string "Optimizations: ";
  print_endline (string_of_bool !optimizations);
  print_string "Program from stdin, compiled to stdout: ";
  print_endline (string_of_bool !asm_stdin_stdout);
  print_string "Program from stdin, intermediate to stdout: ";
  print_endline (string_of_bool !imm_stdin_stdout);
  print_string "Filename: ";
  print_endline !filename
  [@@ocamlformat "disable"]

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

let remove_path filename =
  let final_slash_index = String.rindex filename '/' in
  String.sub filename (final_slash_index + 1)
    (String.length filename - final_slash_index - 1)

let process_arguments () =
  let argv = Sys.argv in
  let argc = Array.length Sys.argv in
  for i = 1 to argc - 1 do
    match argv.(i) with
    | "--help" ->
        print_help_message ();
        exit 0
    | "-O" -> optimizations := true
    | "-f" -> asm_stdin_stdout := true
    | "-i" -> imm_stdin_stdout := true
    | _ ->
        if i = argc - 1 then filename := argv.(i) else handle_incorrect_call ()
  done;
  if !filename = String.empty && not (!asm_stdin_stdout || !imm_stdin_stdout)
  then handle_incorrect_call ()

let open_in_channel () =
  if !asm_stdin_stdout || !imm_stdin_stdout then stdin else open_in !filename

let open_imm_out_channel () =
  (* -f flag has precedence over -i flag *)
  if !asm_stdin_stdout then open_out dev_null
  else if !imm_stdin_stdout then stdout
  else open_out (remove_extension !filename ^ ".imm")

let open_asm_out_channel () =
  (* -f flag has precedence over -i flag *)
  if !asm_stdin_stdout then stdout
  else if !imm_stdin_stdout then open_out dev_null
  else open_out (remove_extension !filename ^ ".asm")

let open_obj_out_channel () =
  if !asm_stdin_stdout then open_out dev_null
  else if !imm_stdin_stdout then open_out dev_null
  else open_out (remove_extension !filename ^ ".o")

(* main *)
let () =
  process_arguments ();
  if debug then print_debug_info ();
  let inchan = open_in_channel () in
  let imm_outchan = open_imm_out_channel () in
  let asm_outchan = open_asm_out_channel () in
  let obj_outchan = open_obj_out_channel () in
  let lexbuf = Lexing.from_channel inchan in
  try
    let ast = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
    Grace_lib.Codegen.codegen ast !optimizations ~imm_outchan ~asm_outchan
      ~obj_outchan;
    close_in inchan;
    close_out imm_outchan;
    close_out asm_outchan;
    close_out obj_outchan;
    let runtime_path = "runtime_lib/" in
    let runtime_name = "grace" in
    if (not !asm_stdin_stdout) && not !imm_stdin_stdout then
      let exit_code =
        Sys.command
          (Printf.sprintf "%s -no-pie -o executables/%s.exe %s.o -L %s -l %s" linker
             (remove_path (remove_extension !filename))
             (remove_extension !filename)
             runtime_path runtime_name)
      in
      exit exit_code
  with
  | Grace_lib.Error.Lexing_error (loc, msg) ->
      Grace_lib.Error.pr_lexing_error (loc, msg)
  | Grace_lib.Parser.Error ->
      (* built-in Menhir error... *)
      Grace_lib.Error.pr_parser_error
        ( (Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf),
          "Syntax error" )
  | Grace_lib.Error.Semantic_error (loc, msg) ->
      Grace_lib.Error.pr_semantic_error (loc, msg)
  | Grace_lib.Error.Symbol_table_error (loc, msg) ->
      Grace_lib.Error.pr_symbol_table_error (loc, msg)
  | Grace_lib.Error.Internal_compiler_error msg ->
      Grace_lib.Error.pr_internal_compiler_error msg
