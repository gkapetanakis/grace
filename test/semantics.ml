let remove_extension filename =
  let final_dot_index = String.rindex filename '.' in
  String.sub filename 0 final_dot_index

let compile_to_obj filename =
  let inchan = open_in filename in
  let lexbuf = Lexing.from_channel inchan in
  Lexing.set_filename lexbuf filename;
  try
    let ast = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
    Grace_lib.Codegen.irgen ast false;
    let outchan = open_out (remove_extension filename ^ ".o") in
    Grace_lib.Codegen.codegen_obj outchan;
    close_in inchan;
    close_out outchan;
  with
  | Grace_lib.Error.Lexing_error (loc, msg) ->
      Grace_lib.Error.pr_lexing_error (loc, msg)
  | Grace_lib.Parser.Error ->
      Grace_lib.Error.pr_parser_error
        ( (Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf),
          "Syntax error" )
  | Grace_lib.Error.Semantic_error (loc, msg) ->
      Grace_lib.Error.pr_semantic_error (loc, msg)
  | Grace_lib.Error.Symbol_table_error (loc, msg) ->
      Grace_lib.Error.pr_symbol_table_error (loc, msg)
  | Grace_lib.Error.Internal_compiler_error msg ->
      Grace_lib.Error.pr_internal_compiler_error msg

let link_to_exe filename =
  let input = remove_extension filename ^ ".o" in
  let output = remove_extension filename ^ ".exe" in
  if
    Sys.command (Printf.sprintf "clang-14 -o %s %s libgrace.a" output input) <> 0
  then prerr_endline (filename ^ ": Linking failed")

let () =
  let path = "semantics/" in
  let files =
    List.sort String.compare
      (List.filter
         (fun f -> Filename.check_suffix f ".grc")
         (Array.to_list (Sys.readdir path)))
  in
  List.iter
    (fun f ->
      let filename = path ^ f in
      compile_to_obj filename;
      link_to_exe filename)
    files;
  let executables = List.sort String.compare
      (List.filter
         (fun f -> Filename.check_suffix f ".exe")
         (Array.to_list (Sys.readdir path))) in
  List.iter (fun f -> print_endline f; ignore (Sys.command (path ^ f))) executables
