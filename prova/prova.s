

# input:
# - a0: buffer address
# output:
# - a0: first unread buffer address
# - a1: number value
# - a2: number signal: -1 (negative) or 1 (positive)

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
  jal read_num #por enquanto s1 é o cara que mostra o final da stack
             # sei quantos numeros foram armazenados na stack 
           #n sei se armazena os dados de t1 e os caralho a 4, ver com o henrique 
  jal read_num

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
  li t3, 10  
  li t5, ',' 
  li t6, '\n' 
  li a1, 0
  li t1,0  


read_num_loop:
  lbu t2, 0(a0)

  beq t2, t5, read_comma #verifica se leu virgula
  beq t2, t6, read_num_ret #se leu um \n termina a leitura dos numeros da entrada
  addi t2, t2, -'0'  #transforma de string pra int
  mul a1, a1, t3
  add a1, a1, t2
  addi a0, a0, 1 
  j read_num_loop
read_comma:
  bnez t1, store
  addi sp, sp, -4 
  sw ra, 0(sp) # salva o endereço de retorno 
  li t1, 4
store:
  addi t1,t1, 4
  addi sp, sp, -4
  sw a1, 0(sp)
  mv s1, t1 #ate onde armazenou no stack 
  j read_num_loop
  


read_num_ret:
  addi a0, a0,1
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


lendo_pesos:
  li t1,1
  li t2,4
  li t5,-1

  bne t1, 1, comeco
  li a1,4
  mul a0,a1,-1
  addi sp, sp, a1

comeco:
  mul t3,t2,t1
  mul t4,t3,t5
  addi sp, sp, t3
  lw a2,0(sp) #quantos valores tem na primeira camada
  addi sp, sp, a1
  lw a3,0(sp) #quantos valores tem na segunda camada 
  addi sp, sp, a0
  addi sp, sp, t4
  addi t1,t1, 1  #lembrar de nao perder essa informacao


pesos:
  li t3,0
  li t2,0
  beq a3,t1,final
  beq a2,t2,final
  la a0, peso_address
  lbu t4, 0(a0)
  #ler a entrada que ta no stack
  #multiplicar em sequencia e colocar o resultado na stack 
  #lembrar de devolver a stack onde ela tava antes



  


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

peso_address: .skip 0x50

result: .skip 0x12