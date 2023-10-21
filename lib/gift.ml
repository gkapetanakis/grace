open Sem

let wrap_var_type loc dt dims =
  let node = Ast.get_var_type dt dims in
  verify_var {loc; node = ("", node)};
  node

