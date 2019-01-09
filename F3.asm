;it starts directly
JMP _f3s
sampleTest: db "Lorem ipsum DolOr Sit Amet", 0
testText: db "Lorez", 0
f3buffer: db "0x0000", 0

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
PUSH testText
PUSH 5
CALL strcmp_n
ADD SP, 6
PUSH WORD f3buffer-2
CALL FormatNumber
ADD SP, 2
MOV SI, f3buffer
CALL printtext
RET

F3_in:
RET
