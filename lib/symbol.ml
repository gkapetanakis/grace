open Ast

class entry (
  (_id : string),
  (_info : [
    | `E_var of var_def
    | `E_func of func_def * bool
    | `E_param of fpar_def
  ])
) =
object
  val id = _id 
  val info = _info

  method get_id = id
  method get_info = info
end

class scope =
object
  val mutable entries = ([] : entry list)

  method add_entry (e : entry) = entries <- e :: entries
  method get_entries = entries
  method get_entry (id : string) =
    List.find_opt (fun e -> e#get_id = id) entries
end

class symbol_table =
object
  val mutable scopes = ([] : scope list)

  method get_scope = List.hd scopes
  method add_scope (s : scope )= scopes <- s :: scopes
  method remove_scope = scopes <- List.tl scopes
  method get_entry id only_curr =
    let rec aux id only_curr sc_l =
      match only_curr, sc_l with
      | _, [] -> failwith ("Symbol " ^ id ^ " not found")
      | true, sc :: _ -> sc#get_entry id
      | false, sc :: tail ->
        match sc#get_entry id with
        | None -> aux id only_curr tail
        | Some e -> Some e
      in aux id only_curr scopes
  method entry_insert (id : string) (info : [
    | `E_var of var_def
    | `E_func of func_def * bool
    | `E_param of fpar_def
  ]) =
    let e = new entry (id, info) in
    match scopes with
    | [] -> failwith "No scope to insert entry"
    | sc :: _ -> sc#add_entry e
end
