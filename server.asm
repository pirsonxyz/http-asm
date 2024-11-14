section .data
  socket equ 41
  bind equ 49
  listen equ 50
  accept equ 43
  read equ 0
  write equ 1
  open equ 2
  close equ 3
  exit equ 60
  af_inet equ 2
  sock_stream equ 1
  stdout equ 1
  
  address:
   dw af_inet
   dw 0x911F
   dd 0
   dq 0

  addrlen equ $ - address

  filename db "web/index.html", 0
  welcome_message db "Starting the server in port 8081",0aH, 0
  welcome_message_len equ $ - welcome_message
  request_message db "Got request:", 0aH, 0
  request_message_len equ $ - request_message
  bufflen equ 2048
  reqbuff TIMES bufflen db 0
  resbuff TIMES bufflen db 0

  header:
   db "HTTP/1.1 200 OK", 0Ah
   db "Server: asm-server", 0Ah
   db "Content-Type: text/html", 0Ah, 0Ah, 0h

  headerlen equ $ - header
section .text
    global _start
  _start:
     mov rax, write
     mov rdi, stdout
     mov rsi, welcome_message
     mov rdx, welcome_message_len
     syscall
     mov rax, socket
     mov rdi, af_inet
     mov rsi, sock_stream
     mov rdx, 0
     syscall
     mov r12, rax   
     mov rax, bind
     mov rdi, r12
     lea rsi, [address]
     mov rdx, addrlen
     syscall    
     mov rax, listen
     mov rdi, r12
     mov rsi, 10
     syscall
  accept_cons:
    mov rax, accept
    mov rdi, r12
    mov rsi, 0
    mov rdx, 0
    syscall

    mov r13, rax ; client_fd
    mov rax, read
    mov rdi, r13
    mov rsi, reqbuff
    mov rdx, bufflen
    syscall

    mov rax, write
    mov rdi, stdout
    mov rsi, request_message
    mov rdx, request_message_len
    syscall

    mov rax, write
    mov rdi, stdout
    mov rsi, reqbuff
    mov rdx, bufflen
    syscall

    mov rax, open
    mov rdi, filename
    mov rsi, 0
    syscall

    mov r14, rax
    mov rax, read
    mov rdi, r14
    mov rsi, resbuff
    mov rdx, bufflen
    syscall
    
    mov rax, write
    mov rdi, r13
    mov rsi, header
    mov rdx, headerlen
    syscall

    mov rax, write
    mov rdi, r13
    mov rsi, resbuff
    mov rdx, bufflen
    syscall

    mov rax, close
    mov rdi, r13
    syscall
    mov rax, close
    mov rdi, r14
    syscall

  jmp accept_cons
exit_server:
  mov rax, close
  mov rdi, 0
  syscall
