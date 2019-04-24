#lang br/quicklang

; READER CODE
(module+ reader
  (provide read-syntax))

(define (read-syntax name port)
  (define wire-datums
    (for/list ([wire-str (in-lines port)])
      (format-datum '(wire ~a) wire-str)))
  (strip-bindings
   #`(module wires-mod wires/main
       #,@wire-datums)))
