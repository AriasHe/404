.equ BUFFER_SIZE, 32




.globl _start
_start:
  jal main
  li a0, 0
  li a7, 93 # exit
  ecall

  main:
  li s1,0
  addi sp, sp, -4
  sw ra, 0(sp)
  la a0, input_address 
  jal gets
  jal read_num
  
  jal gets
  jal read_num_2


  la a5,camadas
  lw a3,0(a5)
  lw a3,4(a5)
  lw a3,8(a5)
  lw a3,12(a5)
  mv t1,t0

  la a5,endereco
  lw a3,0(a5)
  lw a3,4(a5)
  lw a3,8(a5)
  lw a3,12(a5)

  
  jal multiplicacao

  lw ra, 0(sp)
  addi sp, sp, 4
  ret


read_num:
  li t3, 10  
  li t5, ',' 
  li t6, 0 
  li a1, 0
  li t1,0
  mv t1,s1
  la a6,camadas

  beqz t1,read_num_loop
  #sub sp,sp,t1

read_num_loop:
  lbu t2, 0(a0)
  
  beq t2, t5, store #verifica se leu virgula
  beq t2, t6, read_num_ret #se leu um \n termina a leitura dos numeros da entrada
  addi t2, t2, -'0'  #transforma de string pra int
  mul a1, a1, t3
  add a1, a1, t2

  addi a0, a0, 1 
  j read_num_loop

store:
  addi t1,t1, 1
  #addi sp, sp, -4
  #sw a1, 0(sp)
  sw a1, 0(a6)
  lw a3, 0(a6)
  addi a6,a6,4
  mv s1, t1 #ate onde armazenou no stack 
  addi a0,a0,1
  li a1,0
  j read_num_loop
  

read_num_ret:
  addi t1,t1, 1
  #addi sp, sp, -4
  sw a1, 0(sp)
  sw a1, 0(a6)
  lw a3, 0(a6)
  mv s1, t1

  addi a0, a0,1
  add sp, sp, t1

  ret


read_num_2:
  li t3, 10  
  li t5, ',' 
  li t6, 0 
  li a1, 0
  li t1,0
  mv t1,s1
  la a5,endereco

  beqz t1,read_num_loop_2

read_num_loop_2:
  lbu t2, 0(a0)
  
  beq t2, t5, store_2 #verifica se leu virgula
  beq t2, t6, read_num_ret_2 #se leu um \n termina a leitura dos numeros da entrada
  addi t2, t2, -'0'  #transforma de string pra int
  mul a1, a1, t3
  add a1, a1, t2

  addi a0, a0, 1 
  j read_num_loop_2

store_2:
  addi t1,t1, 4
  sw a1, 0(a5)
  lw a3, 0(a5)
  addi a5,a5,4
  #mv s1, t1 #ate onde armazenou no stack 
  addi a0,a0,1
  li a1,0
  j read_num_loop_2
  

read_num_ret_2:
  addi t1,t1, 4
  sw a1, 0(a5)
  lw a3, 0(a5)
  #mv s1, t1

  addi a0, a0,1
  ret











multiplicacao:
  li t1,0
  li t2,0
  li t4,0
  li a2,0
  li s7,0
  li s5,16
  li s9,0
  la a4,endereco
  la a5,endereco
  la a3,endereco
  add s5,s5,a5
  la a6,camadas
  li s3,4 

  #lw a1, 0(a5)
  #lw a1, 0(a6)
  #beq s3,s1,fora'

 
  
comeco:
  addi a6,a6,4
  li t4,0
  li t5,4
  li t6,3
  mul t5,t5,s9
  add a4,a4,t5
  mv a5,a4
  beq s7, s1,fora
  addi s7,s7,1
  mv s2,s3
  beq s2,t6,fora
  mv s9,s2
  lw s3,0(a6)
iteracao:
  beq t4,s3,comeco

somatorio:

  beq t1,s2,cont
  lw a1, 0(a5)
  #aqui vou ter que colocar o peso 
  add a2,a2,a1
  addi a5,a5,4
  addi t1,t1,1
  j somatorio
  

cont:
  mv a5, a4 
  sw a2, 0(s5)
  li t1,0
  li a2,0
  addi s5,s5,4
  lw a7,16(a3)
  lw a7,20(a3)
  lw a7,24(a3)
  lw a7,28(a3)
  lw a7,32(a3)
  lw a7,36(a3)
  lw a7,40(a3)
  lw a7,44(a3)
  lw a7,48(a3)
  lw a7,52(a3)
  lw a7,56(a3)
  lw a7,60(a3)
  addi t4,t4,1
  j iteracao

fora:
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














  .globl gets
# char *gets(char *str);
gets:
  addi sp, sp, -16
  sw ra, 12(sp)
  sw s0, 8(sp)
  sw s1, 4(sp)
  sw s2, 0(sp)
  mv s0, a0      # keep arg str pointer
  mv s2, a0      # output pointer to be moved forward

  la t0, buffer_ptr
  lw t1, 0(t0)
  la t0, buffer_end
  lw t2, 0(t0)
  blt t0, t1, gets_copy_to_string
gets_populate_buffer:
  li a0, 0       # fd stdin
  la a1, buffer  # buffer to store input
  li a2, BUFFER_SIZE
  jal read

  la a1, buffer
  add s1, a0, a1  # buffer_end = buffer + read bytes
  la t0, buffer_ptr
  sw a1, 0(t0)    # buffer_ptr = buffer
  la t0, buffer_end
  sw s1, 0(t0)

  beqz a0, gets_return
gets_copy_to_string:
  la t0, buffer_ptr
  lw a0, 0(t0)
  la t0, buffer_end
  lw s1, 0(t0)

  li t2, '\n'

gets_while:
  bge a0, s1, gets_populate_buffer  # if buffer_ptr >= buffer_end
  lb t0,0(a0)
  beq t0, t2, gets_end
  sb t0, 0(s2)    # copy char to output str
  addi a0, a0, 1
  addi s2, s2, 1
  j gets_while
gets_end:
  sb zero, 0(s2)  # add null terminator (\0) to str
  addi a0, a0, 1  # skip newline (\n)
  la t0, buffer_ptr
  sw a0, 0(t0)
  mv a0, s0

gets_return:
  lw s2, 0(sp)
  lw s1, 4(sp)
  lw s0, 8(sp)
  lw ra, 12(sp)
  addi sp,sp,16
  ret
read:
    li a7, 63 # syscall read (63)
    ecall
    ret

.data
buffer_ptr: .word buffer
buffer_end: .word buffer
input_address: .skip 0x24  # buffer
result: .skip 0x12
endereco: .skip 0x20000
camadas: .skip 0x20000


.bss
buffer: .skip BUFFER_SIZE