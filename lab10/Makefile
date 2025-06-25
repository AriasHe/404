main: biblio.h biblio.s main.c
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -nostdlib -mno-relax biblio.s main.c -o main
