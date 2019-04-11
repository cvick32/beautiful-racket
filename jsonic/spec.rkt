#lang racket
#|
rules:
1) every jsonic program produces valid json:
  we need to be able to check that the output is valid json (agaisnt JSON spec)
2) every json file is a valid jsonic program
  jsonic parser needs to process json files
3) racket expressions can be embedded anywhere within a jsonic program that a json value could appear
  need a way of delimiting racket exprs in json. we'll use @$ <racket> $@
  that racket code that's executed must return 'null, numbers, strings, lists, or hash tables to map onto
  the JSON data types
4) anything after // is a comment


|#