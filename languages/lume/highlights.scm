;; Literals
(string_literal) @string
(boolean_literal) @boolean

[
    (float_literal)
    (integer_literal)
] @number

;; Comments
(doc_comment) @comment.doc

;; Variables
(variable_declaration name:(identifier) @variable)
(variable_reference (identifier) @variable)

;; Types
(type) @type

(type_params name: (identifier) @type)

(struct_definition name:(identifier) @type)
(enum_definition name:(identifier) @type)
(type_alias name:(identifier) @type)

(enum_definition) @enum
(enum_case_definition) @property
(enum_case_properties) @property
(property) @property

;; Functions
(method_definition) @function
(function_definition) @function

(call_expression callee:(_) @function)

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
(self_reference) @variable.builtin
(self) @variable.builtin

[
  "as"
  "break"
  "builtin"
  "continue"
  "else"
  "enum"
  "external"
  "false"
  "fn"
  "for"
  "if"
  "impl"
  "import"
  "in"
  "let"
  "loop"
  "namespace"
  "pub"
  "return"
  "struct"
  "trait"
  "true"
  "type"
  "unless"
  "use"
  "while"
] @keyword
