#lang br/quicklang

#|
42

(list)
4 => (list 4)
8 => (list 8 4)
+ => (list + 8 4)
3 => (list 3 12)
* => (list * 3 12)
36

every program specifies a reader and an expander
reader converts source code of our language from a string
  of chars into Racket-style forms, or S-expressions

Every read-syntax has one job: to return code describ­ing a
 mod­ule, pack­aged as a syn­tax object. Racket will replace
 the source code with this mod­ule code. This mod­ule, in turn,
 will invoke the expander for our lan­guage, trig­ger­ing the full
 expan­sion and eval­u­a­tion of the source code.

(module module-name which-expander
   42 ; the body of the module
   "foobar" ; contains expressions
   (+ 1 1) ; to expand & evaluate
   ···)
module-name doesn't affect functionality
(module lucy "path/to/expander.rkt"
  42)

first arg of datum->syntax is program context

,@ is the unquote splicing operator, works with `, quasiquote to
  splice in a var list into a quoted list
if you use "," with var list you'll get a nested sublist

'((handle 42) (handle +) (handle 25))
=> 
'(module stacker-mod br
  (handle 42)
  (handle +)
  (handle 25))
|#

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '(handle ~a) src-lines))
  (define module-datum `(module stacker-mod "stacker.rkt"
                          ,@src-datums))
  (datum->syntax #f module-datum)) 

(provide read-syntax)


#|
Within the expander, we have three basic tech­niques for adding bind­ings to code:
We can define macros that rewrite cer­tain code as other code at com­pile time (for instance, and).
We can define func­tions that are invoked at run time.
We can import bind­ings from exist­ing Racket mod­ules, which can include both macros and func­tions.
Every expander must export a #%module-begin macro

But the #' pre­fix not only cre­ates the datum, but also cap­tures the cur­rent lex­i­cal con­text,
  and attaches that to the new syn­tax object.

1) Pro­vide the spe­cial #%module-begin macro.
2) Imple­ment a stack, with an inter­face for stor­ing, read­ing, and doing oper­a­tions on argu­ments,
    that can be used by handle.
3) Pro­vide bind­ings for three iden­ti­fiers: handle, which deter­mines what to do with each argu­ment;
    +, a stack oper­a­tor; and *, another stack oper­a­tor.
|#

(define-macro (stacker-module-begin HANDLE-EXPR ...)
  #'(#%module-begin
     HANDLE-EXPR ...
     (display (first stack))))
(provide (rename-out [stacker-module-begin #%module-begin]))

(define stack '())

(define (pop-stack!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (push-stack! arg)
  (set! stack (cons arg stack)))

(define (handle [arg #f])
  (cond
    [(number? arg) (push-stack! arg)]
    [(or (equal? + arg) (equal? * arg))
     (define op-result (arg (pop-stack!) (pop-stack!)))
     (push-stack! op-result)]))

(provide handle)

(provide * +)







