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
PUSH WORD [ESP+2]
CALL STRLEN
ADD SP, 2
PUSH CX
PUSH DX
PUSH BX
PUSH SI
MOVZX CX, AL
MOV DX, CX
MOV BX, [ESP+0Ah]
MOV SI, [ESP+0Ch]
strstr_mlp:
	LODSB
	TEST AL, AL
	JZ strstr_retml
	MOV BX, [ESP+0Ah]
	ADD BX, DX ;//strin+(strlen(strin) - cx)
	SUB BX, CX
	MOV AH, [BX]
	CMP AH, AL
	JNE strstr_strinelse
		CMP CX, 1
		JNE strstr_cxdel
			SUB SI, DX
			MOV AX, SI
			POP SI
			POP BX
			POP DX
			POP CX
			RET
		strstr_cxdel:
		DEC CX
		JMP strstr_mlp
	strstr_strinelse:
	MOV CX, DX
	MOV AX, 0xFFFF
	JMP strstr_mlp
RET
strstr_retml:
MOV AX, 0xFFFF
POP SI
POP BX
POP DX
POP CX
RET

;1 buffer
;2 const
;3 sizeof
strcmp_n:
MOV AH, 1
PUSH SI
PUSH BX
PUSH CX
MOV SI, [ESP+0xC]
MOV BX, [ESP+0xA]
MOV CX, [ESP+8]
strcmp_n_loop:
	;REPNE
	TEST CX, CX
	JZ strcmp_n_ret
	LODSB
	CMP [BX], AL
	JNE strcmp_n_err
	INC BX
	DEC CX
	JMP strcmp_n_loop
	strcmp_n_err:
	MOV AH, 0
	JMP strcmp_n_ret
strcmp_n_ret: ;AX holds return value
POP CX
POP BX
POP SI
MOVZX AX, AH
RET
