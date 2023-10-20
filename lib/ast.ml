open Types
open Symbol

let sym_tbl = new symbol_table

class virtual type_node (
  _loc,
  (_type : data_type)
) =
object
  inherit node (_loc)
  val typ = _type
  method get_type = typ
end

class arit_op (
  _loc,
  (_arit_op : [
    | `Add
    | `Subtract
    | `Multiply
    | `Divide
    | `Modulo
  ])
) =
object
  inherit node (_loc)
  val arit_op = _arit_op

  method get_arit_op = arit_op
  method to_string_aux off =
    match arit_op with
    | `Add       -> off ^ "Add"
    | `Subtract  -> off ^ "Subtract"
    | `Multiply  -> off ^ "Multiply"
    | `Divide    -> off ^ "Divide"
    | `Modulo    -> off ^ "Modulo"
end

class unary_arit_op (
  _loc,
  (_unary_arit_op : [
    | `Positive
    | `Negative
  ])) = 
object
  inherit  node (_loc)
  val unary_arit_op = _unary_arit_op

  method get_unary_arit_op = unary_arit_op
  method private to_string_aux off =
    match unary_arit_op with
    | `Positive  -> off ^ "Positive"
    | `Negative  -> off ^ "Negative"
end

class comp_op (
  _loc,
  (_comp_op : [
    | `Equal
    | `NotEqual
    | `Less
    | `More
    | `LessEqual
    | `MoreEqual
  ])) = 
object
  inherit node (_loc)
  val comp_op = _comp_op

  method get_comp_op = comp_op
  method private to_string_aux off =
    match comp_op with
    | `Equal     -> off ^ "Equal"
    | `NotEqual  -> off ^ "NotEqual"
    | `Less      -> off ^ "Less"
    | `More      -> off ^ "More"
    | `LessEqual -> off ^ "LessEqual"
    | `MoreEqual -> off ^ "MoreEqual"
end

class logic_op (
  _loc,
  (_logic_op : [
    | `And
    | `Or
  ])) =
object
  inherit node (_loc)
  val logic_op = _logic_op

  method get_logic_op = logic_op
  method private to_string_aux off =
    match logic_op with
    | `And       -> off ^ "And"
    | `Or        -> off ^ "Or"
end

class var_def (
  _loc,
  (_id : string),
  (_data_type : data_type))
  =
  let sem () =
    match sym_tbl#lookup _id true with
    | Some _ -> failwith ("Variable " ^ _id ^ " already defined in the same scope")
    | None -> sym_tbl#insert _id (`E_var _data_type )
  in
object
  inherit type_node ((sem () ; _loc), _data_type)
  val id = _id
  val data_type = _data_type

  method get_id = id
  method get_data_type = data_type
  method private to_string_aux off =
    off ^ "VarDef(" ^ "id: " ^ id ^ ", data_type: " ^ data_type#to_string "" false ^ ")"
end

class fpar_def (
  _loc,
  (_ref : bool),
  (_id : string),
  (_data_type : data_type))
  =
  let check_type () =
    match _data_type#get_data_typ, _ref with
    | `Array _, false -> failwith "Arrays must be passed by reference"
    | _ -> _data_type
  in
object
  inherit type_node (_loc, check_type())
  val ref = _ref
  val id = _id
  val data_type = _data_type

  method get_ref = ref
  method get_id = id
  method get_data_type = data_type
  method to_string_aux off =
    off ^ "FparDef(" ^ "id: " ^ id ^ ", data_type: " ^ data_type#to_string "" false ^ ")" ^
    (if ref then (endl ^ off ^ "pass by reference") else "")
end

class l_value (
  _loc,
  (_l_value : [
    | `Identifier of string
    | `LambdaString of string
    | `ArrayAccess of l_value * expr
  ]))
  =
  let lv_type () =
    match _l_value with
    | `Identifier id -> (
      match sym_tbl#lookup id false with
      | Some e -> e#get_type
      | None -> failwith ("Variable " ^ id ^ " not defined in any scope")
    )
    | `LambdaString ls ->
      new data_type (
        _loc,
        `Array (`Char, Some (String.length ls + 1))
      )
    | `ArrayAccess (lv, e) ->
      if e#get_type#get_data_typ = `Int then
        match lv#get_type#get_data_typ with
        | `Array (t, _) ->
          new data_type (_loc, t)
        | _ -> failwith "Array access on non-array"
      else failwith "Array access with non-int index"
  in
object
  inherit type_node (_loc, lv_type ())
  val l_value = _l_value

  method get_l_value = l_value
  method private to_string_aux off =
    off ^ "LValue(" ^ "type: " ^ (match l_value with
      | `Identifier id -> "Identifier(" ^ id ^ ")"
      | `LambdaString ls -> "LambdaString(\"" ^ ls ^ "\")"
      | `ArrayAccess (lv, e) ->
        "ArrayAccess: " ^ endl ^
        lv#to_string (off ^ sep) true ^
        e#to_string (off ^ sep) false
    ) ^ ")"
