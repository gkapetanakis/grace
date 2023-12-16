(* DONE *)
(* the functions of this module are used to reduce
   the size of the parser *)

(* they take parsed objects (Ast nodes) and perform semantic analysis
   (by calling functions from Sem) as well as symbol table actions
   (by calling functions from Symbol) *)

let create_sym_tbl () =
  Symbol.{ scopes = []; table = Hashtbl.create 100; parent_path = [] }

(* a wrapper function creates a 'gift' (an Ast node) by wrapping values,
   which is returned to the caller after all necessary semantic actions
   are performed *)

(* the following function performs the semantic actions and returns the
   'gift' afterwards, and is therefore called 'enjoy' *)
let enjoy sem gift =
  ignore (sem ());
  gift

let wrap_open_scope func_id sym_tbl = Symbol.open_scope func_id sym_tbl

(* when closing a scope we should check for lingering function definitions/declarations *)
let wrap_close_scope loc sym_tbl =
  Sem.sem_close_scope loc sym_tbl;
  Symbol.close_scope loc sym_tbl

let wrap_var_def loc id vt sym_tbl =
  let var_def : Ast.var_def =
    {
      id;
      var_type = vt;
      frame_offset = Symbol.get_and_increment_offset sym_tbl;
      parent_path = sym_tbl.parent_path;
      loc;
    }
  in
  let sem () =
    Sem.sem_var_def var_def sym_tbl;
    Sem.ins_var_def var_def sym_tbl
  in
  enjoy sem var_def

let wrap_param_def loc id pt pb (_sym_tbl : Symbol.symbol_table) =
  let param_def : Ast.param_def =
    {
      id;
      param_type = pt;
      pass_by = pb;
      frame_offset = 0;
      (* will be set by wrap_decl/def_header *)
      parent_path = [];
      (* will be set by wrap_decl/def_header *)
      loc;
    }
  in
  let sem () = () in
  enjoy sem param_def

let wrap_l_value_id loc id exprs sym_tbl =
  let l_value_id : Ast.l_value_id =
    {
      id;
      data_type = Scalar Nothing;
      (* will be changed by sem_l_value *)
      passed_by = Value;
      (* will be changed by sem_l_value *)
      frame_offset = -1;
      (* will be changed by sem_l_value *)
      parent_path = [];
      (* will be changed by sem_l_value *)
      loc;
    }
  in
  let l_value =
    match exprs with
    | [] -> Ast.Simple (Id l_value_id)
    | _ -> Ast.ArrayAccess { simple_l_value = Id l_value_id; exprs }
  in
  let sem () = Sem.sem_l_value l_value sym_tbl in
  enjoy sem l_value

let wrap_l_value_string loc str exprs sym_tbl =
  let l_value_str : Ast.l_value_lstring =
    { id = str; data_type = Array (Char, [ Some (String.length str) ]); loc }
  in
  let l_value =
    match exprs with
    | [] -> Ast.Simple (LString l_value_str)
    | _ -> Ast.ArrayAccess { simple_l_value = LString l_value_str; exprs }
  in
  let sem () = Sem.sem_l_value l_value sym_tbl in
  enjoy sem l_value

let wrap_func_call loc id exprs (sym_tbl : Symbol.symbol_table) =
  let func_call : Ast.func_call =
    {
      id;
      args = [];
      (* will be set in sem_func_call *)
      ret_type = Nothing;
      (* will be set in sem_func_call *)
      callee_path = [];
      (* will be set in sem_func_call *)
      caller_path = sym_tbl.parent_path;
      loc;
    }
  in
  let sem () = Sem.sem_func_call func_call exprs sym_tbl in
  enjoy sem func_call

let wrap_expr_lit_int loc num sym_tbl =
  let expr : Ast.expr = LitInt { value = num; loc } in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_lit_char loc chr sym_tbl =
  let expr : Ast.expr = LitChar { value = chr; loc } in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_l_value _loc lv sym_tbl =
  let expr : Ast.expr = LValue lv in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_func_call _loc fc sym_tbl =
  let expr : Ast.expr = EFuncCall fc in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_un_arit_op _loc op rhs sym_tbl =
  let expr : Ast.expr = UnAritOp (op, rhs) in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_expr_bin_arit_op _loc op lhs rhs sym_tbl =
  let expr : Ast.expr = BinAritOp (lhs, op, rhs) in
  let sem () = Sem.sem_expr expr sym_tbl in
  enjoy sem expr

let wrap_cond_un_logic_op _loc op c sym_tbl =
  let cond : Ast.cond = UnLogicOp (op, c) in
  let sem () = Sem.sem_cond cond sym_tbl in
  enjoy sem cond

let wrap_cond_bin_logic_op _loc op lhs rhs sym_tbl =
  let cond : Ast.cond = BinLogicOp (lhs, op, rhs) in
  let sem () = Sem.sem_cond cond sym_tbl in
  enjoy sem cond

let wrap_cond_comp_op _loc op lhs rhs sym_tbl =
  let cond : Ast.cond = CompOp (lhs, op, rhs) in
  let sem () = Sem.sem_cond cond sym_tbl in
  enjoy sem cond

