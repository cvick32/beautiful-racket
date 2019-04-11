#|
#lang jsonic-demo
// a line comment
[
  @$ 'null $@,
  @$ (* 6 7) $@,
  @$ (= 2 (+ 1 1)) $@,
  @$ (list "array" "of" "strings") $@,
  @$ (hash 'key-1 'null
           'key-2 (even? 3)
           'key-3 (hash 'subkey 21)) $@
]
|#
#lang br
(require jsonic/parser jsonic/tokenizer brag/support)

(parse-to-datum (apply-tokenizer-maker make-tokenizer "// line comment\n"))
(parse-to-datum (apply-tokenizer-maker make-tokenizer "@$ 42 $@"))
(parse-to-datum (apply-tokenizer-maker make-tokenizer "hi"))
(parse-to-datum (apply-tokenizer-maker make-tokenizer "hi\n//comment\n@$ 42 $@"))
; here string example
(parse-to-datum (apply-tokenizer-maker make-tokenizer #<<DEREK
"foo"
// comment
@$ 42 $@
DEREK
))