
#implementacao
  li s3,0
  li s0,0
  li t2,4
  li t0,0
  mv s4,s2
  mv s2,s1

  ################################################################
  
  

pilha:
  addi s0,s0,1
  sub t5,t3,s0
  add sp,sp,t5
  mv t5,s3

  bgt s0,s1,finish
  li t3,0
  mv t1,t2
  addi sp,sp,-1
  addi s3,s3,1
  lw t2,0(sp)
neuronios_2:
  bgt t3,t2,final_neuronio_2
  li t4,0
neuronios_1:
  bgt t4, t1, final_neuronio_1
  sub t5,s3,s2
  add sp,sp,t5
  mv s3,s3,s2

  lw t6,0(sp)
  add t0,t0,t6

  addi sp,sp,-1
  addi s3,s3,1
  addi t4,t4,1

  j neuronios_1

final_neuronio_1:
  sub t5,s3,s4
  add sp,sp,t5
  mv s3,s4
  sw t0, 0(sp)

  sub t5,s3,s2
  add sp,sp,t5
  mv s3,s2
  li t0,0
  addi t3,t3,1
  li t4,0
  j neuronios_2

final_neuronio_2:
  add s2,s2,t1
  mv s2,s4
  j pilha

finish:
  sub sp,sp,s3

 

##############################################################