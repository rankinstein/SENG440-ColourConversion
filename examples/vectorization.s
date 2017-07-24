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
	.file	"vectorization.c"
	.text
	.align	2
	.global	add_ints
	.syntax unified
	.arm
	.fpu neon
	.type	add_ints, %function
add_ints:
	@ Function supports interworking.
	@ args = 16, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #36
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	str	r3, [fp, #-28]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L2
.L5:
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L3
.L4:
	ldr	r3, [fp, #-8]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #-28]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L6
	vmul.f64	d17, d16, d17
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #4]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L6+8
	vmul.f64	d16, d16, d18
	vadd.f64	d17, d17, d16
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #8]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L6+16
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vmov.f64	d17, #1.6e+1
	vadd.f64	d7, d16, d17
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [fp, #-32]	@ int
	ldrb	r2, [fp, #-32]
	and	r2, r2, #255
	strb	r2, [r3]
	ldr	r3, [fp, #-8]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-20]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #-28]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L6+24
	vmul.f64	d17, d16, d17
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #4]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L6+32
	vmul.f64	d16, d16, d18
	vadd.f64	d17, d17, d16
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #8]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L6+40
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vldr.64	d17, .L6+48
	vadd.f64	d7, d16, d17
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [fp, #-32]	@ int
	ldrb	r2, [fp, #-32]
	and	r2, r2, #255
	strb	r2, [r3]
	ldr	r3, [fp, #-8]
	lsl	r3, r3, #2
	ldr	r2, [fp, #-24]
	add	r3, r2, r3
	ldr	r2, [r3]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #-28]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L6+40
	vmul.f64	d17, d16, d17
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #4]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L6+56
	vmul.f64	d16, d16, d18
	vadd.f64	d17, d17, d16
	ldr	r2, [fp, #-8]
	lsl	r2, r2, #2
	ldr	r1, [fp, #8]
	add	r2, r1, r2
	ldr	r1, [r2]
	ldr	r2, [fp, #-12]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	vmov	s15, r2	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L6+64
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vldr.64	d17, .L6+48
	vadd.f64	d7, d16, d17
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [fp, #-32]	@ int
	ldrb	r2, [fp, #-32]
	and	r2, r2, #255
	strb	r2, [r3]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L3:
	ldr	r3, [fp, #16]
	bic	r2, r3, #3
	ldr	r3, [fp, #-12]
	cmp	r2, r3
	bhi	.L4
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L2:
	ldr	r3, [fp, #12]
	bic	r2, r3, #3
	ldr	r3, [fp, #-8]
	cmp	r2, r3
	bhi	.L5
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L7:
	.align	3
.L6:
	.word	1683627180
	.word	1079013179
	.word	4054449127
	.word	1080041938
	.word	1305670058
	.word	1077481570
	.word	3264175145
	.word	1078098165
	.word	2989297238
	.word	1079156637
	.word	2473901162
	.word	1079778328
	.word	0
	.word	1080033280
	.word	584115552
	.word	1079478747
	.word	3264175145
	.word	1077037301
	.size	add_ints, .-add_ints
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Vectorization test\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu neon
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	ldr	r0, .L10
	bl	puts
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, lr}
	bx	lr
.L11:
	.align	2
.L10:
	.word	.LC0
	.size	main, .-main
	.ident	"GCC: (GNU Tools for ARM Embedded Processors 6-2017-q1-update) 6.3.1 20170215 (release) [ARM/embedded-6-branch revision 245512]"
