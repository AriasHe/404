.globl _start

_start:
  jal main
  li a0, 0
  li a7, 93 # exit
  ecall

main:



  la a0, input_file    # address for the file path
  li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
  li a2, 0             # mode
  li a7, 1024          # syscall open 
  ecall

input_file: .asciz "image.pgm"