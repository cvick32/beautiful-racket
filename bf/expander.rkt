#lang br/quicklang
#|
Each produc­tion rule in the grammar will have a corre­sponding macro or func­tion in the expander.
The name (on the left side) of each produc­tion rule is the name of the corre­sponding macro or func­tion.
The pattern (on the right side) of each produc­tion rule describes the possible input to its corre­sponding macro or func­tion.
Going to implement an imperative then a functional version
|#

(define-macro (bf-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [bf-module-begin #%module-begin]))

; Begin imperative
; each syntax rule from the grammar will get a macro

; bf-program : (bf-op | bf-loop)* 
(define-macro (bf-program OP-OR-LOOP-ARG ...)
  #'(void OP-OR-LOOP-ARG ...))
(provide bf-program)

; bf-loop : "[" (bf-op | bf-loop)* "]"
(define-macro (bf-loop "[" OP-OR-LOOP-ARG ... "]")
  #'(until (zero? (current-byte))
      OP-OR-LOOP-ARG ...))
(provide bf-loop)

; define the initial block of memory and the pointer to the first byte
(define arr (make-vector 30000 0))
(define ptr 0)

(define (current-byte) (vector-ref arr ptr))
(define (set-current-byte! val) (vector-set! arr ptr val))

; bf-op : ">" | "<" | "+" | "-" | "." | ","
(define-macro-cases bf-op
  [(bf-op ">") #'(gt)]
  [(bf-op "<") #'(lt)]
  [(bf-op "+") #'(plus)]
  [(bf-op "-") #'(minus)]
  [(bf-op ".") #'(period)]
  [(bf-op ",") #'(comma)])
(provide bf-op)

(define (gt) (set! ptr (add1 ptr)))
(define (lt) (set! ptr (sub1 ptr)))
(define (plus) (set-current-byte! (add1 (current-byte))))
(define (minus) (set-current-byte! (sub1 (current-byte))))
(define (period) (write-byte (current-byte)))
(define (comma) (set-current-byte! (read-byte)))
