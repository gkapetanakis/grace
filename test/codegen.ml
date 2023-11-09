open Grace_lib

let () =
  let dummy_loc = (Lexing.dummy_pos, Lexing.dummy_pos) in
  let ar = Ast.Array (Ast.Array (Ast.Char, Some 6), Some 1) in
  let ft = Llvm.function_type Codegen.i8_t [||] in
  let f = Llvm.declare_function "main" ft Codegen.the_module in
  let bb = Llvm.append_block Codegen.context "entry" f in
  Llvm.position_at_end bb Codegen.builder;
  (*let (ptr, typ) = Codegen.codegen_var_def Ast.{node=("id",ar);loc=dummy_loc} in
    let other_ptr = Llvm.build_alloca (Llvm.pointer_type Codegen.context) "other_ptr" Codegen.builder in
    let y = Llvm.build_load (Llvm.pointer_type Codegen.context) ptr "load" Codegen.builder in
    let yy = Llvm.build_gep typ y [|Codegen.c32 0;Codegen.c32 0;Codegen.c32 0|] "gep" Codegen.builder in
    Llvm.build_store (Codegen.c8 97) y Codegen.builder |> ignore;*)
  let xx = Llvm.build_global_stringptr "hello" "hello" Codegen.builder in
  let typ = Codegen.var_type_to_lltype (Ast.Array (Ast.Char, Some 6)) in
  let xxx =
    Llvm.build_gep typ xx
      [| Codegen.c32 0; Codegen.c32 3 |]
      "gep" Codegen.builder
  in
  let y = Llvm.build_load Codegen.i8_t xxx "load" Codegen.builder in
  Llvm.build_ret y Codegen.builder |> ignore;
  (*Llvm.dump_module Codegen.the_module;*)
  Llvm.dump_value y;
  print_newline ();
  Llvm_analysis.assert_valid_function f;
  Llvm.dump_type (Llvm.type_of xxx);
  print_newline ()