end

and expr (
  _loc,
  (_expr : [
    | `LiteralInt of int
    | `LiteralChar of char
    | `LValue of l_value
    | `EFuncCall of func_call
    | `Signed of unary_arit_op * expr
    | `AritOp of expr * arit_op * expr
  ])
) =
  let expr_type () = 
    match _expr with
    | `LiteralInt _ -> new data_type(_loc, `Int)
    | `LiteralChar _ -> new data_type(_loc, `Char)
    | `LValue lv -> lv#get_type
    | `EFuncCall fc -> fc#get_type
    | `Signed (_, e) ->
      if e#get_type#get_data_typ = `Int
        then new data_type(_loc, `Int)
      else failwith "Unary arithmetic operation on non-int"
    | `AritOp (e1, _, e2) -> 
      if
        e1#get_type#get_data_typ = `Int &&
        e2#get_type#get_data_typ = `Int
        then new data_type(_loc, `Int)
      else failwith "Arithmetic operation on non-ints"
  in
object
  inherit type_node (_loc, expr_type ())
  val expr = _expr

  method get_expr = expr
  method private to_string_aux off =
    match expr with
    | `LiteralInt i -> off ^ "LiteralInt(" ^ string_of_int i ^ ")"
    | `LiteralChar c -> off ^ "LiteralChar(" ^ Char.escaped c ^ ")"
    | `LValue lv -> off ^ "LValue: " ^ endl ^ lv#to_string (off ^ sep) false
    | `EFuncCall fc -> off ^ "EFuncCall: " ^ endl ^ fc#to_string (off ^ sep) false
    | `Signed (op, e) ->
      off ^ "Signed: " ^ endl ^
      op#to_string (off ^ sep) true ^
      e#to_string (off ^ sep) false
    | `AritOp (e1, op, e2) ->
      off ^ "AritOp: " ^ endl ^
      e1#to_string (off ^ sep) true ^
      op#to_string (off ^ sep) true ^
      e2#to_string (off ^ sep) false
end

and func_call (
  _loc,
  (_id : string),
  (_args : expr list))
  =
  let rec comp_arg_types args param_list =
    match args, param_list with
    | [], [] -> true
    | [], _ -> failwith "Too few arguments"
    | _, [] -> failwith "Too many arguments"
    | e :: es, p :: ps ->
      if e#get_type#get_data_typ = p#get_data_typ
        then comp_arg_types es ps
      else failwith "Argument type mismatch"
  in
  let sem () =
    match sym_tbl#lookup _id false with
    | Some e -> (
      match e#get_info with
      | `E_func (fd, pl, _) when comp_arg_types _args pl -> fd
      | _ -> failwith ("Variable " ^ _id ^ " is not a function")
    )
    | None -> failwith ("Variable " ^ _id ^ " not defined in any scope")
  in
object
  inherit type_node (_loc, sem ())
  val id = _id
  val args = _args

  method get_id = id
  method get_args = args
  method private to_string_aux off =
    off ^ "FuncCall(" ^ "id: " ^ id ^ ", args: " ^ endl ^
    String.concat "" (List.map (fun e -> e#to_string (off ^ sep) true) args) ^
    ")"
end

class cond (
  _loc,
  (_cond : [
    | `CompOp of expr * comp_op * expr
    | `LogicOp of cond * logic_op * cond
    | `Not of cond
  ])
  ) =
  let sem () =
    match _cond with
    | `CompOp (e1, _, e2) ->
      let aux e1 e2 tt =
        e1#get_type#get_data_typ = tt && e2#get_type#get_data_typ = tt in
      if aux e1 e2 `Int || aux e1 e2 `Char
      then ()
      else failwith "Comparison of different types"
    | _ -> ()
  in
object
  inherit node (sem(); _loc)
  val cons = _cond

  method get_cons = cons
  method private to_string_aux off =
    match cons with
    | `CompOp (e1, op, e2) ->
      off ^ "CompOp: " ^ endl ^
      e1#to_string (off ^ sep) true ^
      op#to_string (off ^ sep) true ^
      e2#to_string (off ^ sep) false
    | `LogicOp (c1, op, c2) ->
      off ^ "LogicOp: " ^ endl ^
      c1#to_string (off ^ sep) true ^
      op#to_string (off ^ sep) true ^
      c2#to_string (off ^ sep) false
    | `Not c ->
      off ^ "Not: " ^ endl ^
      c#to_string (off ^ sep) false
end

class stmt (
  _loc,
  (_stmt : [
    | `EmptyStatement
    | `Assign of l_value * expr
    | `Block of block
    | `SFuncCall of func_call
    | `IfThenElse of cond * stmt option * stmt option
    | `WhileLoop of cond * stmt
    | `Return of expr option
  ])
  ) =
  let check_types () =
    match _stmt with
    | `Assign (lv, e) ->
      let aux e1 e2 tt =
        e1#get_type#get_data_typ = tt && e2#get_type#get_data_typ = tt in
      if aux lv e `Int || aux lv e `Char then ()
      else failwith "Assignment of different types"
    | `Return ex -> (
      let ex_typ = match ex with
        | None -> `Nothing
        | Some e -> e#get_type#get_data_typ in
      let sc = sym_tbl#get_scope_n 1 in
      let en = List.hd sc#get_entries in
      match ex_typ, en#get_info with
      | `Array _, _ -> failwith "Arrays cannot be returned"
      | _ as ex_typ,`E_func (fd, _, _) ->
        if ex_typ = fd#get_data_typ
          then ()
        else failwith "Return type mismatch"
      | _ -> failwith "Function definition not found"
      )
    | _ -> ()
  in
object
  inherit node (check_types (); _loc)
  val cons = _stmt

  method get_cons = cons
  method private to_string_aux off =
    match cons with
    | `EmptyStatement -> off ^ "EmptyStatement"
    | `Assign (lv, e) ->
      off ^ "Assign: " ^ endl ^
      lv#to_string (off ^ sep) true ^
      e#to_string (off ^ sep) false
    | `Block b -> b#to_string off false
    | `SFuncCall fc ->
      off ^ "SFuncCall: " ^ endl ^
      fc#to_string (off ^ sep) false
    | `IfThenElse (c, s1, s2) ->
      off ^ "IfThenElse: " ^ endl ^
      c#to_string (off ^ sep) true ^
      (match s1 with
      | None -> ""
      | Some s -> s#to_string (off ^ sep) (Option.is_some s2)
      ) ^
      (match s2 with
      | None -> ""
      | Some s -> s#to_string (off ^ sep) false
      )
    | `WhileLoop (c, s) ->
      off ^ "WhileLoop: " ^ endl ^
      c#to_string (off ^ sep) true ^
      s#to_string (off ^ sep) false
    | `Return e ->
      off ^ "Return: " ^ (if Option.is_some e then endl else "") ^
      (match e with
      | None -> ""
      | Some e -> e#to_string (off ^ sep) false
      )
end

and block (
  _loc,
  (_stmts : stmt list)
  ) =
object
  inherit node (_loc)
  val stmts = _stmts

  method get_stmts = stmts
  method private to_string_aux off =
    off ^ "Block: " ^ endl ^
    String.concat "" (List.map (fun s -> s#to_string (off ^ sep) true) stmts)
end

class header (
  _loc,
  (_id : string),
  (_fpar_defs : fpar_def list),
  (_data_type : data_type))
  =
  let check_type () =
    match _data_type#get_data_typ with
    | `Array _ -> failwith "Arrays cannot be returned"
    | _ -> _data_type
  in
object
  inherit type_node (_loc, check_type ())
  val id = _id
  val fpar_defs = _fpar_defs
  val data_type = _data_type

  method get_id = id
  method get_fpar_defs = fpar_defs
  method get_data_type = data_type
  method private to_string_aux off =
    off ^ "Header(" ^ "id: " ^ id ^ ", fpar_defs: " ^ endl ^
    String.concat "" (List.map (fun f -> f#to_string (off ^ sep) true) fpar_defs) ^
    ", data_type: " ^ data_type#to_string "" false ^ ")"
end

class func_decl (
  _loc,
  (_id : string),
  (_fpar_defs : fpar_def list),
  (_data_type : data_type))
  =
  let sem () =
    match sym_tbl#lookup _id true with
    | Some _ -> failwith ("Function " ^ _id ^ " already defined in the same scope")
    | None ->
      let dt_lst = List.map (fun f -> f#get_data_type) _fpar_defs in
      sym_tbl#insert _id (`E_func (_data_type, dt_lst, false))
  in
object
  inherit header ((sem (); _loc), _id, _fpar_defs, _data_type) as super
  method! to_string_aux off =
    off ^ "FuncDecl(" ^ endl
    ^ super#to_string (off ^ sep) false ^ ")"
end

class func_def (
  _loc,
  (_header : header),
  (_local_defs : local_def list),
  (_block : block))
  =
  let sem () =
    match sym_tbl#lookup _header#get_id true with
    | Some en -> (
      match en#get_info with
      | `E_func (fd, dl, false) -> en#set_info (`E_func (fd, dl, true))
      | _ -> failwith "Function already defined"
    )
    | None -> failwith "Function definition without declaration"
  in
object
  inherit type_node ((sem (); _loc), _header#get_type)
  val header = _header
  val local_defs = _local_defs
  val block = _block

  method get_header = header
  method get_local_defs = local_defs
  method get_block = block
  method private to_string_aux off =
    off ^ "FuncDef(" ^ endl ^
    header#to_string (off ^ sep) true ^
    String.concat "" (List.map (fun l -> l#to_string (off ^ sep) true) local_defs) ^
    block#to_string (off ^ sep) false ^ ")"
end

and local_def (
  _loc,
  (_local_def : [
    | `LocalFuncDef of func_def
    | `LocalFuncDecl of func_decl
    | `LocalVarDef of var_def
  ]))
  =
  let check_type () =
    match _local_def with
    | `LocalFuncDef fd -> fd#get_type (* more to do? *)
    | `LocalFuncDecl fd -> fd#get_type (* more to do? *)
    | `LocalVarDef vd -> vd#get_type
  in
object
  inherit type_node (_loc, check_type ())
  val cons = _local_def

  method get_cons = cons
  method private to_string_aux off =
    match cons with
    | `LocalFuncDef fd -> off ^ "LocalFuncDef: " ^ endl ^ fd#to_string (off ^ sep) false
    | `LocalFuncDecl fd -> off ^ "LocalFuncDecl: " ^ endl ^ fd#to_string (off ^ sep) false
    | `LocalVarDef vd -> off ^ "LocalVarDef: " ^ endl ^ vd#to_string (off ^ sep) false
end

