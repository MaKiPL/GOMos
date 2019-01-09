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


strin:
MOV DI, [ESP+4]
MOV AX, [ESP+2]
AND AX, 0xF
REPNE SCASB
MOV AX, DI
RET
