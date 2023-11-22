type scalar_type = Integer | Character

type aggregate_type = Array of complete_type * int
and complete_type = Scalar of scalar_type | Aggregate of aggregate_type

type incomplete_type = Void
type unary_arithmetic_operator = Positive | Negative

type binary_arithmetic_operator =
  | Addition
  | Subtraction
  | Multiplication
  | Division
  | Modulo

type unary_logical_operator = Not
type binary_logical_operator = And | Or

type relational_operator =
  | Equal
  | NotEqual
  | GreaterThan
  | LesserThan
  | GreaterThanOrEqual
  | LesserThanOrEqual

type variable_type = complete_type
type parameter_type = Direct of complete_type | Pointer of complete_type
type return_type = Complete of complete_type | Incomplete of incomplete_type

type l_value =
  | Identifier of string
  | IdentifierIndexing of l_value * expression

and function_call = string * expression list

and expression =
  | IntegerLiteral of int
  | CharacterLiteral of char
  | StringLiteral of string
  | StringLiteralIndexing of string * expression
  | LValue of l_value
  | FunctionCall of function_call
  | UnaryArithmeticOperation of unary_arithmetic_operator * expression
  | BinaryArithmeticOperation of
      expression * binary_arithmetic_operator * expression

type condition =
  | UnaryLogicalOperation of unary_logical_operator * condition
  | BinaryLogicalOperation of condition * binary_logical_operator * condition
  | RelationalOperation of expression * relational_operator * expression

type block = statement list

and statement =
  | Empty
  | Assignment of l_value * expression
  | Block of block
  | FunctionCallStatement of function_call
  | IfConstruct of condition * statement * statement option
  | WhileConstruct of condition * statement
  | Return of expression option

type evaluation_strategy = PassByValue | PassByReference
type variable_definition = string * variable_type
type parameter_definition = string * evaluation_strategy * parameter_type
type header = string * parameter_definition list * return_type
type function_declaration = header

type function_definition = header * local_definition list * block

and local_definition =
  | FunctionDeclaration of function_declaration
  | FunctionDefinition of function_definition
  | VariableDefinition of variable_definition

type program = MainFunction of function_definition
