text_linebreak db 0Dh, 0Ah, 00

printtext:
	mov ah, 0Eh
	XOR CX, CX

.loop:
	LEA BX, [si]
	ADD BX, CX
	MOV AL, [BX] 		
	cmp AL, 0
	je .ex		
	MOV AH, 0Eh
	int 10h		
	INC CX
	jmp .loop
.ex:
	ret

OutputAllRegisters:
	SUB SP, 8
	PUSH AX ; ESP 6
	PUSH BX ; ESP 4
	PUSH CX ; ESP 2
	PUSH DX ; ESP 0 RET
	CALL FormatAndDisplayAx
	
	
	

FormatAndDisplayAx:
	CALL FormatNumber
	CALL DisplayAh
	RET

FormatNumber:
	SUB SP, 2
	PUSH AX ;AH gets pushed+2
	SHR AH, 4
	CALL FNcomparable
	MOV BYTE [text_buffer], AH ;change it to AX support and change stringAX
	POP AX
	SUB SP, 2
	AND AH, 0Fh
	CALL FNcomparable
	MOV BYTE [text_buffer+1], AH
	JMP FNcopyBuffer

	FNcomparable:
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

	FNcopyBuffer:
	POP AX
	ADD SP, 2
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
