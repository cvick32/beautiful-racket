#lang reader "reader.rkt"
#|
first string is 11 increments and 3 decrements = 8
of the current byte
[] is the loop construct
> moves the pointer to the next byte, same pattern so this byte is 8 as well
< moves the pointer back to the first byte and decrement
loop again because the first pointer isnt 0, so we do this until first byte is 0 so 8 times
break out of loop
> move pointer to second byte
. print out
second byte is 64 and the char that 64 represents is @
|#

>++++++++++>>>+>+[>>>+[-[<<<<<[+<<<<<]>>[[-]>[<<+>+>-]
<[>+<-]<[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-[>+<-
[>[-]>>>>+>+<<<<<<-[>+<-]]]]]]]]]]]>[<+>-]+>>>>>]<<<<<
[<<<<<]>>>>>>>[>>>>>]++[-<<<<<]>>>>>>-]+>>>>>]<[>++<-]
<<<<[<[>+<-]<<<<]>>[->[-]++++++[<++++++++>-]>>>>]<<<<<
[<[>+>+<<-]>.<<<<<]>.>>>>]


