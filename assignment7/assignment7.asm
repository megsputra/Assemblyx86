TITLE Assignment 7

; Name : Mega Putra

include Irvine32.inc

.data

promptStr1 BYTE "Enter first 16 bit unsigned integer: ", 0
promptStr2 BYTE "Enter second 16 bit unsigned integer: ", 0
errorMsg BYTE "The number must be between 0 and 65,535", 0	
errorSum BYTE "The sum is larger than 16 bits.", 0
continueMsg BYTE "Continue? y/n: ",0
sum BYTE "Sum = ",0
sumArray BYTE 6 DUP (?)

firstInteger WORD ?
secondInteger WORD ?
sumNum WORD ?

.code
main PROC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										CALL READINPUT for the first integer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
int1Prompt:
;	1) make room for result (one space for valid input)
sub esp, 4

;	2) pass the arguments
push OFFSET promptStr1
push OFFSET errorMsg


;	3) call the procedure for input1
call readInput

;	4) Store the return result
pop eax
and eax, 0000FFFFh		; zero out upper half because it needs to be a WORD

pop ebx					; pop the rest of other stacks
pop edx
mov firstInteger, ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										CALL READINPUT for the second integer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;	1) make room for result (one space for valid input)
sub esp, 4

;	2) pass the arguments
push OFFSET promptStr2
push OFFSET errorMsg


;	3) call the procedure for input 2
call readInput

;	4) Store the return result
pop eax
and eax, 0000FFFFh		; zero out upper half because it needs to be a WORD

;pop ebx					; pop the rest of other stacks
;pop edx
mov secondInteger, ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										CALL ADDING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;	1) Make room for result (boolean if sum is valid)
sub esp, 4

;	2) pass the 3 arguments (the 2 input numbers and the address of the sum. The sum is passed back through the address)
movzx eax, firstInteger
push eax
movzx eax, secondInteger
push eax 
push OFFSET sumNum

;	3) call the procedure to add
call adding

;	4) store the return result
pop eax				; bool value is here 1 if sum is good, 0 if invalid sum
					; sumNum is updated through reference!		

cmp eax, 0		; if invalid sum 
jnz Q3		; go to print error message and ask to continue
				; otherwise fall through correct sum Block
				; which is to call printOutput

invSum:
	mov edx, OFFSET errorSum
	call writeString
	call crlf
	jmp user_continue


;mov eax, sumArray
;call writeInt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										CALL printOutput
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Q3:
;	1) no need to make room for result

;	2) pass the arguments
; accepts 3 input arguments: the sum, and the address of the text explanation string and the address of the numeric text string
; sum is in array
mov ax, sumNum
mov edi, OFFSET sum
mov ebp, OFFSET sumArray

;	3) call the procedure to printOutput
call printOutput	; after, will fall through user_continue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										CONTINUE?

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										readInput PROC
; 1.  A readInput procedure that uses the stack to pass data. 
; The procedure prompts the user for a 16-bit integer and keeps prompting until there is a valid input.  The procedure:
; a.	has 2 input arguments: the address of the prompt string and the address of the 
;		error string (for "input out of range" error)
; b.	returns a valid user input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; STACK FRAME:
; empty, for result		  [ebp + 16]
; address of errorMessage [ebp + 12]
; address of promptStr	  [ebp +  8]
; return addr
; ebp

readInput PROC			; if you use regs, dont need to use esp/ebp
	push ebp
	mov ebp, esp
	push edx
	push ebx
	push eax

inputPrompt:
	mov edx, [ebp+12]
	call writeString
	call crlf
	call readInt
	mov bx, ax

	mov ax, 0				; zero out lower 16 bit
	cmp eax, 0				; if eax is completely zero, then data is valid (<= 16 bit)
	je get_out			; jump to prompt int2 if input is ok	
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						; clare's suggestion, but doesnt work for negative input
						;cmp eax, 0FFFFh				; check if less than 65k...
						;jb get_out						; if input is good

	mov edx, [ebp+8]			; print error message
	call writeString
	call crlf
	and eax, 0					; reset the register
	jmp InputPrompt				; unconditional jump - while loop

get_out: ; for correct answer
	mov [ebp+16], ebx
	
	pop eax
	pop ebx
	pop edx
	pop ebp
	ret 8

readInput ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										adding PROC
;  An adding procedure that uses the stack to pass data.
; The procedure adds the 2 numbers, passes back the sum through its address, and returns a boolean to show whether the sum is valid. 
; The procedure:
;	a.	has 3 input arguments: the 2 input numbers and the address of the sum. The sum is passed back through the address
;	b.	returns a boolean to show valid or not valid sum
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; STACK FRAME: 
; empty (for bool result)	[ebp + 20]
; firstInteger				[ebp + 16]
; secondInteger				[ebp + 12]
; address of sumArray		[ebp + 8]
; return addr
; ebp

adding PROC
	push ebp
	mov ebp, esp
	push eax
	push ebx

	mov ax, [ebp+16]			; bx = firstInteger
	add ax, [ebp +12]			; add firstInteger + secondInteger 
								; result is in ax
	jc invalidSum				; if carry flag is set		
								; otherwise, fall through correct sum
	mov DWORD PTR [ebp+20], 1	; SET TO 1
	; store correct bool value = 1

	mov ebx, [ebp + 8]
	mov [ebx], ax				; sumNum now hold the address o
								; store actual sum to address of sumNum
	jmp clear_stack

invalidSum:
	mov DWORD PTR [ebp+20], 0	; SET TO 0
	; longer
	; store correct bool value = 0
	
clear_stack:
	pop ebx
	pop eax
	pop ebp
	ret 12

adding ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										printOutput PROC
;  3.  A printOutput procedure that uses registers to pass data.
;	The procedure converts the sum to a numeric text string and uses writeString to print the text string. The procedure:
; a.	accepts 3 input arguments:
;	the sum,												(sumNum at EAX)
;	and the address of the text explanation string and		(sum at EDI)
;	the address of the numeric text string					(sumArray at EDX)
; b.	has no return value
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;mov ax, sumNum
;mov edi, OFFSET sum
;mov ebp, OFFSET sumArray	; CAN USE EBP?

	
printOutput PROC	
	mov edx, edi
	call writeString				; print "Sum = "
	mov edx, ebp

	mov bx, 10						; set up divisor
	mov dx, 0						; zero out dx for division
	mov ecx, 5						; counter

convToString:						; sumNum (addition result) in ax
	div bx							; or try in 2 byte increments if the sum is big
	add dl, 30h						; from ascii table
	mov sumArray[ecx-1], dl			; take remainder quotient:rem = AX:DX. mov result to end of array
	mov dx, 0						; zero out
	dec cx							; decrement loop counter
	cmp ax, 0						; check if quotient is 0
	jne convToString				; keep looping until quotient is zero
	
	;inc ecx							; to print the first digit
	mov edx, OFFSET sumArray
	add edx, ecx					; to get the correct index location
	call writeString				; FINAL RESULT: in eax due to writeDec!!
	call crlf
						; doesnt stop, need null termination
	ret
printOutput ENDP


COMMENT #
Take the code of assignment 5 and divide it into the following 4 procedures.

4.  A main procedure that coordinates the calling of the 3 previous procedures. The main procedure: 
a.	calls the readInput procedure twice, once for each user input
b.	calls the adding procedure and checks the boolean return value
c.	calls the printOutput procedure if the sum is valid
d.	loops to ask the user to continue or end

#
END main


