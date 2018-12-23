	BITS 16
	org 07c00h

start:
	;sets stack
	mov ax, 07C00h
	SUB AX, 4096		
	mov sp, AX

	
	;sets graphic mode
	MOV AH, 00h
	MOV AL, 13h
	INT 10h

	
	MOV ax, 0A000h
	MOV ES, AX ;I can't adress 0x000A 0000 in 16 bit, so I'm using STOSB for ES:DI, because 16*A000 is 0xA0000
	MOV DI, 0 ;ES:DI
	MOV AL, 04h
	
	loopTest:
	STOSB
	CMP DI, 0FA00h
	JE loop_2
	JMP loopTest
	
	loop_2:
	PUSH AX
	MOV AH, 10h
	INT 16h
	CMP AH, 3Bh
	JE loop_
	POP AX
	INC AL
	MOV DI, 0
	JMP loopTest

	loop_:
	MOV AH, 10h
	INT 16h

	;Type your key combinations
	CMP AH, 3Bh
	JE OutputReg

	JMP writeChar
	
	OutputReg:
	CALL OutputAllRegisters
	JMP loop_

	
	
	writeChar:
	MOV AH, 0Eh
	XOR BH, BH
	MOV BL, 2 
	INT 10h
	

	JMP loop_
	hlt

		
%include "GOM_Text.asm"
	
	
	times 510-($-$$) db 0	
	dw 0xAA55		
