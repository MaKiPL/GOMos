;RAM map:
;0x500 = b text color 
;0x501 = b mode indicator

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
MOV [0x502], BYTE 1
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
NOP ;placeholder
JZ Kernel_GetInput_noInput

Kernel_GetInput_noInput:
RET

;;================KERNEL SWITCH==================;;


Kernel_ExecuteMode:
	cKernel_Mode_F1:
		CMP [0x501], BYTE 0
		JNE cKernel_Mode_F2
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
	PUSH 180
	CALL DrawRectangle

	;Draw input window
	PUSH 0x12
	PUSH 0
	PUSH 180
	PUSH 320
	PUSH 20
	CALL DrawRectangle

	MOV [0x500], byte 0x34 ;set color

	PUSH 00
	PUSH 0x1B
	CALL SetCursor
	ADD SP, 4

	MOV SI, sF1Registers
	CALL printtext

	PUSH 02
	PUSH 0x19
	CALL SetCursor
	ADD SP, 4

	MOV SI, sF1AX
	CALL printtext

	

	ADD SP, 30
	RET

Kernel_F2:
	;
	RET

Kernel_F3:
	;
	RET




sF1Registers: db "REGISTERS", 0
sF1AX: db "AX: 0000", 0
sF1CMDbuf: times 16 db 0
sKernelLoaded: db "Kernel loaded succesfully!", 0
sKernelLoadedHddErrors: db "Kernel HDD error: ", 0
