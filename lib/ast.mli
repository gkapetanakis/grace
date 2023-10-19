val sep : string
val endl : string
type _arit_op = Add | Subtract | Multiply | Divide | Modulo
type _unary_arit_op = Positive | Negative
type _comp_op = Equal | NotEqual | Less | More | LessEqual | MoreEqual
type _logic_op = And | Or
type _type = Int | Char | Nothing | Array of _type * int option
type _internal_type = Bool | Void
type loc = Lexing.position * Lexing.position
class virtual ['a] node :
  loc * 'a ->
  object
    val loc : loc
    val typ : 'a
    method get_loc : loc
    method get_type : 'a
    method to_string : string -> bool -> string
    method private virtual to_string_aux : string -> string
  end
class arit_op :
  loc * _arit_op ->
  object
    val loc : loc
    val typ : _arit_op
    method get_loc : loc
    method get_type : _arit_op
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class unary_arit_op :
  loc * _unary_arit_op ->
  object
    val loc : loc
    val typ : _unary_arit_op
    method get_loc : loc
    method get_type : _unary_arit_op
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class comp_op :
  loc * _comp_op ->
  object
    val loc : loc
    val typ : _comp_op
    method get_loc : loc
    method get_type : _comp_op
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class logic_op :
  loc * _logic_op ->
  object
    val loc : loc
    val typ : _logic_op
    method get_loc : loc
    method get_type : _logic_op
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class data_type :
  loc * _type ->
  object
    val loc : loc
    val typ : _type
    method get_loc : loc
    method get_type : _type
    method private print_dim : int option -> string
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class var_def :
  loc * string * data_type ->
  object
    val data_type : data_type
    val id : string
    val loc : loc
    val typ : _type
    method get_data_type : data_type
    method get_id : string
    method get_loc : loc
    method get_type : _type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class fpar_def :
  loc * bool * string * data_type ->
  object
    val data_type : data_type
    val id : string
    val loc : loc
    val ref : bool
    val typ : _type
    method get_data_type : data_type
    method get_id : string
    method get_loc : loc
    method get_ref : bool
    method get_type : _type
    method to_string : string -> bool -> string
    method to_string_aux : string -> string
  end
class _l_value :
  [ `ArrayAccess of l_value * expr
  | `Identifier of string
  | `LambdaString of string ] ->
  object
    method get_type :
      [ `ArrayAccess of l_value * expr
      | `Identifier of string
      | `LambdaString of string ]
  end
and l_value :
  loc * _l_value ->
  object
    val cons : _l_value
    val loc : loc
    val typ : _type
    method get_cons : _l_value
    method get_loc : loc
    method get_type : _type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and _expr :
  [ `AritOp of expr * arit_op * expr
  | `EFuncCall of func_call
  | `LValue of l_value
  | `LiteralChar of char
  | `LiteralInt of int
  | `Signed of unary_arit_op * expr ] ->
  object
    method get_type :
      [ `AritOp of expr * arit_op * expr
      | `EFuncCall of func_call
      | `LValue of l_value
      | `LiteralChar of char
      | `LiteralInt of int
      | `Signed of unary_arit_op * expr ]
  end
and expr :
  loc * _expr ->
  object
    val cons : _expr
    val loc : loc
    val typ : _type
    method get_cons : _expr
    method get_loc : loc
    method get_type : _type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and func_call :
  loc * string * expr list ->
  object
    val args : expr list
    val id : string
    val loc : loc
    val typ : _type
    method get_args : expr list
    method get_id : string
    method get_loc : loc
    method get_type : _type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class _cond :
  [ `CompOp of expr * comp_op * expr
  | `LogicOp of cond * logic_op * cond
  | `Not of cond ] ->
  object
    method get_type :
      [ `CompOp of expr * comp_op * expr
      | `LogicOp of cond * logic_op * cond
      | `Not of cond ]
  end
and cond :
  loc * _cond ->
  object
    val cons : _cond
    val loc : loc
    val typ : _internal_type
    method get_cons : _cond
    method get_loc : loc
    method get_type : _internal_type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class _stmt :
  [ `Assign of l_value * expr
  | `Block of block
  | `EmptyStatement
  | `IfThenElse of cond * stmt option * stmt option
  | `Return of expr option
  | `SFuncCall of func_call
  | `WhileLoop of cond * stmt ] ->
  object
    method get_type :
      [ `Assign of l_value * expr
      | `Block of block
      | `EmptyStatement
      | `IfThenElse of cond * stmt option * stmt option
      | `Return of expr option
      | `SFuncCall of func_call
      | `WhileLoop of cond * stmt ]
  end
and stmt :
  loc * _stmt ->
  object
    val cons : _stmt
    val loc : loc
    val typ : _internal_type
    method get_cons : _stmt
    method get_loc : loc
    method get_type : _internal_type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and block :
  loc * stmt list ->
  object
    val loc : loc
    val stmts : stmt list
    val typ : _internal_type
    method get_loc : loc
    method get_stmts : stmt list
    method get_type : _internal_type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class header :
  loc * string * fpar_def list * data_type ->
  object
    val data_type : data_type
    val fpar_defs : fpar_def list
    val id : string
    val loc : loc
    val typ : _type
    method get_data_type : data_type
    method get_fpar_defs : fpar_def list
    method get_id : string
    method get_loc : loc
    method get_type : _type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class func_decl :
  loc * string * fpar_def list * data_type ->
  object
    val data_type : data_type
    val fpar_defs : fpar_def list
    val id : string
    val loc : loc
    val typ : _type
    method get_data_type : data_type
    method get_fpar_defs : fpar_def list
    method get_id : string
    method get_loc : loc
    method get_type : _type
    method to_string : string -> bool -> string
    method to_string_aux : string -> string
  end
class func_def :
  loc * header * local_def list * block ->
  object
    val block : block
    val header : header
    val loc : loc
    val local_defs : local_def list
    val typ : _type
    method get_block : block
    method get_header : header
    method get_loc : loc
    method get_local_defs : local_def list
    method get_type : _type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and _local_def :
  [ `LocalFuncDecl of func_decl
  | `LocalFuncDef of func_def
  | `LocalVarDef of var_def ] ->
  object
    method get_type :
      [ `LocalFuncDecl of func_decl
      | `LocalFuncDef of func_def
      | `LocalVarDef of var_def ]
  end
and local_def :
  loc * _local_def ->
  object
    val cons : _local_def
    val loc : loc
    val typ : _type
    method get_cons : _local_def
    method get_loc : loc
    method get_type : _type
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
