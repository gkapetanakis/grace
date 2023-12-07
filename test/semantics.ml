let remove_extension filename =
  let final_dot_index = String.rindex filename '.' in
  String.sub filename 0 final_dot_index

let compile_to_obj filename =
  let inchan = open_in filename in
  let lexbuf = Lexing.from_channel inchan in
  Lexing.set_filename lexbuf filename;
  try
    let the_module, context, irgen, _, _, codegen_obj =
      Grace_lib.Codegen.init_codegen ()
    in
    let ast = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
    irgen ast false;
    let outchan = open_out (remove_extension filename ^ ".o") in
    codegen_obj outchan;
    Grace_lib.Codegen.dispose_codegen (the_module, context);
    close_in inchan;
    close_out outchan
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
  let linker = "clang-14" in
  let input = remove_extension filename ^ ".o" in
  let output = remove_extension filename ^ ".exe" in
  let runtime_path = "../runtime_lib/" in
  let runtime_name = "grace" in
  if
    Sys.command
      (Printf.sprintf "%s -no-pie -o %s %s -L %s -l %s" linker output
         input runtime_path runtime_name)
    <> 0
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
  let executables =
    List.sort String.compare
      (List.filter
         (fun f -> Filename.check_suffix f ".exe")
         (Array.to_list (Sys.readdir path)))
  in
  List.iter (fun f -> ignore (Sys.command (path ^ f))) executables
