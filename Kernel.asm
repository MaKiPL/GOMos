BITS 16

MOV SI, myStr
CALL printtext
JMP $

myStr: db "Kernel loaded succesfully!"
