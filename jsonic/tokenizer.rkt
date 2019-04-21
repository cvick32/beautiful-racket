#lang br/quicklang
(require brag/support racket/contract)

(module+ test
  (require rackunit))

(define (make-tokenizer port)
  (define (next-token)
    (define jsonic-lexer
      (lexer
       [(from/to "//" "\n") (next-token)]
       [(from/to "@$" "$@")
        (token 'SEXP-TOK (trim-ends "@$" lexeme "$@"))]
       [any-char (token 'CHAR-TOK lexeme)]))
    (jsonic-lexer port)) 
  next-token)

(module+ test
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "// comment\n")
   empty)
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "@$ (+ 6 7) $@")
   (list (token-struct 'SEXP-TOK " (+ 6 7) " #f #f #f #f #f)))
  (check-equal?
   (apply-tokenizer-maker make-tokenizer "hi")
   (list (token-struct 'CHAR-TOK "h" #f #f #f #f #f)
         (token-struct 'CHAR-TOK "i" #f #f #f #f #f))))

; function to check if the output of make-tokenizer is valid
(define (jsonic-token? x)
  (or (eof-object? x)
      (string? x)
      (token-struct? x)))

(module+ test
  (check-true (jsonic-token? eof))
  (check-true (jsonic-token? "a string"))
  (check-true (jsonic-token? (token 'A-TOKEN-STRUCT "hi")))
  (check-false (jsonic-token? 42)))

(provide (contract-out
          [make-tokenizer (input-port? . -> . (-> jsonic-token?))]))