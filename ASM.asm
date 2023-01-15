.model SMALL
.DATA
R DW 0
A db "  "
A2 db " . $"
B db "  "
B2 db " . $"
C db "  "
C2 db " . $"
D db "  "
D2 db " . $"
E db " $"
Delta db "  $"
x1 db "  "
x2 db "  "
msg db "Inserisci la prima cifra del numero A: $"
msg2 db "Inserisci la seconda cifra del numero A: $"
msg3 db "Inserisci la prima cifra di B: $"
msg4 db "Inserisci la seconda cifra di B: $"
msg5 db "Inserisci la prima cifra di C: $"
msg6 db "Inserisci la seconda cifra di C: $"
delta_lt_zero db "Delta è minore di zero. Nessuna soluzione reale. $"
.CODE
;Remember: Upon printing, you CAN'T JUST ADD 0x3030, ESPECIALLY WHEN NUMBERS ARE GREATER THAN 9 -> 12 = 0x0C + 0x30 = Not a number, but a letter!
;You shall use this to print:
;AH = Number to check;
;DX = Temporary register
;CMP AH,09h
;MOV DX,00h ;Clear DX
;JG GT
;J Exit
;GT:
;MOV DL,0Ah
;SUB AH,DL
;INC DH
;CMP AH,09h
;JG GT
;Exit:

