text_linebreak db 0Dh, 0Ah, 00

printtext:
	PUSH AX
	XOR AX, AX
	MOV ES, AX
	POP AX
	PUSH BX
.loop:
	LODSB 		
	TEST AL, AL
	jz .ex		
	MOV AH, 0Eh
	MOV BH, 0
	MOV BL, BYTE [0x500]
	int 10h		
	jmp .loop
.ex:
	POP BX
	ret

SetCursor:
	MOV AH, 02
	XOR BH, BH
	MOV DH, [ESP+4]
	MOV DL, [ESP+2]
	INT 0x10
	RET

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




;1st string pointer
;2nd string pointer
STRCMP:
	MOV AX, 1
	;test if they have the same length
	PUSH WORD [ESP+2]
	CALL STRLEN
	MOV [0x600], BYTE AL
	PUSH WORD [ESP+4]
	CALL STRLEN
	ADD SP, 4
	CMP [0x600], AL
	JE strcmp_testok
	XOR AX, AX
	
	strcmp_testok:
	PUSH BX
	PUSH CX
	XOR BX, BX	
	XOR CX, CX
	strcmp_charcomp:
	MOV BX, [ESP+8]
	ADD BX, CX
	MOV AH, [BX]
	TEST AH, AH
	JZ strcmp_done
	MOV [0x6000], AH
	MOV BX, [ESP+6]
	ADD BX, CX
	INC CX
	MOV AH, [BX]
	CMP [0x6000], AH
	JE strcmp_charcomp
	MOV AX, 0
	JMP strcmp_done

	strcmp_done:
	POP BX
	POP CX

	RET

;string pointer; clears buffer
STRCLR:
	PUSH AX ;store
	PUSH CX ;store
	MOV DI, [ESP+0x08] ;buffer
	MOV CX, [ESP+6] ;count
	MOV AX, ES
	PUSH AX
	XOR AX, AX
	MOV ES, AX
	REP STOSB
	POP AX
	MOV ES, AX
	POP CX
	POP AX
	RET
	
STRCPY:
	PUSH CX
	MOV SI, [ESP+8]
	MOV DI, [ESP+6]
	MOV CX, [ESP+4]
	REP MOVSB
	POP CX
	RET
		
	
	


;string pointer
STRLEN:
	PUSH BX ; store
	MOV AX, 0	
	MOV BX, WORD [ESP+4] ;Get pointer
	strlen_loop:
		MOV AH, [BX]
		TEST AH, AH
		JZ strlen_done
		INC BX
		INC AX
		JMP strlen_loop
	strlen_done:
	POP BX ; restore BX
	AND AX, 0xFF
	RET
		

FormatNumber:
	MOV BX, [ESP+2] ;if available
	MOV CX, AX
	SHR AX, 12
	CALL FNcomparable
	MOV BYTE [BX+4], AH
	MOV AX, CX
	SHR AX, 8
	CALL FNcomparable
	MOV BYTE [BX+5], AH
	MOV AX, CX
	SHR AX, 4
	CALL FNcomparable
	MOV BYTE [BX+6], AH
	MOV AX, CX
	CALL FNcomparable
	MOV BYTE [BX+7], AH
	
	RET

	FNcomparable:
	MOV AH, AL
	AND AH, 0Fh
	CMP AH, 9
	JA FNAbove
	CALL AddNormal
	RET
	FNAbove:
	CALL AddHexed
	RET
		
	AddNormal:
	ADD AH, '0'
	RET
	AddHexed:
	SUB AH, 0Ah
	ADD AH, 'A'
	RET



	text_stringAX db 'AX: 0000',0
	text_buffer db 0,0,0,0,0,0,0,0
