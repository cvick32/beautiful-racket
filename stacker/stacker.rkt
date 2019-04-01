#lang br/quicklang

#|
42

(list)
4 => (list 4)
8 => (list 8 4)
+ => (list + 8 4)
3 => (list 3 12)
* => (list * 3 12)
36

every program specifies a reader and an expander
reader converts source code of our language from a string
  of chars into Racket-style forms, or S-expressions

Every read-syntax has one job: to return code describ­ing a
 mod­ule, pack­aged as a syn­tax object. Racket will replace
 the source code with this mod­ule code. This mod­ule, in turn,
 will invoke the expander for our lan­guage, trig­ger­ing the full
 expan­sion and eval­u­a­tion of the source code.

(module module-name which-expander
   42 ; the body of the module
   "foobar" ; contains expressions
   (+ 1 1) ; to expand & evaluate
   ···)

(module lucy "path/to/expander.rkt"
  42)
|#

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (datum->syntax #f '(module lucy br 42)))

(provide read-syntax)













