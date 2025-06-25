.equ BUFFER_SIZE, 32

.globl exit
exit:
    li a7, 93 # syscall exit (93)
    ecall
    ret

.globl write
write:
    li a7, 64 # syscall write (64)
    ecall
    ret

.globl puts
# void puts (const char *str);
puts:
  addi sp, sp, -16   # allocate the stack frame
  sw ra, 12(sp)      # save the return address

  mv a1, a0          # save buffer start
puts_while:
  lb t0, 0(a0)       # load current char
  beqz t0, puts_end  # stop moving a0 forward if \0 was found
  addi a0, a0, 1     # move pointer forward
  j puts_while
puts_end:
  sub a2, a0, a1     # compute number of bytes in str
  li a0, 1           # define file descriptor as stdout
  jal write          # write str to stdout

  li a0, 1           # stdout
  la a1, endl        # point to '\n' buffer
  li a2, 1           # write single char, that is, '\n'
  jal write

  lw ra, 12(sp)      # restore the return address
  addi sp, sp, 16    # deallocate the stack frame
  ret                # return

.globl read
# int read(int fd, void *buf, unsigned count);
read:
    li a7, 63 # syscall read (63)
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

.globl atoi
# int atoi(const char *str);
atoi:
  addi sp,sp, -16
  sw ra, 12(sp)

  li t1, ' '
  li t2, '\n'
  li t3, '\t'

atoi_skip_spaces:
  lb t0, 0(a0)
  beq t0, t1, atoi_skip_space
  beq t0, t2, atoi_skip_space
  beq t0, t3, atoi_skip_space
  j atoi_read_sign
atoi_skip_space:
  addi a0, a0, 1
  j atoi_skip_spaces

atoi_read_sign:
  li t1, '-'
  li t2, '+'
  beq t0, t1, atoi_read_negative
  li a2, 1  # sign = positive
  beq t0, t2, atoi_read_positive
  j atoi_read_numbers
atoi_read_negative:
  li a2, -1  # sign = negative
atoi_read_positive:
  addi a0, a0, 1
  j atoi_read_numbers

atoi_read_numbers:
  li t2, 10
  li t3, '0'
  li t4, '9'

  li a1, 0  # result = 0
atoi_read_num:
  lb t0, 0(a0)
  blt t0, t3, atoi_end
  bgt t0, t4, atoi_end
  beqz t0, atoi_end
  addi t0, t0, -'0'
  mul a1, a1, t2
  add a1, a1, t0
  addi a0, a0, 1
  j atoi_read_num
atoi_end:
  mul a0, a1, a2

  lw ra, 12(sp)
  addi sp, sp, 16
  ret

.globl itoa
# char *itoa(int value, char *str, int base);
itoa:
  li t0, 10       # constant 10
  li t1, 9
  li t2, -1
  li t3, '-'
  mv a3, a1
  li a4, 0        # offset to first digit

  bne a2, t0, itoa_loop  # skip negative check for non-base 10
  bge a0, zero, itoa_loop
  mul a0, a0, t2  # convert to positive
  sb t3, 0(a1)    # store minus sign
  addi a1, a1, 1
  li a4, 1        # skip minus sign later
itoa_loop:
  rem t0, a0, a2
  div a0, a0, a2
  bgt t0, t1, itoa_map_to_letter
  addi t0, t0, '0'
  j ioa_store_char
itoa_map_to_letter:
  addi t0, t0, -10
  addi t0, t0, 'a'
ioa_store_char:
  sb t0, 0(a1)
  addi a1, a1, 1
  bnez a0, itoa_loop
  sb zero, 0(a1)   # add null terminator
  mv a0, a3
  add a0, a0, a4   # point a0 to first digit of the buffer
  addi a1, a1, -1  # point a1 to last digit of the buffer
itoa_reverse:
  bge a0, a1, itoa_return
  lb t0, 0(a0)
  lb t1, 0(a1)
  sb t1, 0(a0)
  sb t0, 0(a1)
  addi a0, a0, 1
  addi a1, a1, -1
  j itoa_reverse
itoa_return:
  mv a0, a3
  ret

