;RAM map:
;0x500 = b text color 
;0x501 = b mode indicator
;0x502 = AX
;0x504 = BX
;0x506 = CX
;0x508 = DX
;0x50A = History var
;0x50C = History line number
;0x510 = 20*8 
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
JMP kernel_setdefmode

kernelLoadSectorFine:	
MOV SI, sKernelLoaded
CALL printtext

kernel_setdefmode:
;set default mode
MOV [0x501], BYTE 0
MOV [0x50A], WORD 0x510
MOV [0x50C], WORD 0x00
;CALL renderer_setPal

;;================KERNEL MAIN LOOP===============;

;MainLoop
kernelMain:
CALL Kernel_ExecuteMode
CALL Kernel_GetInput
JMP kernelMain

Kernel_GetInput:
MOV AH, 0
INT 0x16
CMP AH, 0x3A
JA SetMode
inputSafeHandle:
CMP [0x501], BYTE 0
JE F1Input
CMP [0x501], BYTE 1
JE F2Input
CMP [0x501], BYTE 2
JE F3Input
Kernel_GetInput_noInput:
RET
SetMode:
CMP AH, 0x45
JA inputSafeHandle ;return to parse function
SUB AH, 0x3B
MOV [0x501], AH 
RET

;========F3 INPUT======;
F3Input:
CALL F3_in
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
CALL Kernel_UnknownMode
RET ;return no mode



;;==================KERNEL MODES====================;;


Kernel_UnknownMode:
PUSH 0x00
PUSH 0
PUSH 0
PUSH 320
PUSH 200
CALL DrawRectangle
ADD SP, 0x0A
PUSH text_buffer
PUSH WORD 9
CALL STRCLR
ADD SP, 4 
PUSH BX
MOV BX, text_buffer
SUB BX, 7
PUSH BX
MOVZX AX, [0x501]
INC AL
CALL FormatNumber
POP BX ;clear
POP BX
ADD SP, 2
PUSH BYTE 1
PUSH BYTE 1
CALL SetCursor
ADD SP, 4
MOV [0x500], BYTE 4
MOV SI, sKernel_unknownMode
CALL printtext
MOV SI, text_buffer
CALL printtext
RET

sKernel_unknownMode: db "Unknown mode: ", 0

Kernel_F3:
	%include "F3.asm"
	RET

sKernelLoaded: db "Kernel loaded succesfully!", 0
sKernelLoadedHddErrors: db "Kernel HDD error: ", 0

%include "F1Mode.asm"
%include "F2Mode.asm"
%include "Text_extended.asm"
