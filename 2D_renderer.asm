renderer_setPal:
	;placeholder
	RET


;DrawRectangle breaks AX, BX, CX and DX
DrawRectangle: ;color, x, y, width, height; I could optimize that by mixing color with height?
	MOV AX, 0xA000
	MOV ES, AX
	
	;now we calculate the x*y spot; Correct
	ADD SP, 0x6
	POP AX ;y
	MOV BX, 320
	XOR DX, DX
	MUL BX
	POP BX ;x
	ADD AX, BX
	
	MOV DI, AX ;DI holds global offset (ES:DI)
	POP AX
	AND AX, 0xFF ;AL now holds color ;Correct

	SUB SP, 0xA ;get back to W and H
	POP DX ;H
	POP CX; W
	;SUB SP, 6 ;restore stack for RET

	drawLoop:
	
	CMP DX, 0 ;if height is -1 then return
	JE drawDone
		drawLoopWidth:
		CMP CX, 0
		JE drawDoneWidth
		STOSB ; drawPixel
		DEC CX ; decrease pointer
		JMP drawLoopWidth
	
		drawDoneWidth:
		SUB SP, 2 ;get to stack H
		ADD DI, 320 ;jump
		POP CX ;reset W
		SUB DI, CX 
		DEC DX ;decreases Y pointer
		JMP drawLoop

	drawDone:	
	SUB SP, 6 
	RET