.globl fibonacci_recursive
# int fibonacci_recursive(int num)
fibonacci_recursive:
  addi sp, sp, -16
  sw ra, 12(sp)
  sw s0, 8(sp)
  sw s1, 4(sp)

  li t0, 2
  blt a0, t0, fibonacci_recursive_base

  mv s0, a0
  addi a0, a0, -1
  jal fibonacci_recursive
  mv s1, a0
  addi a0, s0, -2
  jal fibonacci_recursive
  add a0, s1, a0
fibonacci_recursive_base:
  lw s1, 4(sp)
  lw s0, 8(sp)
  lw ra, 12(sp)
  addi sp, sp, 16
  ret

.globl fatorial_recursive
# int fatorial_recursive(int num);
fatorial_recursive:
  addi sp, sp, -16
  sw ra, 12(sp)
  sw s0, 8(sp)

  li t0, 2
  blt a0, t0, fatorial_recursive_base

  mv s0, a0
  addi a0, a0, -1
  jal fatorial_recursive
  mul a0, s0, a0
  j fatorial_recursive_ret
fatorial_recursive_base:
  li a0, 1
fatorial_recursive_ret:
  lw s0, 8(sp)
  lw ra, 12(sp)
  addi sp, sp, 16
  ret

# void escrever_movimento(char *fmt, int num, char origem, char destino);
escrever_movimento:
  addi sp, sp, -16
  sw ra, 12(sp)
  mv t2, sp 
  la t0, mov_buffer
  li t3, '_'
  
escrever_movimento_while:
  lb t1, 0(a0)
  beqz t1, escrever_movimento_end
  beq t1, t3, escrever_movimento_underscore
  sb t1, 0(t0)
  j escrever_movimento_increment
escrever_movimento_underscore:
  sw t0, 0(t2)
  addi t2, t2, 4
escrever_movimento_increment:
  addi t0, t0, 1
  addi a0, a0, 1
  j escrever_movimento_while
escrever_movimento_end:
  sb zero, 0(t0) # null terminator
  addi a1, a1, '0'
  lw t0, 0(sp)
  sb a1, 0(t0)
  lw t0, 4(sp)
  sb a2, 0(t0)
  lw t0, 8(sp)
  sb a3, 0(t0)

  la a0, mov_buffer
  jal puts

  lw ra, 12(sp)
  addi sp, sp, 16
  ret

.globl torre_de_hanoi
# void torre_de_hanoi(int num, char de, char auxiliar, char ate, char* str);
torre_de_hanoi:
  addi sp, sp, -32
  sw ra, 0(sp)
  sw s0, 4(sp)
  sw s1, 8(sp)
  sw s2, 12(sp)
  sw s3, 16(sp)
  sw s4, 20(sp)

  mv s0, a0
  mv s1, a1
  mv s2, a2
  mv s3, a3
  mv s4, a4

  li t0, 1

  bne s0, t0, torre_de_hanoi_mover_outras
  # mover a menor para o destino
  mv a0, s4 # fmt
  mv a1, s0 # disco n
  mv a2, s1 # torre origem
  mv a3, s3 # torre destino
  jal escrever_movimento
  j torre_de_hanoi_ret

torre_de_hanoi_mover_outras:
  # mover (recursivamente) as (n-1) menores para a auxiliar
  addi a0, a0, -1
  mv a2, s3
  mv a3, s2
  jal torre_de_hanoi

  # mover a maior (n-ésima) para o destino
  mv a0, s4 # fmt
  mv a1, s0 # disco n
  mv a2, s1 # torre origem
  mv a3, s3 # torre destino
  jal escrever_movimento

  # mover (recursivamente) as (n-1) menores da auxiliar para o destino
  addi a0, s0, -1
  mv a1, s2
  mv a2, s1
  mv a3, s3
  jal torre_de_hanoi

torre_de_hanoi_ret:
  lw s4, 20(sp)
  lw s3, 16(sp)
  lw s2, 12(sp)
  lw s1, 8(sp)
  lw s0, 4(sp)
  lw ra, 0(sp)
  addi sp, sp, 32
  ret

.data
endl: .byte '\n'
buffer_ptr: .word buffer
buffer_end: .word buffer

.bss
buffer: .skip BUFFER_SIZE
mov_buffer: .skip 256
