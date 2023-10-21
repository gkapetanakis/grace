open Ast

(* to be used in parser rule fpar_def *)
let fpar_def_to_list loc ref ids ft : param node list =
  let rf = if ref then ByReference else ByValue in
  let rec aux ref ids ft acc =
    match ids with
    | [] -> List.rev acc
    | id :: ids -> aux ref ids ft ({loc = loc; node = (id,ft,rf)} :: acc)
  in aux ref ids ft []

(* to be used in parser rule var_def *)
let var_def_to_list loc ids vt : var node list =
  let rec aux ids vt acc =
    match ids with
    | [] -> List.rev acc
    | id :: ids -> aux ids vt ({loc = loc; node = (id,vt)} :: acc)
  in aux ids vt []