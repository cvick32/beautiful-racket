#lang br/quicklang

#|
handle function in stacker relied on a state variable 'stack'
mutation of state variable
both of these are bad practice in racket
|#

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module funstacker-mod "funstacker.rkt"
                          (handle-args ,@src-datums)))
  (datum->syntax #f module-datum)) 

(provide read-syntax)

(define-macro (funstacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [funstacker-module-begin #%module-begin]))

#|
the dot in front of args means it's a rest argument
  it captures the 'rest' of the variables passed to function.
  for variadic functions

explanation of using in-list:
The sequence con­struc­tor in-list. Any sequence can be used directly as a
source of iter­a­tor val­ues, includ­ing any list (because every list is a sequence).
But in-list is a hint to the com­piler that helps it gen­er­ate more effi­cient code.
In a list of 10 ele­ments, it won’t add any prac­ti­cal value. But when you know for
sure what type of sequence will be iter­ated, using the sequence con­struc­tor is a vir­tu­ous habit.
|#
(define (handle-args . args)
  (for/fold ([stack-acc empty])
            ([arg (in-list args)]
             #:unless (void? arg))
    (cond
      [(number? arg) (cons arg stack-acc)]
      [(or (equal? * arg) (equal? + arg))
       (define op-result
         (arg (first stack-acc) (second stack-acc)))
       (cons op-result (drop stack-acc 2))])))

(provide handle-args)

(provide * +)