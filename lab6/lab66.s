.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

main:
    mv s1, ra
    li a6, '0'
    li s4, 32
    jal read
    la t1, input_address
    lbu t2, 0(t1)
    lbu t3, 2(t1)
    lbu t4, 4(t1)
    beq t3, s4, ler
teste:
    sub t2, t2, a6
    sub t3, t3, a6
    
pular:
    mv s0, ra

    jal read
    la t1, input_address
    lbu t4, 0(t1)
    sub t4, t4, a6

    mul a0,t2,t4
    div a1,a0,t3
    addi a1, a1, '0'



    jal write_digits
    mv ra, s1
    mv s0, ra

    ret
ler:
    li a7,10
    lbu t2, 0(t1)
    lbu t6, 1(t1)
    sub t2, t2, a6
    sub t6, t6, a6
    mul t2,t2,a7
    add t2,t2,t6 
    j pular

ler_2:
    mv s0, ra
    
    mv ra, s0
    ret


write_digits:
    mv s0, ra
    la t1, result  # take `result` address and place it in t1
    li t2, '\n' 
    sb a1, 0(t1)
    sb t2, 1(t1)
    jal write      # call write function
    mv ra, s0
    ret            # return to caller
read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 4         # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 4            # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret
.bss

input_address: .skip 0x6  # buffer

result: .skip 0x4   