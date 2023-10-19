(*type _arit_op =
  | Add
  | Subtract
  | Multiply
  | Divide
  | Modulo

type _unary_arit_op =
  | Positive
  | Negative

type _comp_op = 
  | Equal
  | NotEqual
  | Less
  | More
  | LessEqual
  | MoreEqual

type _logic_op =
  | And
  | Or

type _type =
  | Int
  | Char
  | Nothing
  | Array of _type * int option

type _internal_type =
  | Bool
  | Void

type loc = Lexing.position * Lexing.position

(*type _lv_type =
  | Identifier
  | LambdaString
  | ArrayAccess*)

class type virtual ['a] node_t = object
  method get_loc : loc
  method get_type : 'a
  method virtual to_string_aux : string -> string
  method to_string : string -> bool -> string
end

class type arit_op_t = object
  inherit [_arit_op] node_t
  method to_string_aux : string -> string
end

class type unary_arit_op_t = object
  inherit [_unary_arit_op] node_t
  method to_string_aux : string -> string
end

class type comp_op_t = object
  inherit [_comp_op] node_t
  method to_string_aux : string -> string
end

class type logic_op_t = object
  inherit [_logic_op] node_t
  method to_string_aux : string -> string
end

class type data_type_t = object
  inherit [_type] node_t
  method private print_dim : 'a option -> string
  method to_string_aux : string -> string
end

class type var_def_t = object
  inherit [_type] node_t
  method get_id : string
  method to_string_aux : string -> string
end

class type fpar_def_t = object
  inherit var_def_t
  method get_ref : bool
  method to_string_aux : string -> string
end

class type _lv_type = object
  method get_type : [
    | `Identifier of string
    | `LambdaString of string
    | `ArrayAccess of l_value_t * expr_t
  ]
end

and l_value_t = object
  inherit [_type] node_t
  method get_cons : _lv_type (* some constructor type... *)
  method to_string_aux : string -> string
end

and _expr_type = object
  method get_type : [
    | `LiteralInt of int
    | `LiteralChar of char
    | `LValue of l_value_t
    | `EFuncCall of func_call_t
    | `AritOp of expr_t * arit_op_t * expr_t
  ]
end

and expr_t = object
  inherit [_type] node_t
  method get_cons : _expr_type
  method to_string_aux : string -> string
end

and func_call_t = object
  inherit [_type] node_t
  method get_id : string
  method get_params : expr_t list
  method to_string_aux : string -> string
end

class type _cond_type = object
  method get_type : [
    | `LogicalNot of cond_t
    | `LogicOp of cond_t * logic_op_t * cond_t
    | `CompOp of expr_t * comp_op_t * expr_t
  ]
end

and cond_t = object
  inherit [_internal_type] node_t
  method get_cons : _cond_type
  method to_string_aux : string -> string
end

class type _stmt_type = object
  method get_type : [
    | `EmptyStatement
    | `Assign of l_value_t * expr_t
    | `Block of block_t
    | `SFuncCall of func_call_t
    | `IfThenElse of cond_t * stmt_t option * stmt_t option
    | `WhileLoop of cond_t * stmt_t
    | `Return of expr_t option
  ]
end

and stmt_t = object
  inherit [_internal_type] node_t
  method get_cons : _stmt_type
  method to_string_aux : string -> string
end

and block_t = object
  inherit [_internal_type] node_t
  method get_stmts : stmt_t list
  method to_string_aux : string -> string
end

class type header_t = object
  inherit [_type] node_t
  method get_id : string
  method get_fpar_defs : fpar_def_t list
  method to_string_aux : string -> string
end

class type func_decl_t = object
  inherit header_t
  method to_string_aux : string -> string (* will be overriden... *)
end

class type func_def_t = object
  inherit header_t
  method get_local_defs : local_def_t list
  method get_block : block_t
  method to_string_aux : string -> string
end

and _local_def_type = object
  method get_type : [
    | `LocalFuncDef of func_def_t
    | `LocalFuncDecl of func_decl_t
    | `LocalVarDef of var_def_t
  ]
end

and local_def_t = object
  inherit [_type] node_t
  method get_cons : _local_def_type
  method to_string_aux : string -> string
end*)