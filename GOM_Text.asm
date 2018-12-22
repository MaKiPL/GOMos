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

FormatAndDisplayAh:
	CALL FormatNumber
	CALL DisplayAh
	RET

FormatNumber:  ;Co zrobic jak jest wyzej niz 0x09? CMP? StaticCast?
	MOV CH, AH
	SHR CH, 4
	AND CH, 0x0F
	AND AH, 0x0F

	AddNormal:
	ADD CH, '0'
	ADD AH, '0'
	MOV BYTE [text_buffer], CH
	MOV BYTE [text_buffer+1], AH
	XOR AH, AH
	XOR CH, CH
	ret

DisplayAh:
	MOV SI, text_stringAH
	call printtext
	MOV SI, text_stringEq
	call printtext
	MOV SI, text_buffer
	call printtext
	MOV SI, text_linebreak
	call printtext
	RET	
