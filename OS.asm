	BITS 16
	org 07c00h

start:
	mov ax, 07C00h
	SUB AX, 4096		
	mov sp, AX
	




	MOV AH, 0Fh
	INT 10h
	CALL OutputAllRegisters

	MOV AH, 03h
	INT 10h
	
	CALL OutputAllRegisters

	gettInput: 
	jmp gettInput

		
%include "GOM_Text.asm"

	times 510-($-$$) db 0	
	dw 0xAA55		
