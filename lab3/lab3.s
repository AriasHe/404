	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab3.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	exit
	.p2align	2
	.type	exit,@function
exit:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a1, -12(s0)
	#APP
	mv	a0, a1	# return code
	li	a7, 93	# syscall exit (64) 
	ecall	
	#NO_APP
.Lfunc_end2:
	.size	exit, .Lfunc_end2-exit

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	exit
.Lfunc_end3:
	.size	_start, .Lfunc_end3-_start

	.globl	decimal
	.p2align	2
	.type	decimal,@function
decimal:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 1
	sw	a0, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	sw	a0, -32(s0)
	j	.LBB4_1
.LBB4_1:
	lw	a0, -32(s0)
	lw	a1, -16(s0)
	addi	a1, a1, -1
	bge	a0, a1, .LBB4_8
	j	.LBB4_2
.LBB4_2:
	li	a0, 0
	sw	a0, -36(s0)
	j	.LBB4_3
.LBB4_3:
	lw	a0, -36(s0)
	lw	a1, -32(s0)
	bge	a0, a1, .LBB4_6
	j	.LBB4_4
.LBB4_4:
	lw	a0, -20(s0)
	slli	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB4_5
.LBB4_5:
	lw	a0, -36(s0)
	addi	a0, a0, 1
	sw	a0, -36(s0)
	j	.LBB4_3
.LBB4_6:
	lw	a0, -24(s0)
	lw	a1, -20(s0)
	lw	a2, -12(s0)
	lw	a3, -32(s0)
	add	a2, a2, a3
	lbu	a2, 0(a2)
	mul	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB4_7
.LBB4_7:
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	.LBB4_1
.LBB4_8:
	lw	a0, -24(s0)
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end4:
	.size	decimal, .Lfunc_end4-decimal

	.globl	endige
	.p2align	2
	.type	endige,@function
