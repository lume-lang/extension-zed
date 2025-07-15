;; Literals
(string_value) @string
(number_value) @number
(boolean_value) @boolean

;; Blocks
(block type:(identifier) @property)
(field name:(identifier) @property)

(block) @class.around
(block fields:(body) @class.inside)

;; Tokens

"=" @operator

[
  "["
  "]"
  "{"
  "}"
]  @punctuation.bracket
