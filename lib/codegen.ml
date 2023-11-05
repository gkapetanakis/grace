let context = Llvm.global_context ()
let modulx = Llvm.create_module context "Grace"
let builder = Llvm.builder context

let i1_t = Llvm.i1_type context (* bool *)
let i8_t = Llvm.i8_type context (* char *)
let i32_t = Llvm.i32_type context (* int *)
let i64_t = Llvm.i64_type context (* ase *)
let void_t = Llvm.void_type context (* nothing *)

let c8 = Llvm.const_int i8_t
let c32 = Llvm.const_int i32_t
let c64 = Llvm.const_int i64_t

(* Edsger runtime library functions *)
let write_integer_t = Llvm.function_type void_t [|i32_t|]
let _ = Llvm.declare_function "writeInteger" write_integer_t modulx

let write_char_t = Llvm.function_type void_t [|i8_t|]
let _ = Llvm.declare_function "writeChar" write_char_t modulx

let write_string_t = Llvm.function_type void_t [|Llvm.pointer_type context|]
let _ = Llvm.declare_function "writeString" write_string_t modulx

let read_integer_t = Llvm.function_type i32_t [|void_t|]
let _ = Llvm.declare_function "readInteger" read_integer_t modulx

let read_char_t = Llvm.function_type i8_t [|void_t|]
let _ = Llvm.declare_function "readChar" read_char_t modulx

let read_string_t = Llvm.function_type void_t [|i32_t; Llvm.pointer_type context|]
let _ = Llvm.declare_function "readString" read_string_t modulx

(* Grace runtime library functions *)
let ascii_t = Llvm.function_type i32_t [|i8_t|]
let _ = Llvm.declare_function "ascii" ascii_t modulx

let chr_t = Llvm.function_type i8_t [|i32_t|]
let _ = Llvm.declare_function "chr" chr_t modulx

(* C runtime library functions *)
let strlen_t = Llvm.function_type i32_t [|Llvm.pointer_type context|]
let _ = Llvm.declare_function "strlen" strlen_t modulx

let strcmp_t = Llvm.function_type i32_t [|Llvm.pointer_type context; Llvm.pointer_type context|]
let _ = Llvm.declare_function "strcmp" strcmp_t modulx

let strcpy_t = Llvm.function_type void_t [|Llvm.pointer_type context; Llvm.pointer_type context|]
let _ = Llvm.declare_function "strcpy" strcpy_t modulx

let strcat_t = Llvm.function_type void_t [|Llvm.pointer_type context; Llvm.pointer_type context|]
let _ = Llvm.declare_function "strcat" strcat_t modulx


