all:
	nasm -f elf64 server.asm -o server.o
	ld -o server server.o
	./server 
clean:
	rm server server.o

