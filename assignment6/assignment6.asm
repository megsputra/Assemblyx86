TITLE  Assignment 6: Use bit wise instructions
		
; Name: Mega Putra
; Date: 11/7/2017

INCLUDE Irvine32.inc

.data
zeroStr BYTE "EAX is 0", 0ah, 0dh, 0
divStr BYTE "Divisible by 4", 0ah, 0dh, 0
arr WORD 1, -2, -3, 4


.code
main PROC


; Question 1 (3pts)
; In the space below, without using CMP and without modifying EAX,
;  write code in 3 different ways (use 3 different instructions)
; to check whether EAX is 0 and jump to label Zero if it is, 
; otherwise jump to Q2.

	mov eax, 0 ; change this value to test your code

	
	xor eax, 0		
	jz Zero


	or eax, eax
	jz Zero


	test eax, eax			
	jz Zero

	 				; cant change eax
					; use shortest way
					; cant use another register
					; do it in place (work only with eax)
					; 3 lines of code
	
	jmp Q2

	Zero :
		mov edx, OFFSET zeroStr
		call writeString
		call crlf

	Q2:
; Question 2
; You can use the following code to impress your friends, 
; but first you need to figure out how it works.

	mov al, 'A'	; al can contain any letter of the alphabet
	xor al, ' '	; the second operand is a space character

COMMENT !

a. (1pt) What does the code do to the letter in AL?  
It moves the hex value of character 'A' to AL, which is 41
It also xor's the that AL with ' ', which has a hex value of 20

b. (2pts) Explain how it works.
The code xor al, ' ' is doing a bitwise XOR and not a logical XOR, so we have
to do the XOR bit by bit in order to get the correct value
A is 41 hex			:	0100 0111
'space' is 20 hex	:	0010 0000 XOR
						0110 0001  which is 61 hex (a)
This gives us the lower case 'a', based on the ASCII table

!				

; Question 3 (4 pts)
; Write code to check whether the data in AL is divisible by 4,
; jump to label DivBy4 if it is, or go to label Q4 if it's not.
; You should not have to use the DIV or IDIV instruction


; ???????????????? if last two digits of the binary is == 0, then it is div by 4, dont care about other 2

	test al, 0011b			; and with 3 (0011), which is the bit mask that will check div by 4			
							; if all zero it means that AL is div by 4, otherwise
	jnz Q4					; if not div by 4, go to Q4

	DivBy4:
		mov edx, OFFSET divStr
		call writeString
		call crlf

	Q4:
; Question 4 (5 pts)
; Given an array arr as already defined in .data above, 
; and ebx is initialized as shown below.
; Using ebx (not the array name), write ONE instruction 
; to reverse the LSB of the last 2 elements of arr.  
; Reverse means turn 0 to 1 or 1 to 0.  
; Your code should work with all values in arr, 
; not just the sample values above.
COMMENT !
	a. You are guaranteed that the array is 4 elements, each element is 1 WORD size. 
	b. The data for each element can be any value within 16 bits. 
	c. It's highly recommended that you use the debugger to see how data looks like in memory 
	so that you reverse the correct 2 bits (only 2 bits should be reversed) 
	d. Use ONE line of code to solve this problem.
!


	mov ebx, OFFSET arr						; arr is 4 long, and each elem is a word,
											; but the values can be anything
	XOR DWORD PTR [ebx+4], 00010001h





	exit	
main ENDP

END main
