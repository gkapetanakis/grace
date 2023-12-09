let remove_extension filename = Filename.remove_extension filename

let symbolic_names (path : string) (filenames : string list)
    (differentiator : string) (extension : string) =
  let rec aux filenames acc =
    match filenames with
    | [] -> List.rev acc
    | filename :: filenames ->
        let destination =
          remove_extension filename ^ differentiator ^ extension
        in
        Unix.symlink ~to_dir:false filename (path ^ destination);
        aux filenames (destination :: acc)
  in
  aux filenames []

let compile_to_obj filename =
  let inchan = open_in filename in
  let outchan = open_out (remove_extension filename ^ ".o") in
  let lexbuf = Lexing.from_channel inchan in
  Lexing.set_filename lexbuf filename;
  try
    let the_module, context, irgen, _, _, codegen_obj =
      Grace_lib.Codegen.init_codegen filename
    in
    let ast = Grace_lib.Parser.program Grace_lib.Lexer.token lexbuf in
    irgen ast false;
    codegen_obj outchan;
    Grace_lib.Codegen.dispose_codegen (the_module, context);
    close_in inchan;
    close_out outchan;
    prerr_endline ("Error: Successfully compiled " ^ filename);
    exit 1
  with err -> (
    close_in inchan;
    close_out outchan;
    Sys.remove (remove_extension filename ^ ".o");
    match err with
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
    | Grace_lib.Error.Codegen_error (loc, msg) ->
        Grace_lib.Error.pr_codegen_error (loc, msg)
    | Grace_lib.Error.Internal_compiler_error msg ->
        Grace_lib.Error.pr_internal_compiler_error msg
    | err -> raise err)

let () =
  let my_compare x y =
    if String.length x > String.length y then 1
    else if String.length x < String.length y then -1
    else String.compare x y
  in
  let path = "semantics_erroneous/" in
  let original_files =
    List.sort my_compare
      (List.filter
         (fun f -> Filename.check_suffix f ".grc")
         (Array.to_list (Sys.readdir path)))
  in
  let files =
    symbolic_names path original_files "__IGNORE_THIS_TEXT_42" ".grc"
  in
  List.iter
    (fun f ->
      let filename = path ^ f in
      compile_to_obj filename)
    files
