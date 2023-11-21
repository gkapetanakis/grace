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

(*
  // grace code
  fun f(a: int): nothing
    var b: char[5];
    var c: int;
    fun g(): nothing
    {}
    fun h(): nothing
    {
      g();
    }
  {
  }

  // llvm representation (kind of)
  struct frame__f {
    void* parent;
    int a;
    char b[5];
    int c;
  }

  struct frame__f_g {
    frame__f* parent;
  }

  struct frame__f_h {
    frame__f* parent;
  }

  // llvm code (high level)
  fun func__f(ref x: frame__f): nothing
  {
  }

  fun func__f_g(ref x: frame__f_g): nothing
  {
  }

  fun func__f_h(ref x: frame__f_h): nothing
  {
    func__f_g(x.parent);
  }
*)

let get_parent_name (func: Ast.func) = String.concat "_" (List.rev func.parent_path)

let get_func_name (func: Ast.func) = (get_parent_name func) ^ "_" ^ func.id

let get_parent_frame_name (func: Ast.func) = "frame__" ^ (get_parent_name func)

let get_frame_name (func: Ast.func) = "frame__" ^ (get_func_name func)

let get_parent_frame_ptr (func: Ast.func) =
  let parent_frame_name = get_parent_frame_name func in
  match Llvm.type_by_name the_module parent_frame_name with
    | Some frame -> Llvm.pointer_type frame
    | None -> Llvm.pointer_type void_t

let get_frame_type (func: Ast.func) =
  let frame_name = get_frame_name func in
  match Llvm.type_by_name the_module frame_name with
  | Some frame -> Llvm.pointer_type frame
  | None -> raise (Failure ("Frame type not found: " ^ frame_name))

let get_all_frame_types (Ast.MainFunc main_func: Ast.program) =
  let rec aux (acc: Llvm.lltype list) (funcs: Ast.func list) =
    match funcs with
    | [] -> List.rev acc
    | hd :: tl -> 
      let _, _, local_func_defs = Ast.reorganize_local_defs hd.local_defs in
      aux ((get_frame_type hd) :: acc) (tl @ local_func_defs) in
  aux [] [main_func]

let gen_frame_type (func: Ast.func) =
  let parent_frame_ptr = get_parent_frame_ptr func in
  let param_lltypes = List.map param_def_lltype func.params in
  let local_var_defs, _, _ = Ast.reorganize_local_defs func.local_defs in
  let local_var_lltypes = List.map var_def_lltype local_var_defs in
  let frame_name = get_frame_name func in
  let frame_field_types = Array.of_list (parent_frame_ptr :: param_lltypes @ local_var_lltypes) in
  let frame_type = Llvm.named_struct_type context frame_name in
  Llvm.struct_set_body frame_type frame_field_types false

let gen_all_frame_types (Ast.MainFunc main_func: Ast.program) =
  let rec aux (func: Ast.func) =
    gen_frame_type func;
    let _, _, local_func_defs = Ast.reorganize_local_defs func.local_defs in
    List.iter aux local_func_defs in
  aux main_func
