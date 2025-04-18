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
    lbu t2, 1(t1)
    sub t2, t2, a6
    lbu t3, 2(t1)
    sub t3, t3, a6
    li t4, 10
    mul t2,t2,t4
    add a0,t2,t3

    lbu t2, 4(t1)
    sub t2, t2, a6
    lbu t3, 5(t1)
    sub t3, t3, a6
    li t4, 10
    mul t2,t2,t4
    add a1,t2,t3

    lbu t2, 9(t1)
    sub t2, t2, a6
    lbu t3, 10(t1)
    sub t3, t3, a6
    li t4, 10
    mul t2,t2,t4
    add a2,t2,t3

    lbu t2, 12(t1)
    sub t2, t2, a6
    lbu t3, 13(t1)
    sub t3, t3, a6
    li t4, 10
    mul t2,t2,t4
    add a3,t2,t3

    lbu t2, 17(t1)
    lbu t3, 18(t1)
    sub t2, t2, a6
    sub t3, t3, a6
    li t4, 10
    mul t2,t2,t4
    add a4,t2,t3

    lbu t2, 20(t1)
    lbu t3, 21(t1)
    sub t2, t2, a6
    sub t3, t3, a6
    li t4, 10
    mul t2,t2,t4
    add a5,t2,t3

    sub t2, a2,a0
    sub t3, a5,a1
    
    mul t2,t2,t2
    mul t3,t3,t3
    add a0,t2,t3

    li t2,10
    li t4,2
    div a2,a0,t4
    li t3,1
    jal iteracao
parar:

    li t2,10
    rem a0,a2,t2
    div a2,a2,t2
    rem a1,a2,t2
    div a2,a2,t2
    rem a2,a2,t2

    addi a0, a0, '0'
    addi a1, a1, '0'
    addi a2, a2, '0'

    jal write_digits
    mv ra, s1
    ret

iteracao:
    div a3,a0,a2
    add a4,a2,a3
    div a2,a4,t4
    sub t2,t2,t3
    beqz t2,retornar
    j iteracao
retornar:
    ret

write_digits:
    mv s0, ra
    la t1, result  # take `result` address and place it in t1
    li t2, '\n' 
    sb a0, 2(t1)   # store a1 register value in first byte of addr in t1
    sb a1, 1(t1)
    sb a2, 0(t1)
    sb t2, 3(t1)
    jal write      # call write function
    mv ra, s0
    ret            # return to caller

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