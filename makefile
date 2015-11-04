sandbox: main.c func.o fpn.o
	gcc main.c -O3 func.o fpn.o -o sandbox

func.o: func.asm
	nasm -f elf64 func.asm -o func.o

fpn.o: fpn.asm
	nasm -f elf64 fpn.asm -o fpn.o
