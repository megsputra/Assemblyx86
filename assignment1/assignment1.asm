; Assignment 1
; Name: Mega Putra            

; 1. Put your name above. For the rest of the quarter, you should
;   always have your name at the top of your source file
; 2. In the first_text line below, replace the -- with your name


include Irvine32.inc

.data

first_text BYTE "This is Mega Putra's first Assembly program", 0ah, 0dh, 0

.code
main proc
	mov edx, OFFSET first_text
	call writeString				

	exit
main endp
end main
