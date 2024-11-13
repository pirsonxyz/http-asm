section .rodata 
  msg db "Hello, world!", 0xa

section .text
   global main
main:
  mov rax,1 ;write
  mov rdi,1 ;fd
  lea rsi, [rel msg] ;const char*
  mov rdx,13 ;size
  syscall
  mov rax,60 ;exit
  mov rdi,0 ; code
  syscall
