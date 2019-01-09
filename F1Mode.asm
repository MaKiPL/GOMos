;========F1 INPUT======;

F1Input:
CMP AH, 0x0E
JE F1Delete

CMP AH, 0x1C
JE F1Enter

;casual character
MOV BL, [sF1CMDbufLen]
AND BX, 0xFF
CMP BL, 20  ;length
JE Kernel_GetInput_noInput
CMP AL, 0x1F
JB Kernel_GetInput_noInput
CALL chrtoup
MOV [sF1CMDbuffer+BX], BYTE AL
INC BYTE [sF1CMDbufLen]
RET

;backspace
F1Delete:
MOV BL, [sF1CMDbufLen]
AND BX, 0xFF
MOV [sF1CMDbuffer+BX], BYTE 0x00
TEST BL, BL
JZ Kernel_GetInput_noInput
DEC BYTE [sF1CMDbufLen]
MOV BL, [sF1CMDbufLen]
MOV [sF1CMDbuffer+BX], BYTE 0x00
RET

;enter
F1Enter:
MOV BX, [0x50C]
CMP BX, 8
JNE F1Enter_n
XOR BX, BX
MOV [0x50C], BX
F1Enter_n:
XOR DX, DX
XOR AX, AX
MOV AL, 21
MUL BX
MOV BX, [0x50A]
ADD BX, AX
PUSH sF1CMDbuffer
PUSH BX
PUSH 20
CALL STRCPY
ADD SP, 6
MOV BX, [0x50C]
INC BX
MOV [0x50C], BX

CALL F1ParseCMD

MOV [sF1CMDbufLen], byte 0
PUSH sF1CMDbuffer
PUSH 21
CALL STRCLR
ADD SP, 4
RET





;======================================ASSEMBLER================;

F1ParseCMD:

PUSH sF1CMDbuffer
PUSH sF1MOV
PUSH 3
CALL strcmp_n
ADD SP, 6
TEST AX, AX
JNZ F1MOV
;TODO
RET

F1MOV:
;TODO
RET





;=======================================MAIN RENDER========================;

Kernel_F1:
	
	;draw main window
	PUSH 0xC7 
	PUSH 0
	PUSH 0
	PUSH 320
	PUSH 200
	CALL DrawRectangle

	;Draw registers window
	PUSH 0x4F
	PUSH 200
	PUSH 0
	PUSH 120
	PUSH 190
	CALL DrawRectangle

	;Draw input window
	PUSH 0x12
	PUSH 0
	PUSH 190
	PUSH 320
	PUSH 10
	CALL DrawRectangle

	MOV [0x500], byte 0x34 ;set color

	PUSH 00
	PUSH 0x1B
	CALL SetCursor
	ADD SP, 4
	MOV SI, sF1Registers
	CALL printtext

	
	;AX
	PUSH 02
	PUSH 0x19
	CALL SetCursor
	ADD SP, 4
	PUSH sF1AX
	MOV AX, [0x502]
	CALL FormatNumber
	ADD SP, 2
	MOV SI, sF1AX
	CALL printtext

	;BX
	PUSH 03
	PUSH 0x19
	CALL SetCursor
	ADD SP, 4
	PUSH sF1BX
	MOV AX, [0x504]
	CALL FormatNumber
	ADD SP, 2
	MOV SI, sF1BX
	CALL printtext
	
	;CX
	PUSH 04
	PUSH 0x19
	CALL SetCursor
	ADD SP, 4
	PUSH sF1CX
	MOV AX, [0x506]
	CALL FormatNumber
	ADD SP, 2
	MOV SI, sF1CX
	CALL printtext

	;DX
	PUSH 05
	PUSH 0x19
	CALL SetCursor
	ADD SP, 4
	PUSH sF1DX
	MOV AX, [0x508]
	CALL FormatNumber
	ADD SP, 2
	MOV SI, sF1DX
	CALL printtext

	;Commandline
	MOV [0x500], BYTE 0x1E
	PUSH 0x18
	PUSH 01
	CALL SetCursor
	ADD SP, 4
	MOV SI, sF1CMDbuf
	CALL printtext
	
	MOV CX, 0
	;history
	historyloop:	
	MOV BX, [0x50A]
	CMP CX, 8 ;8 is number of lines
	JE historyloopend
	XOR DX, DX
	XOR AX, AX
	MOV AL, 21
	MUL CX
	ADD BX, AX
	PUSH BX
	PUSH CX
	PUSH 0x01
	CALL SetCursor
	ADD SP, 2
	POP CX
	POP BX
	MOV SI, BX
	CALL printtext
	INC CX
	JMP historyloop
	
	historyloopend:


	ADD SP, 30
	RET

StoreReg:
	MOV [0x502], WORD AX
	MOV [0x504], WORD BX
	MOV [0x506], WORD CX
	MOV [0x508], WORD DX
	RET

sF1Registers: db "REGISTERS", 0
sF1AX: db "AX: 0000", 0
sF1BX: db "BX: 0000", 0
sF1CX: db "CX: 0000", 0
sF1DX: db "DX: 0000", 0
sF1CMDbuf: db 175,32
sF1CMDbuffer: times 21 db 0
sF1CMDbufLen: db 0
sF1MOV: db "MOV" ;debug
sF1ADD: db "ADD" ;debug
sF1DEBUG: db "DEBUG"
