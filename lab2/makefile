all: lab2.x

#%.s: %.c
#	clang --target=riscv32 -march=rv32g -mabi=ilp32d -nostdlib -mno-relax $< -S -o $@

%.o: %.s
	clang --target=riscv32 -march=rv32g -mabi=ilp32d -nostdlib -mno-relax $< -c -o $@

lab2.x: lab2.o
	ld.lld $^ -o $@