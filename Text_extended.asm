chrtoup: ;tested, works
CMP AL, 0x61 ; A
JB strtoup_err
CMP AL, 0x7A
JA strtoup_err
SUB AL, 0x20
strtoup_err:
RET

strtoup: ;tested, works
MOV SI, [ESP+2]
strtoup_loop:
LODSB
TEST AL, AL
JZ strtoup_end
CALL chrtoup
MOV [SI-1], AL
JMP strtoup_loop
strtoup_end:
RET

strin:
MOV DI, [ESP+4]
MOV AX, [ESP+2]
AND AX, 0xF
REPNE SCASB
MOV AX, DI
RET

STRCAT: ;concat
RET

STRSTR: ;locate substr
RET
PUSH SI
PUSH BX
PUSH AX
XOR AX,AX
MOV SI, [ESP+0A]
MOV BX, [ESP+8]
strstr_loop:
LODSB
CMP [BX], AL
INC BX
JE strstr_innerloop:
	MOV AX, SI
;TODO	
	


POP AX
POP BX
POP SI
RET
