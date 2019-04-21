#lang br
(require brag/support syntax-color/racket-lexer racket/contract)
#|
Goals for the colorer
1) each line comment will be colored as a 'comment
2) each expression delimiter, @$ or $@, will be colored as a 'parenthesis
    the shape of the delimiter will be () so that DrRacket treats them as a matched pair
3) Rack code in between delimiters will be treated as racket code
4) everything else is colored by 'string
|#

(define jsonic-lexer
  (lexer
   [(eof) (values lexeme 'eof #f #f #f)]
   [(:or "@$" "$@")
    (values lexeme 'parenthesis
            (if (equal? lexeme "@$") '|(| '|)|)
            (pos lexeme-start) (pos lexeme-end))]
   [(from/to "//" "\n")
    (values lexeme 'comment #f
            (pos lexeme-start) (pos lexeme-end))]
   [any-char
    (values lexeme 'string #f
            (pos lexeme-start) (pos lexeme-end))]))
   

(define (color-jsonic port offset racket-coloring-mode?)
  (cond
    [(or (not racket-coloring-mode?)
         (equal? (peek-string 2 0 port) "$@"))
     (define-values (str cat paren start end)
       (jsonic-lexer port))
     (define switch-to-racket-mode (equal? str "@$"))
     (values str cat paren start end 0 switch-to-racket-mode)]
    [else
     (define-values (str cat paren start end)
       (racket-lexer port))
     (values str cat paren start end 0 #t)]))

(module+ test
  (require rackunit)
  (check-equal? (values->list
                 (color-jsonic (open-input-string "x") 0 #f))
                (list "x" 'string #f 1 2 0 #f)))

(provide (contract-out
          [color-jsonic
           (input-port? exact-nonnegative-integer? boolean?
             . -> .
             (values
              (or/c string? eof-object?)
              symbol?
              (or/c symbol? #f)
              (or/c exact-positive-integer? #f)
              (or/c exact-positive-integer? #f)
              exact-nonnegative-integer?
              boolean?))]))
















