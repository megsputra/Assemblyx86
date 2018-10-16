; Name : Mega Putra
; Assignment 5

include Irvine32.inc

.data

promptStr1 BYTE "Enter first 16 bit unsigned integer: ", 0
promptStr2 BYTE "Enter second 16 bit unsigned integer: ", 0
errorMsg BYTE "The number must be between 0 and 65,535", 0	
errorSum BYTE "The sum is larger than 16 bits.", 0
continueMsg BYTE "Continue? y/n: ",0
sum BYTE "Sum = ",0
sumArray BYTE ?

.code
main proc

int1Prompt:
	mov edx, OFFSET promptStr1		; ask user input for integer 1
	call writeString				
	call readInt					;	stored in eax

	mov bx, ax				; store user input to bx
	mov ax, 0				; zero out lower 16 bit
	cmp eax, 0				; if eax is completely zero, then data is valid (<= 16 bit)
	je int2Prompt			; jump to prompt int2 if input is ok
					
	mov edx, OFFSET errorMsg	; otherwise print error message
	call writeString
	call crlf	
	jmp int1Prompt

int2Prompt:
	mov edx, OFFSET promptStr2		; ask user input integer 2	
	call writeString
	call readInt

	mov cx, ax					; store user input to cx
	mov ax, 0					; zero out lower 16 bit of eax
	cmp eax, 0					; if eax is completely zero, valid
	JE addNums					; if valid, add numbers
								
	mov edx, OFFSET errorMsg	; otherwise print error message and reprompt int2
	call writeString
	call crlf
	jmp int2Prompt

;	THIS TIME, input1 is in EBX(BX), and input 2 is in ECX(CX)
addNums:
	add bx, cx						; use 16 bit regs once input is forsure 16 bits
	jc invalidSum					; if carry flag is set		
	mov edx, OFFSET sum				; print sum label
	call writeString
	
	mov ax, bx						
	mov bx, 10						; set up divisor
	mov dx, 0						; zero out dx for division
	mov ecx, 5						; counter

convToString:						; result in ax
	div bx
	add dl, 30h						; from ascii table
	mov sumArray[ecx], dl			; take remainder quotient:rem = AX:DX. mov result to end of array
	mov dx, 0						; zero out
	dec cx							; decrement loop counter
	cmp ax, 0						; check if quotient is 0
	jne convToString				; keep looping until quotient is zero
	
	inc ecx							; to print the first digit
	mov edx, OFFSET sumArray
	add edx, ecx					; to get the correct index location
	call writeString					; FINAL RESULT: in eax due to writeDec!!
	call crlf
	jmp user_continue

invalidSum:
	mov edx, OFFSET errorSum
	call writeString				; print overflow sum
	call crlf						; fall through user_continue
	
user_continue:
	mov ecx, 0						; clear out for prompt 2
	mov edx, OFFSET continueMsg
	call writeString
	call readChar					; reads char to al
	call writeChar					; print answer to screen
	call crlf
	cmp al, 'y'						; compare if user wants to continue
	je int1Prompt					;otherwise fall through exit
	cmp al, 'Y'						; consider capital Y
	je int1Prompt					; if y, then back to prompt 1

	exit
main endp
end main