#lang br/quicklang
#|
Each produc­tion rule in the grammar will have a corre­sponding macro or func­tion in the expander.
The name (on the left side) of each produc­tion rule is the name of the corre­sponding macro or func­tion.
The pattern (on the right side) of each produc­tion rule describes the possible input to its corre­sponding macro or func­tion.
Going to implement an imperative then a functional version
|#

; Begin imperative
; each syntax rule from the grammar will get a macro
#|
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
|#

; begin functional expander

(define-macro (bf-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [bf-module-begin #%module-begin]))

; apl is a list of a bf array and a pointer, return val of bf func
; list of bf-funcs
(define (fold-funcs apl bf-funcs)
  (for/fold ([current-apl apl])
            ([bf-func (in-list bf-funcs)])
    (apply bf-func current-apl)))

(define-macro (bf-program OP-OR-LOOP-ARG ...)
  #'(begin
      (define first-apl (list (make-vector 30000 0) 0))
      (void (fold-funcs first-apl (list OP-OR-LOOP-ARG ...)))))
(provide bf-program)

(define-macro (bf-loop "[" OP-OR-LOOP-ARG ... "]")
  #'(lambda (arr ptr)
      (for/fold ([current-apl (list arr ptr)])
                ([i (in-naturals)]
                 #:break (zero? (apply current-byte
                                       current-apl)))
        (fold-funcs current-apl (list OP-OR-LOOP-ARG ...)))))
(provide bf-loop)

(define-macro-cases bf-op
  [(bf-op ">") #'gt]
  [(bf-op "<") #'lt]
  [(bf-op "+") #'plus]
  [(bf-op "-") #'minus]
  [(bf-op ".") #'period]
  [(bf-op ",") #'comma])
(provide bf-op)

(define (current-byte arr ptr) (vector-ref arr ptr))


(define (set-current-byte arr ptr val)
  (vector-set! arr ptr val)
  arr)

(define (gt arr ptr) (list arr (add1 ptr)))
(define (lt arr ptr) (list arr (sub1 ptr)))

(define (plus arr ptr) (list (set-current-byte arr ptr (add1 (current-byte arr ptr)))))
(define (minus arr ptr) (list (set-current-byte arr ptr (sub1 (current-byte arr ptr)))))

(define (period arr ptr)
  (write-byte (current-byte arr ptr))
  (list arr ptr))
(define (comma arr ptr) (list (set-current-byte arr ptr (read-byte)) ptr))












