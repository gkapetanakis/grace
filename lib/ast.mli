val sep : string
val endl : string
type loc = Lexing.position * Lexing.position
class virtual node :
  loc ->
  object
    val loc : loc
    method loc : loc
    method to_string : string -> bool -> string
    method private virtual to_string_aux : string -> string
  end
class arit_op :
  loc * [ `Add | `Divide | `Modulo | `Multiply | `Subtract ] ->
  object
    val arit_op : [ `Add | `Divide | `Modulo | `Multiply | `Subtract ]
    val loc : loc
    method get_arit_op : [ `Add | `Divide | `Modulo | `Multiply | `Subtract ]
    method loc : loc
    method to_string : string -> bool -> string
    method to_string_aux : string -> string
  end
class unary_arit_op :
  loc * [ `Negative | `Positive ] ->
  object
    val loc : loc
    val unary_arit_op : [ `Negative | `Positive ]
    method get_unary_arit_op : [ `Negative | `Positive ]
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class comp_op :
  loc * [ `Equal | `Less | `LessEqual | `More | `MoreEqual | `NotEqual ] ->
  object
    val comp_op :
      [ `Equal | `Less | `LessEqual | `More | `MoreEqual | `NotEqual ]
    val loc : loc
    method get_comp_op :
      [ `Equal | `Less | `LessEqual | `More | `MoreEqual | `NotEqual ]
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class logic_op :
  loc * [ `And | `Or ] ->
  object
    val loc : loc
    val logic_op : [ `And | `Or ]
    method get_logic_op : [ `And | `Or ]
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class data_type :
  loc * ([ `Array of 'a * int option | `Char | `Int | `Nothing ] as 'a) ->
  object
    val data_typ : 'a
    val loc : loc
    method get_data_typ : 'a
    method loc : loc
    method private print_dim : int option -> string
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class virtual type_node :
  loc * data_type ->
  object
    val loc : loc
    val typ : data_type
    method get_type : data_type
    method loc : loc
    method to_string : string -> bool -> string
    method private virtual to_string_aux : string -> string
  end
class var_def :
  loc * string * data_type ->
  object
    val data_type : data_type
    val id : string
    val loc : loc
    val typ : data_type
    method get_data_type : data_type
    method get_id : string
    method get_type : data_type
    method loc : loc
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
    val typ : data_type
    method get_data_type : data_type
    method get_id : string
    method get_ref : bool
    method get_type : data_type
    method loc : loc
    method to_string : string -> bool -> string
    method to_string_aux : string -> string
  end
class l_value :
  loc *
  [ `ArrayAccess of l_value * expr
  | `Identifier of string
  | `LambdaString of string ] ->
  object
    val l_value :
      [ `ArrayAccess of l_value * expr
      | `Identifier of string
      | `LambdaString of string ]
    val loc : loc
    val typ : data_type
    method get_l_value :
      [ `ArrayAccess of l_value * expr
      | `Identifier of string
      | `LambdaString of string ]
    method get_type : data_type
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and expr :
  loc *
  [ `AritOp of expr * arit_op * expr
  | `EFuncCall of func_call
  | `LValue of l_value
  | `LiteralChar of char
  | `LiteralInt of int
  | `Signed of unary_arit_op * expr ] ->
  object
    val expr :
      [ `AritOp of expr * arit_op * expr
      | `EFuncCall of func_call
      | `LValue of l_value
      | `LiteralChar of char
      | `LiteralInt of int
      | `Signed of unary_arit_op * expr ]
    val loc : loc
    val typ : data_type
    method get_expr :
      [ `AritOp of expr * arit_op * expr
      | `EFuncCall of func_call
      | `LValue of l_value
      | `LiteralChar of char
      | `LiteralInt of int
      | `Signed of unary_arit_op * expr ]
    method get_type : data_type
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and func_call :
  loc * string * expr list ->
  object
    val args : expr list
    val id : string
    val loc : loc
    val typ : data_type
    method get_args : expr list
    method get_id : string
    method get_type : data_type
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class cond :
  loc *
  [ `CompOp of expr * comp_op * expr
  | `LogicOp of cond * logic_op * cond
  | `Not of cond ] ->
  object
    val cons :
      [ `CompOp of expr * comp_op * expr
      | `LogicOp of cond * logic_op * cond
      | `Not of cond ]
    val loc : loc
    method get_cons :
      [ `CompOp of expr * comp_op * expr
      | `LogicOp of cond * logic_op * cond
      | `Not of cond ]
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
class stmt :
  loc *
  [ `Assign of l_value * expr
  | `Block of block
  | `EmptyStatement
  | `IfThenElse of cond * stmt option * stmt option
  | `Return of expr option
  | `SFuncCall of func_call
  | `WhileLoop of cond * stmt ] ->
  object
    val cons :
      [ `Assign of l_value * expr
      | `Block of block
      | `EmptyStatement
      | `IfThenElse of cond * stmt option * stmt option
      | `Return of expr option
      | `SFuncCall of func_call
      | `WhileLoop of cond * stmt ]
    val loc : loc
    method get_cons :
      [ `Assign of l_value * expr
      | `Block of block
      | `EmptyStatement
      | `IfThenElse of cond * stmt option * stmt option
      | `Return of expr option
      | `SFuncCall of func_call
      | `WhileLoop of cond * stmt ]
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and block :
  loc * stmt list ->
  object
    val loc : loc
    val stmts : stmt list
    method get_stmts : stmt list
    method loc : loc
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
    val typ : data_type
    method get_data_type : data_type
    method get_fpar_defs : fpar_def list
    method get_id : string
    method get_type : data_type
    method loc : loc
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
    val typ : data_type
    method get_data_type : data_type
    method get_fpar_defs : fpar_def list
    method get_id : string
    method get_type : data_type
    method loc : loc
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
    val typ : data_type
    method get_block : block
    method get_header : header
    method get_local_defs : local_def list
    method get_type : data_type
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
and local_def :
  loc *
  [ `LocalFuncDecl of func_decl
  | `LocalFuncDef of func_def
  | `LocalVarDef of var_def ] ->
  object
    val cons :
      [ `LocalFuncDecl of func_decl
      | `LocalFuncDef of func_def
      | `LocalVarDef of var_def ]
    val loc : loc
    val typ : data_type
    method get_cons :
      [ `LocalFuncDecl of func_decl
      | `LocalFuncDef of func_def
      | `LocalVarDef of var_def ]
    method get_type : data_type
    method loc : loc
    method to_string : string -> bool -> string
    method private to_string_aux : string -> string
  end
