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

		
%include "GOM_Text.asm"

	text_stringEq db ' = ',0
	text_stringAH db 'AH',0
	text_stringAL db 'AL', 0
	text_StringBH db 'BH',0
	text_buffer db 0,0,0,0,0,0,0,0

	times 510-($-$$) db 0	
	dw 0xAA55		
