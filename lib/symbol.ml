class scope =
object
end

class symbol_table (
  _scope: scope option
) =
object
  val scope = _scope

  method get_parent = parent
end
