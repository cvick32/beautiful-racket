#lang br

(module reader br
  (require wires/parser
           wires/tokenizer)
  (provide read-syntax)
  (define (read-syntax name port)
    (define parse-tree (parse (tokenize port)))
    (strip-bindings
     #`(module dsl-mod-name wires/expander
         #,@parse-tree))))
