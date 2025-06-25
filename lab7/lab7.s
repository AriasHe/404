.globl _start

_start:
  jal main
  li a0, 0
  li a7, 93 # exit
  ecall

main:
  mv s1, ra
  li a6, '0'
  jal read
  la t1, input_address
  lbu t2, 2(t1)
  lbu t5, 4(t1)
  lbu a2, 3(t1)
  sub t2, t2, a6

  li t3, 10
  li a4, 10
  bne t3,a2, vai  
  li a7, 7
  j cont

vai:
  bne t5,t3, else
  sub a2,a2,a6
  mul t2,t2,a4
  add t2,t2,a2
  li a7, 8
  j cont
else:
  lbu a7, 5(t1)
  bne a7,t3, cont
  sub a2,a2,a6
  sub t5,t5,a6
  li t4, 100
  mul t2,t2,t4
  mul a2,a2,a4
  add a2,t5,a2
  add t2,t2,a2
  li a7, 9
  j cont
cont:
  
  addi a0,t2,1  

  add t1,t1,a7


  lbu t2, 0(t1)
  addi t1,t1,1
  lbu t5, 0(t1)
  addi t1,t1,1
  lbu a2, 0(t1)
  sub t2, t2, a6
 
  li t3, 10
  li a4, 10
  bne t3,t5, vai1
  li a7, 3
  j cont1

vai1:
  bne t5,t3, else1
  sub a2,a2,a6
  mul t2,t2,a4
  add t2,t2,a2
  li a7, 4
  j cont1
else1:
  lbu a7, 5(t1)
  bne a7,t3, cont1
  sub a2,a2,a6
  sub t5,t5,a6
  li t4, 100
  mul t2,t2,t4
  mul a2,a2,a4
  add a2,t5,a2
  add t2,t2,a2
  li a7, 5
  j cont1
cont1:
  
  addi a1,t2,1

  add t1,t1,a7


  lbu t2, 0(t1)
  addi t1,t1,1
  lbu t5, 0(t1)
  addi t1,t1,1
  lbu a2, 0(t1)
  sub t2, t2, a6
 
  li t3, 10
  li a4, 10
  bne t3,t5, vai2
  addi a7, a7, 7
  j cont2

vai2:
  bne t5,t3, else2
  sub a2,a2,a6
  mul t2,t2,a4
  add t2,t2,a2
  addi a7,a7, 8
  j cont2
else2:
  lbu a7, 5(t1)
  bne a7,t3, cont2
  sub a2,a2,a6
  sub t5,t5,a6
  li t4, 100
  mul t2,t2,t4
  mul a2,a2,a4
  add a2,t5,a2
  add t2,t2,a2
  addi a7,a7, 9
  j cont2
cont2:
  
  addi a2,t2,1


  
  
 
  




enquanto:
  li t1, 0
  li t3, 1
  mv t4,t2
  mv t5,t2
  bge t1, t4, cont1
  mul t5,t2,t5     
  sub t4,t4,t3
  j enquanto








read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 24         # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 4             # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret
.bss

input_address: .skip 0x24  # buffer

result: .skip 0x4