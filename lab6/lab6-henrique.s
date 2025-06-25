.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

main:
    mv s1, ra
    jal read
    la a0, input_address
    jal read_num
    mv s7, a1  # save first number in s7
    addi a0, a0, 1 # skip space char
    jal read_num
    mv s8, a1  # save second number in s8

    # read another line
    jal read
    la a0, input_address
    jal read_num
    mv s9, a1  # save third number in s9

    mul a0,s7,s9
    div a1,a0,s8

    jal write_num
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
    # next unread buffer address is in a0
    # resulting number is in a1
    ret

write_num:
    mv s0, ra
    la t0, result
    mv t1, t0
    li t2, 10  # constant 10
write_num_loop:
    rem t3, a1, t2
    div a1, a1, t2
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
    blt t0, t1, write_num_rev

    jal write
    mv ra, s2
    ret

read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 6             # size - Reads 24 bytes.
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