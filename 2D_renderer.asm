renderer_setPal:
	;placeholder
	RET


;DrawRectangle breaks AX, BX, CX and DX
DrawRectangle: ;color, x, y, width, height; I could optimize that by mixing color with height?
	MOV AX, 0xA000
	MOV ES, AX
	
	;now we calculate the x*y spot; Correct
	MOV AX, [ESP+6] ;y
	MOV BX, 320
	XOR DX, DX
	MUL BX
	MOV BX, [ESP+8] ;x
	ADD AX, BX
	
	MOV DI, AX ;DI holds global offset (ES:DI)
	MOV AX, [ESP+0Ah] ;color
	AND AX, 0xFF ;AL now holds color ;Correct

	MOV DX, [ESP+2] ;H
	MOV CX, [ESP+4] ;W

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
		ADD DI, 320 ;jump
		MOV CX, [ESP+4] ;reset W
		SUB DI, CX 
		DEC DX ;decreases Y pointer
		JMP drawLoop

	drawDone:	
	;SUB SP, 6 
	RET



