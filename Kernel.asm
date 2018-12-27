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

CMP [ramSpace+1], BYTE 0 ;is loadSector HDD returned 0 as succesful?
JZ kernelLoadSectorFine

MOV [ramSpace], BYTE 4 ;red
MOV SI, sKernelLoadedHddErrors
CALL printtext
MOVZX AX, BYTE [ramSpace+1]
CALL FormatAndDisplayAx
JMP kernel_setdefmode

kernelLoadSectorFine:	
MOV SI, sKernelLoaded
CALL printtext

kernel_setdefmode:
;set default mode
MOV [ramSpace+1], BYTE 0
CALL renderer_setPal

;;================KERNEL MAIN LOOP===============;

;MainLoop
kernelMain:
CALL Kernel_ExecuteMode
CALL Kernel_GetInput
JMP kernelMain

Kernel_GetInput:
;placeholder
RET

;;================KERNEL SWITCH==================;;


Kernel_ExecuteMode:
	cKernel_Mode_F1:
		CMP [ramSpace+1], BYTE 0
		JNE cKernel_Mode_F2
		CALL Kernel_F1
		RET
	cKernel_Mode_F2:
		CMP [ramSpace+1], BYTE 1
		JNE cKernel_Mode_F3
		CALL Kernel_F2
		RET
	cKernel_Mode_F3:
		CMP [ramSpace+1], BYTE 2
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

	PUSH 0x4F
	PUSH 200
	PUSH 0
	PUSH 120
	PUSH 150
	CALL DrawRectangle

	RET

Kernel_F2:
	;
	RET

Kernel_F3:
	;
	RET





sKernelLoaded: db "Kernel loaded succesfully!", 0
sKernelLoadedHddErrors: db "Kernel HDD error: ", 0
