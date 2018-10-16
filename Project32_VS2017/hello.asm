; hello world in assembly

include Irvine32.inc

.data
greeting BYTE "hello world", 0ah, 0dh, 0

.code
main proc
	mov edx, OFFSET greeting
	call writeString

	mov	dx,5				
	add	eax,6				

	exit
main endp
end main