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
((type name:(_) @type) (#match? @type "^[A-Z]"))
((type name:(path (scoped_identifier name:(_) @type) (#match? @type "^[A-Z]"))))

(type_params name: (identifier) @type)

(struct_definition name:(identifier) @type)
(enum_definition name:(identifier) @type)
(trait name:(identifier) @type)

(enum_definition) @enum
(enum_case_definition) @property
(enum_case_properties) @property
(property name:(_) @property)

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
  "priv"
  "return"
  "struct"
  "trait"
  "true"
  "use"
  "while"
] @keyword
