.globl exit
exit:
    li a7, 93 # syscall exit (93)
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
  li a0, 0           # define file descriptor as stdout
  jal write          # write str to stdout

  li a0, 0           # stdout
  la a1, endl        # point to '\n' buffer
  li a2, 1           # write single char, that is, '\n'
  jal write

  lw ra, 12(sp)      # restore the return address
  addi sp, sp, 16    # deallocate the stack frame
  ret                # return

.data
endl: .byte '\n'
