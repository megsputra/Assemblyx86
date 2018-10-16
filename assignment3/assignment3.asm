TITLE Assignment 3				

;;;;; Q1: Don't forget to document your program 			
; Name: Mega Putra
; Date: 10/10/2017

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Answer each question below by writing code at the APPROPRIATE places in the file.
;;;;; Hint: the appropriate place is not always right below the question.

;;;;; Q2: Write the directive to bring in the IO library						xx	

;;;;; Q3: Create a constant called MAX and initialize it to 150					xx

;;;;; Q4: Create a constant called MIN and intialize it to 15% of MAX (from Q3) xx
;;;;;     in an integer expression constant

;;;;; Q5: Define an array of 20 signed doublewords, use any array name you like.xx
;;;;; Initialize:
;;;;;	- the 1st element to -250 
;;;;;	- the 2nd element to the hexadecimal value A924
;;;;;	- the 3rd element to the binary value 10100 
;;;;;	- the 4th element to MAX (from Q3). Use MAX, not a number.
;;;;; and leave the rest of the array uninitialized.  

;;;;; Q6. Define the string "Output = ", use any variable name you like.		xx

;;;;; Q7. Define a prompt that asks the user for a number.						xx

;;;;; Q8. Write code to print to screen the value of eax after MIN is stored 
;;;;;     in eax in the first line of code below.
;;;;;     Use the string you defined in Q6 as the text explanation for your output. xx

;;;;; Q9. Write code to prompt the user for a number, using the prompt string that  xx
;;;;;     you defined in Q7.

;;;;; Q10. Write code to read in the user input, which you can assume is always		xx
;;;;;      a positive number. Hint: use the correct library routine for positive number.

;;;;; Q11. Write code to print "Output = " and then echo to screen the user input.

;;;;; Q12. Write code to print "Output = " and then print the first element of the 
;;;;;      array defined in Q5.

;;;;; Q13. Build, run, and debug your code.

;;;;; Your output should be similar to this (without the commented explanation):
;;;;; Output is 22								; printing MIN
;;;;; Enter a positive number: 7                ; prompt the user for a number
;;;;; Output is 7								; echo user input
;;;;; Output is -250							; print first element of array
;;;;; Press any key to continue . . .

;;;;; Q14. At the end of the source file, without using semicolons (;), add a comment block
;;;;;      to show how bigData appears in memory (should be the same 8 hexadecimal values 
;;;;;      that you saw in assignment 2), 
;;;;;      and explain why it looks different than the actual value 

;;;;; Extra credit (1pt):
;;;;; Write code to print "Output is " and then print the third element of the array defined in Q5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE Irvine32.inc

;	constants
MAX = 150
MIN = (MAX * 15) / 100

.data

; Define an array of 20 signed doublewords, use any array name you like. 
myArray SDWORD -250, 0A924h, 10100b, MAX, 17 DUP (?) 

; Define the string "Output = ", use any variable name you like.
myOutput BYTE "Output = ",0

;Define a prompt that asks the user for a number.
promptStr BYTE "Enter a positive number: ", 0
userNum WORD ?


bigData QWORD 0abcdef0123456789h		; same bigData value as last lab


.code
main PROC

	;	printing output of MIN
	mov edx, OFFSET myOutput
	call writeString
	mov eax, MIN ; eax = MIN value
	call writeDec
	call crlf
	
	;	Write code to prompt the user for a number, using the prompt string that q7
	mov edx, OFFSET promptStr
	call writeString

	;	get positive user input
	mov eax, 0
	mov ax, userNum
	call readDec
	
	mov edx, OFFSET myOutput
	call writeString
	call writeDec
	call crlf
	
	;	first element of array:
	mov edx, OFFSET myOutput
	call writeString
	mov eax, myArray[0]	
	call writeInt
	call crlf


	;	bigData in Memory (I was not able to expand the Memory window because I was using VirtualBox for 
	;	Mac and the screen is not wide so it shows as 2 lines, otherwise it should show that everything is located in 0x0040607A )
	;	0x0040607A  89 67 45 23 01 ef cd ab 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 30 31  .gE#.ïÍ«...............01
	;	0x00406093  32 33 34 35 36 37 38 39 41 42 43 44 45 46 20 20 20 20 20 20 20 20 20 20 20  23456789ABCDEF           
	;	because in memory it is shown according to the little Endian Order. That is why it appears as such.


	;	extra credit print without "Output = "
	mov eax, myArray[2*4]
	call writeInt
	call crlf

	exit	
main ENDP

END main