	.file	"simplecprog.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	2
.LC0:
	.word	3
	.word	7
	.word	2
	.word	9
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-64
	sw	s0,60(sp)
	addi	s0,sp,64
	li	a5,5
	sw	a5,-28(s0)
	li	a5,10
	sw	a5,-32(s0)
	lw	a4,-28(s0)
	lw	a5,-32(s0)
	add	a5,a4,a5
	sw	a5,-36(s0)
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a2,0(a5)
	lw	a3,4(a5)
	lw	a4,8(a5)
	lw	a5,12(a5)
	sw	a2,-52(s0)
	sw	a3,-48(s0)
	sw	a4,-44(s0)
	sw	a5,-40(s0)
	lw	a5,-52(s0)
	sw	a5,-20(s0)
	li	a5,1
	sw	a5,-24(s0)
	j	.L2
.L4:
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-36(a5)
	lw	a4,-20(s0)
	ble	a4,a5,.L3
	lw	a5,-24(s0)
	slli	a5,a5,2
	addi	a4,s0,-16
	add	a5,a4,a5
	lw	a5,-36(a5)
	sw	a5,-20(s0)
.L3:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L2:
	lw	a4,-24(s0)
	li	a5,3
	ble	a4,a5,.L4
	li	a5,0
	mv	a0,a5
	lw	s0,60(sp)
	addi	sp,sp,64
	jr	ra
	.size	main, .-main
	.ident	"GCC: (crosstool-NG 1.26.0_rc1) 10.2.0"
