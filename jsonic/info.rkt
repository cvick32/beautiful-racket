#lang info
(define collection "jsonic")
(define version "1.0")
(define scribblings '(("scribblings/jsonic.scrbl")))
(define test-omit-paths '("full-jsonic-test.rkt" "test.rkt")) ; clean output for "~/jsonic raco test -p jsonic
(define deps '("base"
               "beautiful-racket-lib"
               "brag"
               "draw-lib"
               "gui-lib"
               "rackunit-lib"
               "syntax-color-lib"))
(define build-deps '("racket-doc"
                     "scribble-lib"))
