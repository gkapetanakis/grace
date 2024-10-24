let compile_to_obj filename =
  let inchan = open_in filename in
  let outchan = open_out (Filename.remove_extension filename ^ ".test.o") in
  let lexbuf = Lexing.from_channel inchan in
  Lexing.set_filename lexbuf filename;
  try
    let the_module, context, irgen, _, _, codegen_obj =
      Grace_lib.Codegen.init_codegen filename
    in
    let ast = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
    irgen ast false;
    codegen_obj outchan;
    Grace_lib.Codegen.dispose_codegen the_module context;
    close_in inchan;
    close_out outchan
  with err -> (
    close_in inchan;
    close_out outchan;
    match err with
    | Grace_lib.Error.Lexing_error (loc, msg) ->
        Grace_lib.Error.pr_lexing_error (loc, msg);
        exit 1
    | Grace_lib.Parser.Error ->
        Grace_lib.Error.pr_parser_error
          ( (Lexing.lexeme_start_p lexbuf, Lexing.lexeme_end_p lexbuf),
            "Syntax error" );
        exit 1
    | Grace_lib.Error.Semantic_error (loc, msg) ->
        Grace_lib.Error.pr_semantic_error (loc, msg);
        exit 1
    | Grace_lib.Error.Symbol_table_error (loc, msg) ->
        Grace_lib.Error.pr_symbol_table_error (loc, msg);
        exit 1
    | Grace_lib.Error.Codegen_error (loc, msg) ->
        Grace_lib.Error.pr_codegen_error (loc, msg);
        exit 1
    | Grace_lib.Error.Internal_compiler_error msg ->
        Grace_lib.Error.pr_internal_compiler_error msg
    | err -> raise err)

let link_to_exe filename =
  let linker = "clang-14" in
  let input = Filename.remove_extension filename ^ ".test.o" in
  let output = Filename.remove_extension filename ^ ".test.exe" in
  let runtime_path = "../runtime_lib" in
  let runtime_name = "grace" in
  if
    Sys.command
      (Printf.sprintf "%s -no-pie -o %s %s -L %s -l %s" linker output input
         runtime_path runtime_name)
    <> 0
  then (
    prerr_endline (filename ^ ": Linking failed");
    exit 1)

let () =
  let my_compare x y =
    if String.length x > String.length y then 1
    else if String.length x < String.length y then -1
    else String.compare x y
  in
  let path = "semantics/" in
  let files =
    List.sort my_compare
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
    List.sort my_compare
      (List.filter
         (fun f -> Filename.check_suffix f ".test.exe")
         (Array.to_list (Sys.readdir path)))
  in
  List.iter (fun f -> ignore (Sys.command (path ^ f))) executables
