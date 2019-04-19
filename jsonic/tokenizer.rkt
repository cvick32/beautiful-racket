#lang br/quicklang
(require brag/support racket/contract)

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

; function to check if the output of make-tokenizer is valid
(define (jsonic-token? x)
  (or (eof-object? x)
      (string? x)
      (token-struct? x)))

(provide (contract-out
          [make-tokenizer (input-port? . -> . (-> jsonic-token?))]))