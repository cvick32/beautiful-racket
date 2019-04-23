#lang br
(require racket/draw)

#|
each button contains:
1) string representing the button label shown in the toolbar
2) 16px bitmap for the icon
3) function to call on press, 1 param the reference to the editor window
4) number that determines ordering, or #f
|#

#|
drr-window is an instance of frame%
|#
(define (insert-expr drr-window)
  (define expr-string "@$  $@")
  (define editor (send drr-window get-definitions-text))
  (send editor insert expr-string)
  (define pos (send editor get-start-position))
  (send editor set-position (- pos 3)))

(define our-jsonic-button
  (list
   "Insert expression"
   (make-object bitmap% 16 16) ; 16x16 white square
   insert-expr
   #f))

(provide button-list)
(define button-list (list our-jsonic-button))
