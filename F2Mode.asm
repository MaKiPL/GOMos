f2_curAdr: dw 0x7c00
f2_cursorAdr: dw 0x0000
sF2lineNumber: db "0000: ", 0
f2_inputSafevar: dw 0x0000


;kernel gives AH/AL
F2Input:
MOV [f2_inputSafevar], AX
CMP AH, 0x4B
JE F2_left
CMP AH, 0x4D
JE F2_right
CMP AH, 0x48
JE F2_up
CMP AH, 0x50
JE F2_down
CMP AH, 0x51
JE F2_scrollDown
CMP AH, 0x49
JE F2_scrollUp
RET

F2_left:
MOV AX, [f2_cursorAdr]
TEST AH, AH
JNZ $+1
RET
DEC AH
MOV [f2_cursorAdr], AX
RET

F2_right:
MOV AX, [f2_cursorAdr]
CMP AH, 31
JNE $+1
RET
INC AH
MOV [f2_cursorAdr], AX
RET

F2_up:
MOV AX, [f2_cursorAdr]
TEST AL, AL
JNZ $+1
RET
DEC AL
MOV [f2_cursorAdr], AX
RET

F2_down:
MOV AX, [f2_cursorAdr]
CMP AL, 15
JNE $+1
RET
INC AL
MOV [f2_cursorAdr], AX
RET

F2_scrollDown:
MOV AX, [f2_curAdr]
CMP AX, 0xFF00
JNE $+1
RET
ADD AX, 0x100
MOV [f2_curAdr], AX
RET

F2_scrollUp:
MOV AX, [f2_curAdr]
TEST AX, AX
JNZ $+1
RET
SUB AX, 0x100
MOV [f2_curAdr], AX
RET

Kernel_F2:
PUSH 00
PUSH 00
PUSH 00
PUSH 320
PUSH 200
CALL DrawRectangle
ADD SP, 0x0A

MOV [0x500], BYTE 0x0F ;white
MOV [0x600], BYTE 0xFF ;hex columns, -1 because
f2_drawIndex:
MOVZX CX, BYTE [0x600]
MOV [0x603], BYTE 0
CMP CL, 15
JE f2_indexWritten
INC CL
MOV [0x600], CL
PUSH CX
PUSH 0 ;row?
CALL SetCursor
ADD SP, 2
POP CX


;;==draw hex address
MOV AX, [f2_curAdr]
;MUL BX ; no, it's 16 so this could be easily optimized by SHL
MOVZX DX, CL
SHL DX, 4
ADD AX, DX
MOV BX, sF2lineNumber
SUB BX, 4
PUSH BX
CALL FormatNumber
ADD SP, 2

MOV SI, sF2lineNumber
CALL printtext

;;==draw hex dump 16 chars
MOVZX AX, [0x600]
SHL AX, 4

MOV BX, [f2_curAdr]
ADD BX, AX
MOV [0x601], BX 

printhex:
MOVZX CX, BYTE [0x603]
CMP CL, 8
JE f2_drawIndex
SHL CX, 1
ADD BX, CX
MOV AX, [BX]
MOV CL, [0x603]
INC CL
MOV [0x603], CL

PUSH text_buffer-4
XCHG AH, AL
CALL FormatNumber
ADD SP, 2
MOV SI, text_buffer
CALL printtext
MOV BX, WORD [0x601]
JMP printhex

f2_indexWritten:
MOV AX, [f2_cursorAdr] ;AH= column AL= row
ADD AH, 6 ;because of '0000: '
PUSH AX
SHR AX, 8
PUSH AX
CALL SetCursor
ADD SP, 4

MOV AH, 0x08
XOR BH, BH
INT 0x10

MOV AH, 0x0E
MOV BL, 0x05
INT 0x10



RET
