#lang racket

(module our-submod br
  (require racket/contract)
  
  (module+ test
    (require rackunit))

  (define (our-div num denom)
    (/ num denom))

  (module+ test
    (check-equal? (our-div 42 6) 7)
    (check-equal? (our-div 42 2) 21)
    (check-exn exn:fail? (lambda () (our-div 42 0))))

  (define (our-mult f1 f2)
    (* f1 f2))

  (module+ test
    (check-equal? (our-mult 6 7) 42)
    (check-exn exn:fail? (lambda () (our-mult "a" "b"))))
  
  (provide (contract-out
            [our-div (number? (not/c zero?) . -> . number?)]))) ; periods are to allow infix notation

(require (submod "." our-submod))

; (our-div 4 0)