CC=nasm

build:
	$(CC) -f elf main.asm
	ld -m elf_i386 -o main main.o

run: build
	./main

clean:
	rm main.o
	rm main
