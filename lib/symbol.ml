open Types

class entry (
  (_id : string),
  (_info : [
    | `E_var of data_type
    | `E_func of data_type * data_type list * bool
    | `E_param of data_type * bool
  ])
) =
object
  val id = _id 
  val mutable info = _info

  method get_id = id
  method get_info = info
  method set_info i = info <- i
  method get_type =
    match info with
    | `E_var dt -> dt
    | `E_func (dt, _, _) -> dt
    | `E_param (dt, _) -> dt
  method to_string off enable =
    Printf.sprintf "%sEntry(%s, %s)%s" off id 
    (match info with
     | `E_var vd -> vd#to_string "" false
     | `E_func (ht, parl, def) -> (if def then "defined" else "") ^ endl ^
        off ^ "Header(" ^ "id: " ^ id ^ ", fpar_defs: " ^ endl ^
        String.concat "" (List.map (fun f -> f#to_string (off ^ sep) true) parl) ^
        ", data_type: " ^ ht#to_string "" false ^ ")"
     | `E_param (fd, ref) ->
        off ^ "FparDef(" ^ "id: " ^ id ^ ", data_type: " ^ fd#to_string "" false ^ ")" ^
        (if ref then (endl ^ off ^ "pass by reference") else "")
    ) (if enable then Types.endl else "")
end

class scope =
object
  val mutable entries = ([] : entry list)

  method add_entry (e : entry) = entries <- e :: entries
  method get_entries = entries
  method get_entry (id : string) =
    List.find_opt (fun e -> e#get_id = id) entries
  method to_string off enable =
    String.concat (Printf.sprintf "%sScope:%s" off Types.endl)
    ((List.mapi (fun i e -> e#to_string (off ^ Types.sep) (i = List.length entries - 1)) entries) @ [if enable then Types.endl else ""])
end

class symbol_table =
object (self)
  val mutable scopes = ([] : scope list)

  method get_scope_n n = List.nth scopes n
  method get_scope = self#get_scope_n 0
  method add_scope (s : scope )= scopes <- s :: scopes
  method remove_scope = scopes <- List.tl scopes
  method lookup id only_curr =
    let rec aux id only_curr sc_l =
      match only_curr, sc_l with
      | _, [] -> failwith ("Symbol " ^ id ^ " not found")
      | true, sc :: _ -> sc#get_entry id
      | false, sc :: tail ->
        match sc#get_entry id with
        | None -> aux id only_curr tail
        | Some e -> Some e
      in aux id only_curr scopes
  method insert (id : string) (info : [
    | `E_var of data_type
    | `E_func of data_type * data_type list * bool
    | `E_param of data_type * bool
  ]) =
    let e = new entry (id, info) in
    match scopes with
    | [] -> failwith "No scope to insert entry"
    | sc :: _ -> sc#add_entry e

  method to_string off enable =
    String.concat (Printf.sprintf "%sSymbol Table:%s" off Types.endl)
    ((List.mapi (fun i s -> s#to_string (off ^ Types.sep) (i = List.length scopes - 1)) scopes) @ [if enable then Types.endl else ""])
end
