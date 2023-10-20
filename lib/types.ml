let sep, endl = "--", "\n"

type loc = Lexing.position * Lexing.position

class virtual node (
  (_loc: loc)
) =
object (self)
  val loc = _loc

  method loc = loc
  method private virtual to_string_aux : string -> string
  method to_string off enable =
    self#to_string_aux off ^ (if enable then endl else "")
end

class data_type (
  _loc,
  (_data_typ : ([
    | `Int
    | `Char
    | `Nothing
    | `Array of 'a * int option
  ] as 'a))) =
object (self)
  inherit node (_loc)
  val data_typ = _data_typ

  method private print_dim = function
  | None -> "None"
  | Some h -> string_of_int h

  method get_data_typ = data_typ
  method private to_string_aux off =
    let rec aux off = function
    | `Int          -> off ^ "Int"
    | `Char         -> off ^ "Char"
    | `Nothing      -> off ^ "Nothing"
    | `Array (t, d) -> off ^ "Array(" ^ aux "" t ^ ", " ^ self#print_dim d ^ ")"
    in aux off data_typ
end