let context = Llvm.global_context ()
let the_module = Llvm.create_module context "grace"
let builder = Llvm.builder context
let i8_t = Llvm.i8_type context
let i32_t = Llvm.i32_type context
let void_t = Llvm.void_type context
let c8 = Llvm.const_int i8_t
let c32 = Llvm.const_int i32_t

let grace_static_lib () =
  let func_decl (name, ret_type, arg_l) =
    let ft = Llvm.function_type ret_type (Array.of_list arg_l) in
    Llvm.declare_function name ft the_module |> ignore
  in
  List.iter func_decl
    [
      ("writeInteger", void_t, [ i32_t ]);
      ("writeChar", void_t, [ i8_t ]);
      ("writeString", void_t, [ Llvm.pointer_type i8_t ]);
      ("readInteger", i32_t, []);
      ("readChar", i8_t, []);
      ("readString", void_t, [ i32_t; Llvm.pointer_type i8_t ]);
      ("ascii", i32_t, [ i8_t ]);
      ("chr", i8_t, [ i32_t ]);
      ("strlen", i32_t, [ Llvm.pointer_type i8_t ]);
      ("strcmp", i32_t, [ Llvm.pointer_type i8_t; Llvm.pointer_type i8_t ]);
      ("strcpy", void_t, [ Llvm.pointer_type i8_t; Llvm.pointer_type i8_t ]);
      ("strcat", void_t, [ Llvm.pointer_type i8_t; Llvm.pointer_type i8_t ]);
    ]

let rec type_to_lltype = function
  | Ast.Int -> i32_t
  | Ast.Char -> i8_t
  | Ast.Nothing -> void_t
  | Ast.Array (t, dims) ->
      let rec aux t dims =
        match dims with
        | [] -> type_to_lltype t
        | d :: dims -> Llvm.array_type (aux t dims) (Option.get d)
      in
      aux t dims

let var_def_lltype (vd : Ast.var_def) = type_to_lltype vd.type_t

let param_def_lltype (pd : Ast.param_def) =
  match pd.pass_by with
  | Ast.Value -> type_to_lltype pd.type_t
  | Ast.Reference -> (
      match pd.type_t with
      | Ast.Array (t, _ :: tl) ->
          Llvm.pointer_type (type_to_lltype (Ast.Array (t, tl)))
      | _ -> Llvm.pointer_type (type_to_lltype pd.type_t))

(*
  type_by_name is the Llvm function that returns the type with a specific name if it exists
*)