endige:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -48(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a1, -48(s0)
	li	a0, 31
	blt	a0, a1, .LBB5_4
	j	.LBB5_2
.LBB5_2:
	lw	a0, -12(s0)
	lw	a2, -48(s0)
	add	a0, a0, a2
	lb	a0, 0(a0)
	addi	a1, s0, -44
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB5_3
.LBB5_3:
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB5_1
.LBB5_4:
	li	a0, 0
	sw	a0, -52(s0)
	j	.LBB5_5
.LBB5_5:
	lw	a1, -52(s0)
	li	a0, 7
	blt	a0, a1, .LBB5_8
	j	.LBB5_6
.LBB5_6:
	lw	a0, -12(s0)
	lw	a1, -52(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	addi	a2, s0, -44
	add	a1, a1, a2
	sb	a0, 24(a1)
	j	.LBB5_7
.LBB5_7:
	lw	a0, -52(s0)
	addi	a0, a0, 1
	sw	a0, -52(s0)
	j	.LBB5_5
.LBB5_8:
	li	a0, 8
	sw	a0, -56(s0)
	j	.LBB5_9
.LBB5_9:
	lw	a1, -56(s0)
	li	a0, 15
	blt	a0, a1, .LBB5_12
	j	.LBB5_10
.LBB5_10:
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	addi	a2, s0, -44
	add	a1, a1, a2
	sb	a0, 16(a1)
	j	.LBB5_11
.LBB5_11:
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB5_9
.LBB5_12:
	li	a0, 23
	sw	a0, -60(s0)
	j	.LBB5_13
.LBB5_13:
	lw	a0, -60(s0)
	li	a1, 17
	blt	a0, a1, .LBB5_16
	j	.LBB5_14
.LBB5_14:
	lw	a0, -12(s0)
	lw	a1, -60(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	addi	a2, s0, -44
	add	a1, a1, a2
	sb	a0, -8(a1)
	j	.LBB5_15
.LBB5_15:
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB5_13
.LBB5_16:
	li	a0, 31
	sw	a0, -64(s0)
	j	.LBB5_17
.LBB5_17:
	lw	a0, -64(s0)
	li	a1, 25
	blt	a0, a1, .LBB5_20
	j	.LBB5_18
.LBB5_18:
	lw	a0, -12(s0)
	lw	a1, -64(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	addi	a2, s0, -44
	add	a1, a1, a2
	sb	a0, -8(a1)
	j	.LBB5_19
.LBB5_19:
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB5_17
.LBB5_20:
	addi	a0, s0, -44
	li	a1, 32
	call	decimal
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end5:
	.size	endige, .Lfunc_end5-endige

	.globl	hexa
	.p2align	2
	.type	hexa,@function
hexa:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 0
	sw	a0, -20(s0)
	sw	a0, -28(s0)
	j	.LBB6_1
.LBB6_1:
	lw	a1, -28(s0)
	li	a0, 3
	blt	a0, a1, .LBB6_4
	j	.LBB6_2
.LBB6_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	lw	a2, -28(s0)
	addi	a1, s0, -24
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB6_3
.LBB6_3:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB6_1
.LBB6_4:
	addi	a0, s0, -24
	li	a1, 4
	call	decimal
	sw	a0, -20(s0)
	lw	a0, -20(s0)
	li	a1, 10
	blt	a0, a1, .LBB6_6
	j	.LBB6_5
.LBB6_5:
	lw	a0, -20(s0)
	addi	a0, a0, 31
	sw	a0, -20(s0)
	j	.LBB6_6
.LBB6_6:
	lw	a0, -20(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end6:
	.size	hexa, .Lfunc_end6-hexa

	.globl	complemento_2
	.p2align	2
	.type	complemento_2,@function
complemento_2:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -20(s0)
	j	.LBB7_1
.LBB7_1:
	lw	a1, -20(s0)
	li	a0, 31
	blt	a0, a1, .LBB7_4
	j	.LBB7_2
.LBB7_2:
	lw	a0, -16(s0)
	li	a1, 10
	mul	a0, a0, a1
	lw	a1, -12(s0)
	lw	a2, -20(s0)
	add	a1, a1, a2
	lbu	a1, 0(a1)
	add	a0, a0, a1
	sw	a0, -16(s0)
	j	.LBB7_3
.LBB7_3:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB7_1
.LBB7_4:
	lw	a1, -16(s0)
	li	a0, 0
	sub	a0, a0, a1
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end7:
	.size	complemento_2, .Lfunc_end7-complemento_2

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -128
	sw	ra, 124(sp)
	sw	s0, 120(sp)
	addi	s0, sp, 128
	li	a0, 0
	sw	a0, -12(s0)
	addi	a1, s0, -45
	sw	a1, -112(s0)
	li	a2, 33
	call	read
	mv	a1, a0
	lw	a0, -112(s0)
	sw	a1, -52(s0)
	lw	a1, -52(s0)
	call	decimal
	sb	a0, -47(s0)
	lbu	a0, -14(s0)
	li	a1, 1
	bne	a0, a1, .LBB8_2
	j	.LBB8_1
.LBB8_1:
	li	a0, 45
	sb	a0, -46(s0)
	j	.LBB8_3
.LBB8_2:
	li	a0, 0
	sb	a0, -46(s0)
	j	.LBB8_3
.LBB8_3:
	lw	a2, -52(s0)
	li	a0, 1
	sw	a0, -120(s0)
	addi	a1, s0, -47
	sw	a1, -124(s0)
	call	write
	li	a0, 0
	sw	a0, -116(s0)
	sb	a0, -46(s0)
	addi	a0, s0, -45
	call	endige
	lw	a1, -124(s0)
	mv	a2, a0
	lw	a0, -120(s0)
	sb	a2, -47(s0)
	lw	a2, -52(s0)
	call	write
	lw	a0, -116(s0)
	sw	a0, -64(s0)
	sw	a0, -68(s0)
	j	.LBB8_4
.LBB8_4:
	lw	a1, -68(s0)
	li	a0, 31
	blt	a0, a1, .LBB8_7
	j	.LBB8_5
.LBB8_5:
	lw	a1, -68(s0)
	addi	a0, s0, -45
	call	hexa
	lw	a2, -64(s0)
	addi	a1, s0, -60
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB8_6
.LBB8_6:
	lw	a0, -68(s0)
	addi	a0, a0, 4
	sw	a0, -68(s0)
	j	.LBB8_4
.LBB8_7:
	lbu	a0, -13(s0)
	call	complemento_2
	li	a0, 0
	sw	a0, -128(s0)
	sw	a0, -72(s0)
	addi	a0, s0, -45
	li	a1, 32
	call	decimal
	mv	a1, a0
	lw	a0, -128(s0)
	sw	a1, -72(s0)
	sw	a0, -108(s0)
	j	.LBB8_8
.LBB8_8:
	lw	a1, -108(s0)
	li	a0, 31
	blt	a0, a1, .LBB8_11
	j	.LBB8_9
.LBB8_9:
	lw	a0, -72(s0)
	srai	a1, a0, 31
	srli	a1, a1, 29
	add	a1, a0, a1
	andi	a1, a1, 248
	sub	a0, a0, a1
	lw	a2, -108(s0)
	addi	a1, s0, -104
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -72(s0)
	srai	a1, a0, 31
	srli	a1, a1, 29
	add	a0, a0, a1
	srai	a0, a0, 3
	sw	a0, -72(s0)
	j	.LBB8_10
.LBB8_10:
	lw	a0, -108(s0)
	addi	a0, a0, 1
	sw	a0, -108(s0)
	j	.LBB8_8
.LBB8_11:
	li	a0, 0
	lw	ra, 124(sp)
	lw	s0, 120(sp)
	addi	sp, sp, 128
	ret
.Lfunc_end8:
	.size	main, .Lfunc_end8-main

	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym exit
	.addrsig_sym decimal
	.addrsig_sym endige
	.addrsig_sym hexa
	.addrsig_sym complemento_2
	.addrsig_sym main
