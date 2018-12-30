;RAM map:
;0x500 = b text color 
;0x501 = b mode indicator
;0x502 = AX
;0x504 = BX
;0x506 = CX
;0x508 = DX
;0x600 = memory vars

;clear screen black
PUSH 0 ;color
PUSH 0 ;x=0
PUSH 0 ;y=0
PUSH 320 ;w=320
PUSH 200 ;h=200
CALL DrawRectangle

CMP [0x501], BYTE 0 ;is loadSector HDD returned 0 as succesful?
JZ kernelLoadSectorFine

MOV [0x500], BYTE 4 ;red
MOV SI, sKernelLoadedHddErrors
CALL printtext
MOVZX AX, BYTE [0x501]
CALL FormatAndDisplayAx
JMP kernel_setdefmode

kernelLoadSectorFine:	
MOV SI, sKernelLoaded
CALL printtext

kernel_setdefmode:
;set default mode
MOV [0x501], BYTE 0
CALL renderer_setPal

;;================KERNEL MAIN LOOP===============;

;MainLoop
kernelMain:
CALL Kernel_ExecuteMode
CALL Kernel_GetInput
JMP kernelMain

Kernel_GetInput:
MOV AH, 0
INT 0x16
CMP [0x501], BYTE 0
JE F1Input
Kernel_GetInput_noInput:
RET

;========F1 INPUT======;

F1Input:
CMP AH, 0x0E
JE F1Delete
CMP AH, 0x3C
JE F1Test
;casual character
MOV BL, [sF1CMDbufLen]
AND BX, 0xFF
CMP BL, 32  ;length
JE Kernel_GetInput_noInput
CMP AL, 0x1F
JB Kernel_GetInput_noInput
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

;F2 test
F1Test:
PUSH sF1Registers
PUSH sF1Registers
CALL STRCMP
ADD SP, 4
CALL StoreReg 
RET


;;================KERNEL SWITCH==================;;


Kernel_ExecuteMode:
	cKernel_Mode_F1:
		CMP [0x501], BYTE 0
		JNE cKernel_Mode_F2
	;MOV AX, 0xCAFE
	;MOV BX, 0xBABE
	;MOV CX, 0xDEAD
	;MOV DX, 0x1337
;	CALL StoreReg

		CALL Kernel_F1
		RET
	cKernel_Mode_F2:
		CMP [0x501], BYTE 1
		JNE cKernel_Mode_F3
		CALL Kernel_F2
		RET
	cKernel_Mode_F3:
		CMP [0x501], BYTE 2
		JNE cKernel_Mode_Default
		;JNE Kernel_Mode_F4 ; placeholder 
		CALL Kernel_F3
		RET
	;Kernel_Mode_F4 ;placeholder

cKernel_Mode_Default:
RET ;return no mode



;;==================KERNEL MODES====================;;


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
	


	ADD SP, 30
	RET

Kernel_F2:
	;
	RET

Kernel_F3:
	;
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
sF1CMDbuf: db "> "
sF1CMDbuffer: times 33 db 0
sF1CMDbufLen: db 0
sKernelLoaded: db "Kernel loaded succesfully!", 0
sKernelLoadedHddErrors: db "Kernel HDD error: ", 0
