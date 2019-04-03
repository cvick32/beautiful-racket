#lang br/quicklang
(provide + *)

#|
In effect, we can think of this as the spec­i­fi­ca­tion for our vari­adic-to-dyadic
 macro: the macro needs to rewrite an expres­sion like (+ 1 2 3 4 5) to look
 like (+ 1 (+ 2 (+ 3 (+ 4 5)))), for any num­ber of argu­ments.
|#
(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin EXPR))
(provide (rename-out [stackerizer-mb #%module-begin]))

#|
to make a syn­tax object within the cur­rent lex­i­cal con­text, we use the #' pre­fix
|#
(define-macro-cases +
  [(+ FIRST) #'FIRST]
  [(+ FIRST NEXT ...) #'(list '+ FIRST (+ NEXT ...))]) ; this plus is recursion

