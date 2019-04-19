#lang racket

(module our-submod br
  (require racket/contract)
  (define (our-div num denom)
    (/ num denom))
  (provide (contract-out
            [our-div (number? (not/c zero?) . -> . number?)]))) ; periods are to allow infix notation

(require (submod "." our-submod))
(our-div 4 0)