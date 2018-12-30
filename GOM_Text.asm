text_linebreak db 0Dh, 0Ah, 00

printtext:
	PUSH AX
	MOV AX, 0
	MOV ES, AX
	POP AX
	PUSH BX
.loop:
	LODSB 		
	cmp AL, 0
	je .ex		
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
		

OutputAllRegisters:
	PUSH AX ; ESP 6
	PUSH BX ; ESP 4
	PUSH CX ; ESP 2
	PUSH DX ; ESP 0 RET

	MOV [text_stringAX], BYTE 'A'
	CALL FormatAndDisplayAx

	ADD SP, 4
	POP AX
	SUB SP, 6
	MOV [text_stringAX], BYTE 'B'
	CALL FormatAndDisplayAx

	ADD SP, 2
	POP AX
	SUB SP, 4
	MOV [text_stringAX], BYTE 'C'
	CALL FormatAndDisplayAx

	POP AX
	SUB SP, 2
	MOV [text_stringAX], BYTE 'D'
	CALL FormatAndDisplayAx

	POP DX
	POP CX
	POP BX
	POP AX
	RET
	


FormatAndDisplayAx:
	PUSH text_stringAX
	CALL FormatNumber
	CALL DisplayAh
	ADD SP, 2
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

DisplayAh:
	MOV SI, text_stringAX
	call printtext
	MOV SI, text_buffer
	call printtext
	MOV SI, text_linebreak ;I should optimize it to use callable function for print line and casual print
	call printtext
	RET	


	text_stringAX db 'AX: 0000',0
	text_buffer db 0,0,0,0,0,0,0,0
