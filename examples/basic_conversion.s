	.cpu arm7tdmi
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 2
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"basic_conversion.c"
	.global	__aeabi_i2d
	.global	__aeabi_dmul
	.global	__aeabi_dadd
	.global	__aeabi_d2f
	.global	__aeabi_fcmpgt
	.global	__aeabi_f2d
	.global	__aeabi_d2uiz
	.global	__aeabi_fmul
	.global	__aeabi_fadd
	.text
	.align	2
	.global	add_ints
	.syntax unified
	.arm
	.fpu softvfp
	.type	add_ints, %function
add_ints:
	@ Function supports interworking.
	@ args = 8, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub	sp, sp, #92
	ldr	ip, [sp, #128]
	cmp	ip, #0
	ldr	ip, [sp, #132]
	add	ip, ip, ip, lsl #1
	str	ip, [sp, #72]
	beq	.L1
	ldr	ip, [sp, #132]
	cmp	ip, #0
	beq	.L1
	str	r3, [sp, #84]
	mov	r3, #0
	str	r2, [sp, #80]
	ldr	r2, [sp, #72]
	str	r3, [sp, #68]
	str	r3, [sp, #60]
	str	r3, [sp, #28]
	str	r3, [sp, #52]
	add	r3, r0, ip
	str	r1, [sp, #76]
	str	r0, [sp, #44]
	str	r2, [sp, #56]
	str	r3, [sp, #40]
.L9:
	ldr	r3, [sp, #84]
	ldr	r2, [sp, #52]
	add	r1, r3, r2
	str	r1, [sp, #8]
	ldr	r0, [sp, #76]
	ldr	r1, [sp, #28]
	add	r0, r0, r1
	str	r0, [sp, #36]
	ldr	r0, [sp, #80]
	add	r1, r0, r1
	str	r1, [sp, #32]
	ldr	r1, [sp, #56]
	add	r3, r3, r1
	str	r3, [sp, #12]
	ldr	r3, [sp, #60]
	str	r2, [sp, #24]
	str	r3, [sp, #4]
.L8:
	ldr	r6, [sp, #8]
	ldrb	r0, [r6]	@ zero_extendqisi2
	bl	__aeabi_i2d
	mov	r4, r0
	ldrb	r0, [r6, #1]	@ zero_extendqisi2
	mov	r5, r1
	bl	__aeabi_i2d
	mov	r10, r0
	ldrb	r0, [r6, #2]	@ zero_extendqisi2
	mov	fp, r1
	bl	__aeabi_i2d
	mov	r8, r0
	mov	r9, r1
	adr	r3, .L21
	ldmia	r3, {r2-r3}
	mov	r0, r4
	mov	r1, r5
	str	r8, [sp, #16]
	str	r9, [sp, #20]
	bl	__aeabi_dmul
	adr	r3, .L21+8
	ldmia	r3, {r2-r3}
	mov	r6, r0
	mov	r7, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	adr	r3, .L21+16
	ldmia	r3, {r2-r3}
	mov	r6, r0
	mov	r7, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, #0
	ldr	r3, .L21+64
	bl	__aeabi_dmul
	mov	r2, #0
	ldr	r3, .L21+68
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	ldr	r1, .L21+72
	mov	r6, r0
	bl	__aeabi_fcmpgt
	cmp	r0, #0
	movne	r0, #255
	bne	.L4
	mov	r0, r6
	bl	__aeabi_f2d
	bl	round
	bl	__aeabi_d2uiz
	and	r0, r0, #255
.L4:
	ldr	r3, [sp, #44]
	ldr	r2, [sp, #4]
	mov	r1, r5
	strb	r0, [r3, r2]
	adr	r3, .L21+24
	ldmia	r3, {r2-r3}
	mov	r0, r4
	bl	__aeabi_dmul
	adr	r3, .L21+32
	ldmia	r3, {r2-r3}
	mov	r8, r0
	mov	r9, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dadd
	adr	r3, .L21+40
	ldmia	r3, {r2-r3}
	mov	r8, r0
	mov	r9, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	adr	r3, .L21+40
	ldmia	r3, {r2-r3}
	mov	r1, r5
	mov	r7, r0
	mov	r0, r4
	bl	__aeabi_dmul
	adr	r3, .L21+48
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L21+56
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	ldr	r4, [sp, #12]
	str	r0, [sp, #48]	@ float
	ldrb	r0, [r4]	@ zero_extendqisi2
	bl	__aeabi_i2d
	mov	r10, r0
	ldrb	r0, [r4, #1]	@ zero_extendqisi2
	mov	fp, r1
	bl	__aeabi_i2d
	str	r0, [sp, #16]
	str	r1, [sp, #20]
	ldrb	r0, [r4, #2]	@ zero_extendqisi2
	bl	__aeabi_i2d
	mov	r8, r0
	mov	r9, r1
	mov	r0, r6
	ldr	r1, .L21+72
	bl	__aeabi_fcmpgt
	cmp	r0, #0
	movne	r0, #255
	bne	.L5
	adr	r3, .L21
	ldmia	r3, {r2-r3}
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	adr	r3, .L21+8
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L21+16
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r2, #0
	ldr	r3, .L21+64
	bl	__aeabi_dmul
	mov	r2, #0
	ldr	r3, .L21+68
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	bl	__aeabi_f2d
	bl	round
	bl	__aeabi_d2uiz
	and	r0, r0, #255
.L5:
	ldr	r3, [sp, #40]
	ldr	r2, [sp, #4]
	mov	r1, fp
	strb	r0, [r3, r2]
	adr	r3, .L21+24
	ldmia	r3, {r2-r3}
	mov	r0, r10
	bl	__aeabi_dmul
	adr	r3, .L21+32
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L21+40
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r4, r0
	mov	r0, r7
	mov	r5, r1
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	adr	r3, .L21+40
	ldmia	r3, {r2-r3}
	mov	r1, fp
	mov	r6, r0
	mov	r0, r10
	bl	__aeabi_dmul
	adr	r3, .L21+48
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L21+56
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r4, r0
	ldr	r0, [sp, #48]	@ float
	mov	r5, r1
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	b	.L22
.L23:
	.align	3
.L21:
	.word	1683627180
	.word	1079013179
	.word	4054449127
	.word	1080041938
	.word	1305670058
	.word	1077481570
	.word	3264175145
	.word	-1069352715
	.word	2989297238
	.word	-1068327011
	.word	2473901162
	.word	1079778328
	.word	584115552
	.word	-1068004901
	.word	3264175145
	.word	-1070446347
	.word	1064304640
	.word	1076887552
	.word	1132396544
.L22:
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	ldr	r4, [sp, #8]
	mov	r7, r0
	ldrb	r0, [r4, #3]	@ zero_extendqisi2
	bl	__aeabi_i2d
	mov	r8, r0
	ldrb	r0, [r4, #4]	@ zero_extendqisi2
	mov	r9, r1
	bl	__aeabi_i2d
	mov	r10, r0
	ldrb	r0, [r4, #5]	@ zero_extendqisi2
	mov	fp, r1
	bl	__aeabi_i2d
	adr	r3, .L24
	ldmia	r3, {r2-r3}
	str	r0, [sp, #16]
	str	r1, [sp, #20]
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	adr	r3, .L24+8
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L24+16
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r2, #0
	ldr	r3, .L24+64
	bl	__aeabi_dmul
	ldr	r3, .L24+68
	mov	r2, #0
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	ldr	r1, .L24+72
	mov	r4, r0
	bl	__aeabi_fcmpgt
	ldr	r3, [sp, #24]
	cmp	r0, #0
	add	r3, r3, #6
	str	r3, [sp, #24]
	movne	r0, #255
	bne	.L6
	mov	r0, r4
	bl	__aeabi_f2d
	bl	round
	bl	__aeabi_d2uiz
	and	r0, r0, #255
.L6:
	ldr	r2, [sp, #4]
	ldr	r3, [sp, #44]
	add	r3, r3, r2
	strb	r0, [r3, #1]
	mov	r1, r9
	adr	r3, .L24+24
	ldmia	r3, {r2-r3}
	mov	r0, r8
	bl	__aeabi_dmul
	adr	r3, .L24+32
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L24+40
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r4, r0
	mov	r0, r6
	mov	r5, r1
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	adr	r3, .L24+40
	ldmia	r3, {r2-r3}
	mov	r1, r9
	mov	r6, r0
	mov	r0, r8
	bl	__aeabi_dmul
	adr	r3, .L24+48
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L24+56
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r4, r0
	mov	r0, r7
	mov	r5, r1
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #56]
	ldr	r4, [sp, #12]
	add	r9, r3, r2
	ldr	r3, [sp, #52]
	str	r0, [sp, #48]	@ float
	sub	r3, r9, r3
	ldrb	r0, [r4, #3]	@ zero_extendqisi2
	str	r3, [sp, #64]
	bl	__aeabi_i2d
	mov	r10, r0
	ldrb	r0, [r4, #4]	@ zero_extendqisi2
	mov	fp, r1
	bl	__aeabi_i2d
	str	r0, [sp, #16]
	str	r1, [sp, #20]
	ldrb	r0, [r4, #5]	@ zero_extendqisi2
	bl	__aeabi_i2d
	adr	r3, .L24
	ldmia	r3, {r2-r3}
	mov	r8, r0
	mov	r9, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	adr	r3, .L24+8
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L24+16
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r2, #0
	ldr	r3, .L24+64
	bl	__aeabi_dmul
	mov	r2, #0
	ldr	r3, .L24+68
	bl	__aeabi_dadd
	bl	__aeabi_d2f
	ldr	r1, .L24+72
	mov	r4, r0
	bl	__aeabi_fcmpgt
	cmp	r0, #0
	movne	r0, #255
	bne	.L7
	mov	r0, r4
	bl	__aeabi_f2d
	bl	round
	bl	__aeabi_d2uiz
	and	r0, r0, #255
.L7:
	ldr	r2, [sp, #40]
	ldr	r3, [sp, #4]
	add	r3, r2, r3
	strb	r0, [r3, #1]
	mov	r1, fp
	adr	r3, .L24+24
	ldmia	r3, {r2-r3}
	mov	r0, r10
	bl	__aeabi_dmul
	adr	r3, .L24+32
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L24+40
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r4, r0
	mov	r0, r6
	mov	r5, r1
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	adr	r3, .L24+40
	ldmia	r3, {r2-r3}
	mov	r4, r0
	mov	r5, r1
	mov	r0, r10
	mov	r1, fp
	bl	__aeabi_dmul
	b	.L25
.L26:
	.align	3
.L24:
	.word	1683627180
	.word	1079013179
	.word	4054449127
	.word	1080041938
	.word	1305670058
	.word	1077481570
	.word	3264175145
	.word	-1069352715
	.word	2989297238
	.word	-1068327011
	.word	2473901162
	.word	1079778328
	.word	584115552
	.word	-1068004901
	.word	3264175145
	.word	-1070446347
	.word	1064304640
	.word	1076887552
	.word	1132396544
.L25:
	adr	r3, .L27
	ldmia	r3, {r2-r3}
	mov	r6, r0
	mov	r7, r1
	add	r1, sp, #16
	ldmia	r1, {r0-r1}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	adr	r3, .L27+8
	ldmia	r3, {r2-r3}
	mov	r6, r0
	mov	r7, r1
	mov	r0, r8
	mov	r1, r9
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r6, r0
	ldr	r0, [sp, #48]	@ float
	mov	r7, r1
	bl	__aeabi_f2d
	mov	r3, r1
	mov	r2, r0
	mov	r1, r7
	mov	r0, r6
	bl	__aeabi_dadd
	mov	r6, r0
	mov	r7, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_d2f
	mov	r1, #998244352
	bl	__aeabi_fmul
	mov	r1, #1140850688
	bl	__aeabi_fadd
	mov	r1, #1048576000
	bl	__aeabi_fmul
	bl	__aeabi_f2d
	bl	round
	bl	__aeabi_d2uiz
	ldr	r2, [sp, #36]
	strb	r0, [r2], #1
	mov	r1, r7
	mov	r0, r6
	str	r2, [sp, #36]
	bl	__aeabi_d2f
	mov	r1, #998244352
	bl	__aeabi_fmul
	mov	r1, #1140850688
	bl	__aeabi_fadd
	mov	r1, #1048576000
	bl	__aeabi_fmul
	bl	__aeabi_f2d
	bl	round
	bl	__aeabi_d2uiz
	ldr	r3, [sp, #4]
	ldr	r2, [sp, #60]
	add	r3, r3, #2
	str	r3, [sp, #4]
	sub	r3, r3, r2
	ldr	r2, [sp, #132]
	cmp	r2, r3
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
	ldr	r3, [sp, #8]
	add	r3, r3, #6
	str	r3, [sp, #8]
	ldr	r3, [sp, #12]
	add	r3, r3, #6
	str	r3, [sp, #12]
	ldr	r3, [sp, #32]
	strb	r0, [r3], #1
	str	r3, [sp, #32]
	bhi	.L8
	ldr	r3, [sp, #68]
	ldr	r2, [sp, #128]
	add	r3, r3, #2
	cmp	r2, r3
	str	r3, [sp, #68]
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #72]
	add	r2, r3, r2
	str	r2, [sp, #52]
	ldr	r2, [sp, #64]
	add	r3, r3, r2
	str	r3, [sp, #56]
	ldr	r2, [sp, #4]
	ldr	r3, [sp, #132]
	add	r3, r3, r2
	str	r3, [sp, #60]
	bhi	.L9
.L1:
	add	sp, sp, #92
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	bx	lr
.L28:
	.align	3
.L27:
	.word	584115552
	.word	-1068004901
	.word	3264175145
	.word	-1070446347
	.size	add_ints, .-add_ints
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu softvfp
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	mov	r4, #4
	sub	sp, sp, #80
	ldr	r0, .L37
	bl	puts
	ldr	lr, .L37+4
	ldmia	lr!, {r0, r1, r2, r3}
	add	ip, sp, #32
	stmia	ip!, {r0, r1, r2, r3}
	ldmia	lr!, {r0, r1, r2, r3}
	stmia	ip!, {r0, r1, r2, r3}
	ldm	lr, {r0, r1, r2, r3}
	add	r7, sp, #12
	add	r8, sp, #8
	stm	ip, {r0, r1, r2, r3}
	str	r4, [sp, #4]
	str	r4, [sp]
	add	r0, sp, #16
	mov	r2, r7
	mov	r1, r8
	add	r3, sp, #32
	mov	r5, r0
	mov	r4, #0
	bl	add_ints
	ldr	r6, .L37+8
.L30:
	mov	r1, r4
	ldrb	r2, [r5], #1	@ zero_extendqisi2
	mov	r0, r6
	add	r4, r4, #1
	bl	printf
	cmp	r4, #16
	bne	.L30
	mov	r4, #0
	ldr	r5, .L37+12
.L31:
	ldrb	r2, [r8, r4]	@ zero_extendqisi2
	mov	r1, r4
	mov	r0, r5
	add	r4, r4, #1
	bl	printf
	cmp	r4, #4
	bne	.L31
	mov	r4, #0
	ldr	r5, .L37+16
.L32:
	ldrb	r2, [r7, r4]	@ zero_extendqisi2
	mov	r1, r4
	mov	r0, r5
	add	r4, r4, #1
	bl	printf
	cmp	r4, #4
	bne	.L32
	mov	r0, #0
	add	sp, sp, #80
	@ sp needed
	pop	{r4, r5, r6, r7, r8, lr}
	bx	lr
.L38:
	.align	2
.L37:
	.word	.LC1
	.word	.LANCHOR0
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.size	main, .-main
	.section	.rodata
	.align	2
	.set	.LANCHOR0,. + 0
.LC0:
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.byte	32
	.byte	48
	.byte	64
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC1:
	.ascii	"Vectorization test\000"
	.space	1
.LC2:
	.ascii	"Y[%d] = %u\012\000"
.LC3:
	.ascii	"Cb[%d] = %u\012\000"
	.space	3
.LC4:
	.ascii	"Cr[%d] = %u\012\000"
	.ident	"GCC: (GNU Tools for ARM Embedded Processors 6-2017-q1-update) 6.3.1 20170215 (release) [ARM/embedded-6-branch revision 245512]"
