	.cpu arm7tdmi
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"indexEnd.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Loop iterator test\000"
	.align	2
.LC1:
	.ascii	"i = %d\012\000"
	.align	2
.LC2:
	.ascii	"n & ~3 = %d\012\000"
	.align	2
.LC3:
	.ascii	"end\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu softvfp
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r0, .L5
	bl	puts
	mov	r3, #28
	str	r3, [fp, #-12]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L2
.L3:
	ldr	r1, [fp, #-8]
	ldr	r0, .L5+4
	bl	printf
	ldr	r3, [fp, #-12]
	bic	r3, r3, #3
	mov	r1, r3
	ldr	r0, .L5+8
	bl	printf
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L2:
	ldr	r3, [fp, #-12]
	bic	r2, r3, #3
	ldr	r3, [fp, #-8]
	cmp	r2, r3
	bhi	.L3
	ldr	r0, .L5+12
	bl	puts
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, lr}
	bx	lr
.L6:
	.align	2
.L5:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.size	main, .-main
	.ident	"GCC: (GNU Tools for ARM Embedded Processors 6-2017-q1-update) 6.3.1 20170215 (release) [ARM/embedded-6-branch revision 245512]"
