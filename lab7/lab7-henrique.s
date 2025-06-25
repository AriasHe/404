.globl _start

_start:
  jal main
  li a0, 0
  li a7, 93 # exit
  ecall

main:
  mv s0, ra
  jal read
  la a0, input_address
  jal read_coef
  mv s4, a1
  mv s5, a2
  jal read_coef
  mv s6, a1
  mv s7, a2
  jal read_coef
  mv s8, a1
  mv s9, a2
  jal read_num
  mv s10, a1
  jal read_num
  mv s11, a1

  addi s4,s4,1
  addi s6,s6,1
  addi s8,s8,1
debug:
  mv t0,s4
  mv t3,s10
  mv t6,s10
  jal potencia

  mv t1,t6

  mv t0,s4
  mv t3,s11
  mv t6,s11
  jal potencia

  sub t6,t6,t1
  div t6,t6,s4

  mv a0,t6
  
  mv t0,s6
  mv t3,s10
  mv t6,s10
  jal potencia

  mv t1,t6

  mv t0,s6
  mv t3,s11
  mv t6,s11
  jal potencia

  sub t6,t6,t1
  div t6,t6,s6
  mv a1,t6

  mv t0,s8
  mv t3,s10
  mv t6,s10
  jal potencia

  mv t1,t6

  mv t0,s8
  mv t3,s11
  mv t6,s11
  jal potencia

  sub t6,t6,t1
  div t6,t6,s8
  mv a2,t6

  mul a0,a0,s5
  mul a1,a1,s7
  mul a2,a2,s9

  add a0,a0,a2
  add a1,a1,a0
  
  jal write_num

  mv ra, s0
  ret




potencia:
  mv s2, ra
  li t5, 1
potencia_loop:
  beq t5,t0, sair
  mul t6,t6,t3
  addi t5,t5,1
  j potencia_loop
sair:
  mv ra, s2
  ret
 

# input:
# - a0: buffer address
# output:
# - a0: first unread buffer address
# - a1: number value
# - a2: number signal: -1 (negative) or 1 (positive)
read_coef:
  mv s1, ra
  lbu t1, 0(a0)
  li t2, '+'
  li a2, 1
  beq t1, t2, read_coef_cont
  li a2, -1
read_coef_cont:
  addi a0, a0, 2 # skip signal and space
  jal read_num
  mv ra, s1
  ret

read_num:
  li t3, 10  # const 10
  li t5, ' ' # space char
  li t6, '\n' # newline char
  li a1, 0   # resulting number
read_num_loop:
  lbu t2, 0(a0)  # load another digit
  # check if all digits are over
  beq t2, t5, read_num_ret
  beq t2, t6, read_num_ret
  addi t2, t2, -'0'  # convert from char to int
  mul a1, a1, t3
  add a1, a1, t2
  addi a0, a0, 1  # move to next input byte
  j read_num_loop
read_num_ret:
  # consume space or \n found
  addi a0, a0, 1
  # next unread buffer address is in a0
  # resulting number is in a1
  ret

read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 24         # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write_num:
  mv s1, ra
  la t0, result
  mv t1, t0
  li t2, 10  # constant 10
write_num_loop:
  rem t3, a1, t2
  div a1, a1, t2
  addi t3, t3, '0'
  sb t3, 0(t1)
  addi t1, t1, 1
  bnez a1, write_num_loop
write_num_end:   
  li t2, '\n'
  sb t2, 0(t1)
  addi t1, t1, -1
write_num_rev:
  lb t2, 0(t0)
  lb t3, 0(t1)
  sb t2, 0(t1)
  sb t3, 0(t0)
  addi t0, t0, 1
  addi t1, t1, -1
  blt t0, t1, write_num_rev // t0<t1

  jal write
  mv ra, s1
  ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 12          # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret
.bss

input_address: .skip 0x24  # buffer

result: .skip 0x12