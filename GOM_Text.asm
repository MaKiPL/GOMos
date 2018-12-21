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