START:
	MOV AX,@DATA
	MOV DS,AX
	
	get_A:
	
	LEA DX,msg ;print
	MOV AH,09h
	INT 21h
	
	MOV AH,01h
	INT 21h ; Input Value
	SUB AL,30h ;remove 0x30
	
	LEA BX,A
	MOV [BX],AL ; A -> "x "
	
	LEA DX,msg2
	MOV AH,09h ;print2
	INT 21h
	
	MOV AH,01h
	INT 21h
	SUB AL,30h ; remove 0x30
	
	LEA BX,A
	INC BX
	MOV [BX],AL ; A -> "xy"
	
	get_B:
	
	LEA DX,msg3 ;Output
	MOV AH,09h
	INT 21h
	
	MOV AH,01h ;Input
	INT 21h
	SUB AL,30h
	
	LEA BX,B
	MOV [BX],AL ; B -> "x "
	
	LEA DX,msg4 ;Output
	MOV AH,09h
	INT 21h
	
	MOV AH,01h ;Input
	INT 21h
	SUB AL,30h
	
	LEA BX,B
	INC BX ; Write to Y
	MOV [BX],AL ; B -> "xy"
	
	get_C:
	
	LEA DX,msg5 ;Output
	MOV AH,09h
	INT 21h
	
	MOV AH,01h ;Input
	INT 21h
	SUB AL,30h
	
	LEA BX,C
	MOV [BX],AL ; C -> "x "
	
	LEA DX,msg6 ;Output
	MOV AH,09h
	INT 21h
	
	MOV AH,01h
	INT 21h
	SUB AL,30h
	
	LEA BX,C
	INC BX ; Write to Y
	MOV [BX],AL ; C -> "xy"
	
	
	LEA BX,B
	MOV AX,[BX] ; AX = B
	MUL AX ; AX = B*B
	MOV CX,AX 
	LEA BX,A
	MOV AX,[BX]
	LEA BX,C
	MOV DX,[BX]
	MUL DX ; A * C
	MOV DX,04h
	MUL DX
	NEG AX
	ADD AX,CX ; AX = Delta
	
	LEA BX,Delta
	MOV [BX],AX ; Delta -> "xy"
	
	CMP AX,0
	JNGE greater_than_zero
	
	LEA DX,delta_lt_zero
	MOV AH,09h
	INT 21h
	JMP skip_it
	
	greater_than_zero:
	CMP AX,0
	JG greater
	LEA BX,A
	MOV AX,[BX] ;AX = A
	MOV BX,02h
	MUL BX ;AX = 2*A
	MOV DX,AX
	LEA BX,B
	MOV AX,[BX] ;AX = B
	DIV DX ; AX = B/2A
	NEG AX ; x1/2 = -B/2A
	LEA BX,x1
	MOV [BX],AX ;x1 = AX
	LEA BX,x2
	MOV [BX],AX ;x2 = AX
	JMP skip_it
	
	greater:
	
	calc_x1:
	LEA BX,Delta
	MOV AX,[BX] ;AX = Delta
	sqrt:
	MOV DX,01h
	MOV CX,01h
	datloop:
	SUB AX,CX
	JL datend
	INC DX
	ADD CX,02h
	JMP datloop
	datend:
	MOV CX,DX ;CX = sqrt(Delta)
	LEA BX,B
	MOV DX,[BX] ;DX = B
	NEG DX ; DX = - DX = - B
	LEA BX,A
	MOV AX,[BX] ; AX = A
	
	ADD DX,CX ; DX = -b + sqrt(Delta)
	MOV CX,02h
	MUL CX ; AX = 2 * A
	MOV CX,AX
	MOV AX,DX
	DIV CX ; AX = -B + sqrt(Delta) / 2A
	
	LEA BX,x1
	MOV [BX],CX
	
	calc_x2:
	LEA BX,Delta
	MOV AX,[BX] ;AX = Delta
	sqrt2:
	MOV DX,01h
	MOV CX,01h
	datloop2:
	SUB AX,CX
	JL datend2
	INC DX
	ADD CX,02h
	JMP datloop2
	datend2:
	MOV CX,DX ;CX = sqrt(Delta)
	LEA BX,B
	MOV DX,[BX] ;DX = B
	NEG DX ; DX = - DX = - B
	LEA BX,A
	MOV AX,[BX] ; AX = A
	
	NEG CX ; CX = - sqrt(Delta)
	ADD DX,CX ; DX = -b - sqrt(Delta)
	MOV CX,02h
	MUL CX ; AX = 2 * A
	MOV CX,AX
	MOV AX,DX
	DIV CX ; AX = -B + sqrt(Delta) / 2A
	
	LEA BX,x2
	MOV [BX],CX
	
	skip_it:
	
	real_shit:
	LEA BX,Delta
	MOV CX,[BX]
	JS fifth_case
	
	LEA BX,x1
	MOV AX,[BX] ;AX = x1
	LEA BX,x2
	MOV CX,[BX] ;CX = x2
	MUL CX
	JS third_case
	
	LEA BX,x1
	MOV AX,[BX] ;AX = x1
	LEA BX,x2
	MOV CX,[BX] ;CX = x2
	
	CMP AX,CX
	JE second_case
	
	MUL CX ; AX = x1*x2
	MOV DX,02h
	DIV DX ; AX = x*x2/2
	
	;To print AX
	JMP very_end
	
	third_case:
	;To print CX
	JMP very_end
	
	second_case:
	LEA BX,x1
	MOV AH,[BX] ;AX = x1 == x2
	MOV DH,03h
	MOV DL,0Eh
	MUL DX
	;To print AX [Keep in mind that the result is DECIMAL!]
	JMP very_end
	
	fifth_case:
	;Print whatever the fuck you have to
	JMP very_end
	
	
	;Delta:
	
	;LEA BX,C
	;MOV AX,[BX]
	;LEA BX,A
	;MOV CX,[BX]
	;MUL CX ; AX = A * C
	;LEA BX,D
	;MOV [BX],AX
	
	;Delta_Test:
	
	;Subroutine:
	;CMP AH,09h ;
	;MOV DX,00h ;
	;JG Grt;
	;JMP Exit;
	;Grt:;
	;MOV DL,0Ah;
	;SUB AH,DL;
	;INC DH;
	;CMP AH,09h;
	;JG Grt;
	;Exit:;
	;LEA BX,E;
	;ADD DH,30h;
	;MOV [BX],DH;
	
	;LEA BX,D2
	;MOV [BX],AH
	;INC BX
	;INC BX
	;MOV [BX],AL
	
	;LEA DX,E;
	;MOV AH,09h; ;Print subroutine result first
	;INT 21h;
	;LEA DX,D2
	;MOV AH,09h
	;INT 21h
	
	;Get_Number_A:
	;LEA BX,A
	;MOV DX,[BX]
	;DEC DL ; Y = Y - 1
	;DEC DH ; X = X - 1
	;ADD DX,3030h ; Readd 0x3030 to print
	;LEA BX,A2
	;MOV [BX],DH
	;INC BX ;skip the comma
	;INC BX
	;MOV [BX],DL
	
	;Print_Test:
	;LEA DX,A2
	;MOV AH,09h
	;INT 21h
	;INC AL ; Operate on the actual number
	;ADD AL,30h ;Readd 0x30 to print
	;LEA BX,N
	;MOV [BX],AL
	;LEA DX,N
	;MOV AH,09h
	;INT 21h
	very_end:
	MOV AX,4C00h
	int 21h
END START