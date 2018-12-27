	BITS 16
	org 07c00h

JMP start


start:
	;sets stack
	mov ax, 07C00h
	SUB AX, 4096		
	mov sp, AX

	;sets constants
	MOV [0x500], BYTE 01 ;0x500 = text color

	
	;sets graphic mode
	MOV AH, 00h
	MOV AL, 13h
	INT 10h

	
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

	MOV [0x501], BYTE AH ;save return value for load sector for kernel use
	JMP BX ;BX holds the address of 0x7E000 that is after bootloader
	
%include "GOM_Text.asm"
	
	
	times 510-($-$$) db 0	
	dw 0xAA55
	

	;Second sector
%include "Kernel.asm"
%include "2D_renderer.asm" ;this has to be AFTER kernel because of the bootloader
