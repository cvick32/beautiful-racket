#lang jsonic

{
  "value": 42,
  "string":
  [
    {
      "array": @$(range 5)$@,
      "object": @$(hash 'k1 "valstring")$@
    }
  ]
  // "bar"
}

@$ (+ 4 5) $@