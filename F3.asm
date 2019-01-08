;it starts directly
JMP _f3s
sampleTest: db "Lorem ipsum DolOr Sit Amet", 0

_f3s:
PUSH 0
PUSH 0
PUSH 0
PUSH 320
PUSH 200
CALL DrawRectangle
ADD SP, 0xA

PUSH 0
PUSH 0
CALL SetCursor
ADD SP, 4

PUSH sampleTest
CALL strtoup
ADD SP, 2
MOV SI, sampleTest
CALL printtext
RET

F3_in:
RET
