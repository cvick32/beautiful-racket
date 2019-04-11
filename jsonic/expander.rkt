#lang br/quicklang
(require json)

(define-macro (jsonic-mb PARSE-TREE)
  #'(#%module-begin
     (define result-string PARSE-TREE)
     (define validated-jsexpr (string->jsexpr result-string))
     (display result-string)))
(provide (rename-out [jsonic-mb #%module-begin]))

; this will match any number of items that is either a jsonic-sexp or a jsonic-char
;  each of those will emit code that produces a string, so we append them together
(define-macro (jsonic-program SEXP-OR-JSON-STR ...)
  #'(string-trim (string-append SEXP-OR-JSON-STR ...)))
(provide jsonic-program)

(define-macro (jsonic-char CHAR-TOK-VALUE)
  #'CHAR-TOK-VALUE)
(provide jsonic-char)

; input is a SEXP-TOK, which represents a Racket expression
(define-macro (jsonic-sexp SEXP-STR)
  (with-pattern ([SEXP-DATUM (format-datum '~a #'SEXP-STR)])
    #'(jsexpr->string SEXP-DATUM)))
(provide jsonic-sexp)