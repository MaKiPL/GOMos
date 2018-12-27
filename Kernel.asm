BITS 16

;RAM map:
;0x500 = b text color 
;0x501 = FREE

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
JMP kernelMain

kernelLoadSectorFine:	
MOV SI, sKernelLoaded
CALL printtext

kernelMain:
JMP $

sKernelLoaded: db "Kernel loaded succesfully!", 0
sKernelLoadedHddErrors: db "Kernel HDD error: ", 0
