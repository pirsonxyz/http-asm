all:
	nasm -f elf64 server.asm -o server.o
	gcc -no-pie -o server server.o
	./server 
clean:
	rm server server.o

