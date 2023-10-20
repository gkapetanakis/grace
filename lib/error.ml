(* error handling *)
open Lexing

exception Grace_err of (string * string * position)

let print_err err =
  match err with
  | Grace_err (err_type, message, { pos_fname = filename; pos_lnum = line; pos_bol; pos_cnum }) ->
    let col = pos_cnum - pos_bol + 1 in
    let err_message, position =
      Printf.sprintf "%s error: %s" err_type message, 
      Printf.sprintf "File: %s, Line: %d, Column: %d" filename line col in
    prerr_endline err_message;
    prerr_endline position
  | _ -> print_endline "Unknown error"

let fail err_type s pos =
  raise (Grace_err (err_type, s, pos))

let fail_b err_type s lexbuf =
  let p = lexbuf.Lexing.lex_start_p in
  fail err_type s p