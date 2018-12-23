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

	;clear screen black
	MOV ax, 0A000h
	MOV ES, AX ;I can't adress 0x000A 0000 in 16 bit, so I'm using STOSB for ES:DI, because 16*A000 is 0xA0000
	MOV DI, 0 ;ES:DI
	MOV AL, 00h
	
	memsetScr:
	STOSB
	CMP DI, 0FA00h
	JE stage2
	JMP memsetScr
	
	stage2:
	MOV AH, 2
	MOV AL, 16 ;num of sec 512*16
	XOR CH, CH 
	MOV CL, 2 ;second sector
	XOR DH, DH
	MOV DL, 80h
	MOV BX, 0
	MOV ES, BX
	MOV BX, 7E00h
	INT 13h

	CALL OutputAllRegisters
	JMP BX

	;MOV AX, A000h
	;MOV ES, AX

	;loop_:
	;MOV AH, 10h
	;INT 16h

	;Type your key combinations
	;CMP AH, 3Bh
	;JE OutputReg

	;JMP writeChar
	
	;OutputReg:
	;CALL OutputAllRegisters
	;JMP loop_

	
	
	;writeChar:
	;MOV AH, 0Eh
	;XOR BH, BH
	;MOV BL, 2 
	;INT 10h
	

	;JMP loop_
	;hlt

		
%include "GOM_Text.asm"
	
	
	times 510-($-$$) db 0	
	dw 0xAA55
	

	;Second sector
%include "Kernel.asm"
