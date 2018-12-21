	BITS 16

start:
	mov ax, 07C0h		
	add ax, 288		
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		
	mov ds, ax
	




	MOV AH, 0Fh
	INT 10h

	CALL FormatAndDisplayAh

	MOV AH, AL
	CALL FormatAndDisplayAh
	
	MOV AH, BH
	CALL FormatAndDisplayAh

	MOV AH, 03h
	INT 10h
	
	MOV AH, DH
	CALL FormatAndDisplayAh

	MOV AH, DL
	CALL FormatAndDisplayAh
	
	gettInput: 
	jmp gettInput

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
		
%include "GOM_Text.asm"

	text_stringEq db ' = ',0
	text_stringAH db 'AH',0
	text_stringAL db 'AL', 0
	text_StringBH db 'BH',0
	text_buffer db 0,0,0,0,0,0,0,0
	text_linebreak db 0Dh, 0Ah

	times 510-($-$$) db 0	
	dw 0xAA55		
