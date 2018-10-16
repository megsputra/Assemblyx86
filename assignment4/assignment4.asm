TITLE  Assignment 4: Calculate sum of integer sequences, flag evaluation
		
; Don't forget this beginning documentation block

; Name: Mega Putra
; Date: 10/17/2017
; Assignment 4

; Part 1 (10 pts): Calculate sum of integer sequences
; Add your code here:

INCLUDE Irvine32.inc

.data
	
	getN BYTE "Enter the number of integers: ", 0
	getA BYTE "Enter the start integer: ", 0
	getD BYTE "Enter the difference between integers: ", 0

	N BYTE "N = ",0 
	a BYTE ", a = ",0
	d BYTE ", d = ",0
	s BYTE ", sum = ",0

.code
main PROC
	;;;;;;;;;;;;;;;		Get user input

	;	Prompt user to get N (number of ints)
	mov edx, OFFSET getN
	call writeString
	;	Store user input for N
	call readDec
	mov cl, al			;	N

	;	Prompt user to get a (start Integer)
	mov edx, OFFSET getA
	call writeString
	;	Store user input for A
	mov ebx, 0			; zero out ebx
	call readDec
	mov bl, al			;	a

	;	Prompt user to get d (difference)
	mov edx, OFFSET getD
	call writeString
	;	Store user input for D in A
	call readDec		
	mov bh, al			;	d	

	;;;;;;;;;;;;;;;;;	Display user input : N, a, and d

	mov edx, OFFSET N
	call writeString
	mov al, cl 
	call writeDec		;	print N

	mov edx, OFFSET a
	call writeString
	mov al, bl 
	call writeDec		;	print A

	mov edx, OFFSET d
	call writeString
	mov al, bh			;	D -> AL
	mov bh,0
	call writeDec		;	print D

	;;;;;;;;;;;;;;;;; CALCULATION PORTION

	dec ecx				;	N-1
	mul ecx				;	multiply with d
	inc ecx				;	restore N
	add eax, ebx		;	add 2 a's (twice)
	add eax, ebx
	mul ecx				;	multiply by outer N
	mov ecx, 2
	div ecx				;	divide by 2
	mov edx, OFFSET S	
	call writeString	;	print sum
	call writeDec		;	print value of sum
	call crlf

	exit
main ENDP
END main


COMMENT !
Part 2 (5pts): Flag evaluation
Assume ZF, SF, CF, OF are all clear at the start, and the 3 instructions below run one after another. 
a. fill in the value of all 4 flags after each of the add and the sub instructions runs 
b. explain why CF and OF flags have that value 
   Your explanation should not refer to specific signed / unsigned data values 
   (example of what not to use: the result -12 fits within a byte)
   the ALU doesn't differentiate signed vs. unsigned data and yet it can set the flags.

mov al, 60h 
								; carry   1
add al, 40h						;		  0110 0000
								;		  0100 0000 +
								;	  (0) 1010 0000
; a. ZF = 0    SF = 1    CF = 0   OF = 1
; b. explanation for CF: Carry flag is set when data is out of range
;    explanation for OF: carry in MSB XOR carry out = 0 XOR 1 = 1

sub al, 0FFh     
								;		1010 0000
								;		1111 1111 - use 2's complement first, flip and add 1
								;				?
									
								; carry 0
								;		1010 0000
								;		0000 0001 +
								;	(0) 1010 0001

; a. ZF = 0   SF = 1   CF = 1   OF = 0 ;
; b. explanation for CF: because there is no carry out (CF is 0) for subtraction instrution modifies CF
;    explanation for OF: carry in MSV XOR carry out = 0 XOR 0 = 0

!