let wrap_block loc stmts =
  let flattened_stmts =
    List.fold_right
      (fun stmt acc ->
        match stmt with
        | Ast.Empty _ -> acc
        | Block b -> b.stmts @ acc
        | _ -> stmt :: acc)
      stmts []
  in
  let stmts =
    List.fold_right
      (fun stmt acc ->
        match stmt with
        | Ast.Empty _ -> acc (* ignore empty statements *)
        | Ast.Return _ ->
            [ stmt ] (* ignore everything after a return statement *)
        | _ -> stmt :: acc)
      flattened_stmts []
  in
  ({ stmts; loc } : Ast.block)

let wrap_stmt_empty loc sym_tbl =
  let stmt : Ast.stmt = Empty loc in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_assign _loc lv e sym_tbl =
  let stmt : Ast.stmt = Assign (lv, e) in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

(* note: blocks don't cause the opening of new scopes,
   as Grace does not allow the declaration of new variables
   inside them *)
let wrap_stmt_block _loc b sym_tbl =
  let stmt : Ast.stmt = Block b in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_func_call _loc fc sym_tbl =
  let stmt : Ast.stmt = SFuncCall fc in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_if _loc c s1 s2 sym_tbl =
  let stmt : Ast.stmt = If (c, s1, s2) in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_while _loc c s sym_tbl =
  let stmt : Ast.stmt = While (c, s) in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_stmt_return loc e_o sym_tbl =
  let stmt : Ast.stmt = Return { expr_o = e_o; loc } in
  let sem () = Sem.sem_stmt stmt sym_tbl in
  enjoy sem stmt

let wrap_decl_header loc id pd_l ret_type (sym_tbl : Symbol.symbol_table) =
  let decl : Ast.func =
    {
      id;
      params = pd_l;
      ret_type;
      local_defs = [];
      body = None;
      loc;
      parent_path = sym_tbl.parent_path;
      status = Declared;
    }
  in
  let sem () =
    Sem.sem_func_decl decl sym_tbl;
    Sem.ins_func_decl decl sym_tbl;
    (* open a new scope after inserting the declaration of a function *)
    wrap_open_scope id sym_tbl;
    List.iter
      (fun (pd : Ast.param_def) ->
        pd.frame_offset <- Symbol.get_and_increment_offset sym_tbl;
        pd.parent_path <- sym_tbl.parent_path;
        Sem.sem_param_def pd sym_tbl;
        Sem.ins_param_def pd sym_tbl)
      pd_l;
    (* close the scope after inserting all parameters *)
    wrap_close_scope loc sym_tbl
  in
  enjoy sem decl

let wrap_def_header loc id pd_l ret_type (sym_tbl : Symbol.symbol_table) =
  let def : Ast.func =
    {
      id;
      params = pd_l;
      ret_type;
      local_defs = [];
      (* will be added later *)
      body = None;
      (* will be added later *)
      loc;
      parent_path = sym_tbl.parent_path;
      status = Defined;
    }
  in
  let sem () =
    Sem.sem_func_def def sym_tbl;
    Sem.ins_func_def def sym_tbl;
    (* open a new scope after inserting the declaration of a function *)
    (* this scope will be closed by the parser *)
    wrap_open_scope id sym_tbl;
    List.iter
      (fun (pd : Ast.param_def) ->
        pd.frame_offset <- Symbol.get_and_increment_offset sym_tbl;
        pd.parent_path <- sym_tbl.parent_path;
        Sem.sem_param_def pd sym_tbl;
        Sem.ins_param_def pd sym_tbl)
      pd_l
  in
  enjoy sem def

let wrap_func_decl (func : Ast.func) = func

let wrap_func_def (func : Ast.func) (ld_l : Ast.local_def list) (b : Ast.block)
    =
  func.local_defs <- ld_l;
  func.body <- Some b;
  func

let wrap_local_def_fdef (func : Ast.func) = [ Ast.FuncDef func ]
let wrap_local_def_fdecl (func : Ast.func) = [ Ast.FuncDecl func ]

let wrap_local_def_var (vd_l : Ast.var_def list) =
  List.map (fun vd -> Ast.VarDef vd) vd_l

(* after the Grace compiler creates an object file using LLVM,
   clang is used to link that object file to Grace's runtime library,
   as well as C's runtime library *)

(* clang is made to natively support C-style main functions,
   meaning ones called 'main' that return an integer *)

(* therefore, to make our lives a bit easier, we insert a function into
   the program called 'main' that calls the actual main function *)

(* the following function does what is described above *)
let insert_virtual_main (func : Ast.func) =
  let main_func : Ast.func =
    {
      id = Symbol.global_scope_name;
      params = [];
      ret_type = Int;
      local_defs = [ FuncDef func ];
      body =
        Some
          {
            stmts =
              [
                SFuncCall
                  {
                    id = func.id;
                    args = [];
                    ret_type = func.ret_type;
                    callee_path = func.parent_path;
                    caller_path = [];
                    loc = func.loc;
                  };
                Return
                  {
                    expr_o = Some (LitInt { value = 0; loc = func.loc });
                    loc = func.loc;
                  };
              ];
            loc = func.loc;
          };
      loc = func.loc;
      (* it's the actual first function, so it has no parent *)
      parent_path = [];
      status = Defined;
    }
  in
  main_func

let wrap_program (func : Ast.func) sym_tbl =
  let sem () = Sem.sem_program func sym_tbl in
  enjoy sem (Ast.MainFunc (insert_virtual_main func))
