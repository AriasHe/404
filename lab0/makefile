%.s: %.c #cria a linguagem de montagem
    clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax prog1.c -S -o prog.s

%.o: %.s #transforma de linguagem de montagem para linguagem de máquina
    clang --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax %.s -c -o %.o

programa.x: %.o	# transforma os programas em uma biblioteca ligando elas
	ld.lld module2.o -o prog.x
