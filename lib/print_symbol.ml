open Symbol
open Print_ast

let pr_entry_type off enable et =
  match et with
  | Variable var ->
    off ^ "Variable: " ^ endl ^
    pr_var (off ^ sep) enable var
  | Parameter param ->
    off ^ "Parameter: " ^ endl ^
    pr_param (off ^ sep) enable param
  | Function { header; _} ->
    off ^ "Function: " ^ endl ^
    pr_header (off ^ sep) enable header

let pr_entry off enable {id;info} =
  off ^ "Entry: " ^ id ^ endl ^
  pr_entry_type (off ^ sep) enable info

let pr_scope off enable {entries} =
  let str = off ^ "Scope: " ^ endl ^
    String.concat ""
      (List.mapi 
        (fun i entry ->
          pr_entry (off ^ sep) (i = List.length entries - 1) entry) entries)
  in  
  pr_enable str enable

let pr_symbol_table off enable (sym_tbl : symbol_table) =
  let sym_tbl = !sym_tbl in
  let str = off ^ "Symbol Table: " ^ endl ^
    String.concat ""
      (List.mapi 
        (fun i scope ->
          pr_scope (off ^ sep) (i = List.length sym_tbl - 1) scope) sym_tbl)
  in
  pr_enable str enable