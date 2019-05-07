#lang br
(provide b-expr b-sum b-product b-neg b-expt)

(define (b-expr expr)
  (if (integer? expr) (inexact->exact expr) expr))

(define-cases b-sum
  [(_ arg) arg]
  [(_ left op right) ((case op
                        [("+") +]
                        [("-") -]) left right)])

(define-cases b-product
  [(_ arg) arg]
  [(_ left op right) ((case op
                        [("*") *]
                        [("/") (λ (l r) (/ l r 1.0))]
                        [("mod") modulo]) left right)])

(define-cases b-neg
  [(_ val) val]
  [(_ _ val) (- val)])

(define-cases b-expt
  [(_ val) val]
  [(_ left _ right) (expt left right)])