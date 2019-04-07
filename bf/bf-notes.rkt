#lang racket
#|
grammar is a way of notating structure for every possible program in a language
grammar is used to generate a parser

zip-code grammar:
zip-code : digit digit digit digit digit
digit    : "0" | "1" | "2" | "3" | "4"
         | "5" | "6" | "7" | "8" | "9"

these are productions rules
they are written one line at a time, colon goes in the middle of the rule
left side is the name, right is the pattern for the element

parser reads in source codes and recursively searches the grammar for matching the input
recursively searches until it finds terminals (0 through 9 above are terminals)
parser returns a parse tree describing the structure

(parse "123ABC") => failure
(parse "123") => failure
(parse "01234") => '(zip-code
                      (digit "0")
                      (digit "1")
                      (digit "2")
                      (digit "3")
                      (digit "4"))

infinite set of grammars to describe a language
zip-code   : digit-pair digit digit-pair
digit-pair : digit digit
digit      : odd-digit | even-digit
odd-digit  : "1" | "3" | "5" | "7" | "9"
even-digit : "0" | "2" | "4" | "6" | "8"
(parse2 "01234") => '(zip-code
  (digit-pair (digit (even-digit "0"))
              (digit (odd-digit "1")))
  (digit (even-digit "2"))
  (digit-pair (digit (odd-digit "3"))
              (digit (even-digit "4"))))

* quantifier means 0 or more of the preceding item
+ quantifier means 1 or more of the preceding item
stacker      : "\n"* instruction ("\n"+ instruction)*
instruction  : integer | func
integer      : ["-"] digit+
digit        : "0" | "1" | "2" | "3" | "4"
             | "5" | "6" | "7" | "8" | "9"
func         : "+" | "*"

(parse
  4
  8
  +
  3
  *)
=>

'(stacker-program
  (instruction (integer (digit "4")))
  "\n"
  (instruction (integer (digit "8")))
  "\n"
  (instruction (func "+"))
  "\n"
  (instruction (integer (digit "3")))
  "\n"
  (instruction (func "*")))
'(stacker-program
  (instruction (integer (digit "4")))
  "\n"
  (instruction (integer (digit "8")))
  "\n"
  (instruction (func "+"))
  "\n"
  (instruction (integer (digit "3")))
  "\n"
  (instruction (func "*")))

Recursive grammars:
m-expressions

(+ 1 (* 2 (+ 3 4) 5) 6)

m-expr  : m-list | integer
m-list  : "(" func ( " " + m-expr )* ")"
integer : ["-"] digit+
digit   : "0" | "1" | "2" | "3" | "4"
        | "5" | "6" | "7" | "8" | "9"
func    : "+" | "*"

'(m-expr
  (m-list "(" (func "+")
   " " (m-expr (integer (digit "1")))
   " " (m-expr
    (m-list "(" (func "*")
     " " (m-expr (integer (digit "2")))
     " " (m-expr
          (m-list "(" (func "+")
           " " (m-expr (integer (digit "3")))
           " " (m-expr (integer (digit "4"))) ")"))
     " " (m-expr (integer (digit "5")))
     ")"))
   " " (m-expr (integer (digit "6")))
   ")"))
|#



















