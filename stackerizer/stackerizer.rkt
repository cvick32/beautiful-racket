#lang br/quicklang

#|
This language translates racket syntax to stacker syntax (previous lang)

In effect, we can think of this as the spec­i­fi­ca­tion for our vari­adic-to-dyadic
 macro: the macro needs to rewrite an expres­sion like (+ 1 2 3 4 5) to look
 like (+ 1 (+ 2 (+ 3 (+ 4 5)))), for any num­ber of argu­ments.
|#

(provide + *)

(define-macro (stackerizer-mb EXPR)
  #'(#%module-begin
     (for-each displayln (reverse (flatten EXPR)))))
(provide (rename-out [stackerizer-mb #%module-begin]))

#|
to make a syn­tax object within the cur­rent lex­i­cal con­text, we use the #' pre­fix

(define-macro-cases +
  [(+ FIRST) #'FIRST]
  [(+ FIRST NEXT ...) #'(list '+ FIRST (+ NEXT ...))]) ; this plus is recursion

(define-macro-cases *
  [(+ FIRST) #'FIRST]
  [(+ FIRST NEXT ...) #'(list '* FIRST (* NEXT ...))])



(define-macro (define-op OP)
  #'(define-macro-cases OP
      [(OP FIRST) #'FIRST]
      [(OP FIRST NEXT (... ...))
       #'(list 'OP FIRST (OP NEXT (... ...)))]))

(define-op +)
(define-op *)
|#
(define-macro (define-ops OP ...) ; variadic args for operations
  #'(begin ; group multiple expressions into one
      (define-macro-cases OP
        [(OP FIRST) #'FIRST]
        [(OP FIRST NEXT (... ...))
         #'(list 'OP FIRST (OP NEXT (... ...)))])
      ...)) ;; applies the macro code again to the rest of the 

(define-ops + *)


(define-macro (lister ARG ...)
  #'(list ARG ...))

(lister "foo" "bar" "baz") ; '("foo" "bar" "baz")

(define-macro (wrap ARG ...)
  #'(list '(ARG 42) ...))

(wrap "foo" "bar" "baz") ; '(("foo" 42) ("bar" 42) ("baz" 42))

(define-macro (wrap2 ARG ...)
  #'(list '(ARG 42 ARG) ...))

(wrap2 "foo" "bar" "baz") ; '(("foo" 42 "foo") ("bar" 42 "bar") ("baz" 42 "baz"))