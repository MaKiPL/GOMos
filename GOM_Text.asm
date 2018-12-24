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
	MOV BL, 5
	int 10h		
	jmp .loop
.ex:
	POP BX
	ret

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
	CALL FormatNumber
	CALL DisplayAh
	RET

FormatNumber:
	MOV BX, AX
	SHR AX, 12
	CALL FNcomparable
	MOV BYTE [text_stringAX+5], AH
	MOV AX, BX
	SHR AX, 8
	CALL FNcomparable
	MOV BYTE [text_stringAX+6], AH
	MOV AX, BX
	SHR AX, 4
	CALL FNcomparable
	MOV BYTE [text_stringAX+7], AH
	MOV AX, BX
	CALL FNcomparable
	MOV BYTE [text_stringAX+8], AH
	
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


	text_stringAX db 'AX = 0000',0
	text_buffer db 0,0,0,0,0,0,0,0
