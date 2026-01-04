;; Literals
(string_literal) @string
(boolean_literal) @boolean

[
    (float_literal)
    (integer_literal)
] @number

;; Comments
(doc_comment) @comment.doc

;; Imports
(import items:(identifier) @type)

;; Variables
(variable_declaration name:(identifier) @variable)
(variable_reference (identifier) @variable)

;; Types
((identifier) @type (#match? @type "^[A-Z]"))

(type_identifier) @type
(field_identifier) @property

(self_type) @type

(type_parameters name: (identifier) @type)

(enum_definition) @enum
(enum_variant_definition) @type

;; Attributes
(attribute name:(_) @attribute)

;; Expressions
(construct_expression) @constructor
(construct_expression name:(_) @type)
(named_constructor_field name:(identifier) @property)
(implicit_constructor_field name:(identifier) @variable)
(member_expression field:(identifier) @property)

;; Functions
(method_definition name:(_) @function)
(function_definition name:(_) @function)

(call_expression callee:(scoped_identifier name:(_) @function))
(call_expression callee:(variable_reference (identifier) @function))
(call_expression callee:(member_expression field:(identifier) @function))

(parameter name:(identifier) @variable.parameter)

;; Tokens
[
  ";"
  "."
  ","
] @punctuation.delimiter

[
  "--"
  "-"
  "-="
  "&&"
  "+"
  "++"
  "+="
  "<"
  "<="
  "="
  "=="
  "!"
  "!="
  "->"
  ">"
  ">="
  "||"
  "*"
  "*="
  "/"
  "/="
  ":"
] @operator

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
]  @punctuation.bracket

;; Keywords
(self) @variable.builtin

[
  "as"
  "break"
  "continue"
  "else"
  "enum"
  "external"
  "false"
  "fn"
  "for"
  "if"
  "is"
  "impl"
  "import"
  "in"
  "internal"
  "let"
  "loop"
  "namespace"
  "pub"
  "priv"
  "return"
  "struct"
  "switch"
  "trait"
  "true"
  "use"
  "while"
] @keyword
