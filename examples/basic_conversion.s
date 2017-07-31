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
	.file	"basic_conversion.c"
	.global	__aeabi_i2d
	.global	__aeabi_dmul
	.global	__aeabi_dadd
	.global	__aeabi_ddiv
	.global	__aeabi_d2f
	.global	__aeabi_fcmpgt
	.global	__aeabi_f2d
	.global	__aeabi_d2uiz
	.global	__aeabi_fdiv
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
	@ args = 8, pretend = 0, frame = 64
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, fp, lr}
	add	fp, sp, #20
	sub	sp, sp, #64
	str	r0, [fp, #-72]
	str	r1, [fp, #-76]
	str	r2, [fp, #-80]
	str	r3, [fp, #-84]
	mov	r3, #0
	str	r3, [fp, #-24]
	mov	r3, #0
	str	r3, [fp, #-32]
	ldr	r2, [fp, #8]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	str	r3, [fp, #-36]
	mov	r3, #0
	str	r3, [fp, #-40]
	mov	r3, #0
	str	r3, [fp, #-44]
	b	.L2
.L17:
	mov	r3, #0
	str	r3, [fp, #-28]
	b	.L3
.L16:
	.syntax divided
@ 30 "basic_conversion.c" 1
	NOP
@ 0 "" 2
	.arm
	.syntax unified
	ldr	r3, [fp, #-32]
	add	r2, r3, #1
	str	r2, [fp, #-32]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-45]
	ldr	r3, [fp, #-32]
	add	r2, r3, #1
	str	r2, [fp, #-32]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-46]
	ldr	r3, [fp, #-32]
	add	r2, r3, #1
	str	r2, [fp, #-32]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-47]
	ldrb	r3, [fp, #-45]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L26
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-46]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L26+8
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-47]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L26+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L26+24
	bl	__aeabi_ddiv
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L26+28
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-52]	@ float
	ldr	r2, [fp, #-72]
	ldr	r3, [fp, #-44]
	add	r4, r2, r3
	ldr	r1, .L26+32
	ldr	r0, [fp, #-52]	@ float
	bl	__aeabi_fcmpgt
	mov	r3, r0
	cmp	r3, #0
	beq	.L22
	mov	r2, #0
	ldr	r3, .L26+36
	b	.L6
.L27:
	.align	3
.L26:
	.word	1683627180
	.word	1079013179
	.word	4054449127
	.word	1080041938
	.word	1305670058
	.word	1077481570
	.word	1081081856
	.word	1076887552
	.word	1132396544
	.word	1081073664
.L22:
	ldr	r0, [fp, #-52]	@ float
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
.L6:
	mov	r0, r2
	mov	r1, r3
	bl	round
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	__aeabi_d2uiz
	mov	r3, r0
	and	r3, r3, #255
	strb	r3, [r4]
	ldrb	r3, [fp, #-45]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-46]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+8
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-47]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-56]	@ float
	ldrb	r3, [fp, #-45]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-46]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+24
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-47]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+32
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-60]	@ float
	ldr	r3, [fp, #-36]
	add	r2, r3, #1
	str	r2, [fp, #-36]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-61]
	ldr	r3, [fp, #-36]
	add	r2, r3, #1
	str	r2, [fp, #-36]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-62]
	ldr	r3, [fp, #-36]
	add	r2, r3, #1
	str	r2, [fp, #-36]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-63]
	ldrb	r3, [fp, #-61]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+40
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-62]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+48
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-63]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L28+56
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L28+64
	bl	__aeabi_ddiv
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L28+68
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-68]	@ float
	ldr	r2, [fp, #-44]
	ldr	r3, [fp, #8]
	add	r3, r2, r3
	ldr	r2, [fp, #-72]
	add	r4, r2, r3
	ldr	r1, .L28+72
	ldr	r0, [fp, #-52]	@ float
	bl	__aeabi_fcmpgt
	mov	r3, r0
	cmp	r3, #0
	beq	.L23
	mov	r2, #0
	ldr	r3, .L28+76
	b	.L9
.L29:
	.align	3
.L28:
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
	.word	1683627180
	.word	1079013179
	.word	4054449127
	.word	1080041938
	.word	1305670058
	.word	1077481570
	.word	1081081856
	.word	1076887552
	.word	1132396544
	.word	1081073664
.L23:
	ldr	r0, [fp, #-68]	@ float
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
.L9:
	mov	r0, r2
	mov	r1, r3
	bl	round
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	__aeabi_d2uiz
	mov	r3, r0
	and	r3, r3, #255
	strb	r3, [r4]
	ldr	r0, [fp, #-56]	@ float
	bl	__aeabi_f2d
	mov	r4, r0
	mov	r5, r1
	ldrb	r3, [fp, #-61]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-62]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+8
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-63]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-56]	@ float
	ldr	r0, [fp, #-60]	@ float
	bl	__aeabi_f2d
	mov	r4, r0
	mov	r5, r1
	ldrb	r3, [fp, #-61]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-62]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+24
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-63]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+32
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-60]	@ float
	ldr	r3, [fp, #-44]
	add	r3, r3, #1
	str	r3, [fp, #-44]
	ldr	r3, [fp, #-28]
	add	r3, r3, #1
	str	r3, [fp, #-28]
	ldr	r3, [fp, #-32]
	add	r2, r3, #1
	str	r2, [fp, #-32]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-45]
	ldr	r3, [fp, #-32]
	add	r2, r3, #1
	str	r2, [fp, #-32]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-46]
	ldr	r3, [fp, #-32]
	add	r2, r3, #1
	str	r2, [fp, #-32]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-47]
	ldrb	r3, [fp, #-45]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+40
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-46]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+48
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-47]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L30+56
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L30+64
	bl	__aeabi_ddiv
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L30+68
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-52]	@ float
	ldr	r2, [fp, #-72]
	ldr	r3, [fp, #-44]
	add	r4, r2, r3
	ldr	r1, .L30+72
	ldr	r0, [fp, #-52]	@ float
	bl	__aeabi_fcmpgt
	mov	r3, r0
	cmp	r3, #0
	beq	.L24
	mov	r2, #0
	ldr	r3, .L30+76
	b	.L12
.L31:
	.align	3
.L30:
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
	.word	1683627180
	.word	1079013179
	.word	4054449127
	.word	1080041938
	.word	1305670058
	.word	1077481570
	.word	1081081856
	.word	1076887552
	.word	1132396544
	.word	1081073664
.L24:
	ldr	r0, [fp, #-52]	@ float
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
.L12:
	mov	r0, r2
	mov	r1, r3
	bl	round
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	__aeabi_d2uiz
	mov	r3, r0
	and	r3, r3, #255
	strb	r3, [r4]
	ldr	r0, [fp, #-56]	@ float
	bl	__aeabi_f2d
	mov	r4, r0
	mov	r5, r1
	ldrb	r3, [fp, #-45]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-46]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+8
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-47]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-56]	@ float
	ldr	r0, [fp, #-60]	@ float
	bl	__aeabi_f2d
	mov	r4, r0
	mov	r5, r1
	ldrb	r3, [fp, #-45]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-46]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+24
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-47]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+32
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-60]	@ float
	ldr	r3, [fp, #-36]
	add	r2, r3, #1
	str	r2, [fp, #-36]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-61]
	ldr	r3, [fp, #-36]
	add	r2, r3, #1
	str	r2, [fp, #-36]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-62]
	ldr	r3, [fp, #-36]
	add	r2, r3, #1
	str	r2, [fp, #-36]
	ldr	r2, [fp, #-84]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-63]
	ldrb	r3, [fp, #-61]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+40
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-62]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+48
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r5, r4
	mov	r4, r3
	ldrb	r3, [fp, #-63]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L32+56
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L32+64
	bl	__aeabi_ddiv
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	mov	r2, #0
	ldr	r3, .L32+68
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-68]	@ float
	ldr	r2, [fp, #-44]
	ldr	r3, [fp, #8]
	add	r3, r2, r3
	ldr	r2, [fp, #-72]
	add	r4, r2, r3
	ldr	r1, .L32+72
	ldr	r0, [fp, #-68]	@ float
	bl	__aeabi_fcmpgt
	mov	r3, r0
	cmp	r3, #0
	beq	.L25
	mov	r2, #0
	ldr	r3, .L32+76
	b	.L15
.L33:
	.align	3
.L32:
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
	.word	1683627180
	.word	1079013179
	.word	4054449127
	.word	1080041938
	.word	1305670058
	.word	1077481570
	.word	1081081856
	.word	1076887552
	.word	1132396544
	.word	1081073664
.L25:
	ldr	r0, [fp, #-68]	@ float
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
.L15:
	mov	r0, r2
	mov	r1, r3
	bl	round
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	__aeabi_d2uiz
	mov	r3, r0
	and	r3, r3, #255
	strb	r3, [r4]
	ldr	r0, [fp, #-56]	@ float
	bl	__aeabi_f2d
	mov	r4, r0
	mov	r5, r1
	ldrb	r3, [fp, #-61]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L34
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-62]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L34+8
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-63]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L34+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-56]	@ float
	ldr	r0, [fp, #-60]	@ float
	bl	__aeabi_f2d
	mov	r4, r0
	mov	r5, r1
	ldrb	r3, [fp, #-61]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L34+16
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-62]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L34+24
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r6, r2
	mov	r7, r3
	ldrb	r3, [fp, #-63]	@ zero_extendqisi2
	mov	r0, r3
	bl	__aeabi_i2d
	adr	r3, .L34+32
	ldmia	r3, {r2-r3}
	bl	__aeabi_dmul
	mov	r2, r0
	mov	r3, r1
	mov	r0, r6
	mov	r1, r7
	bl	__aeabi_dadd
	mov	r2, r0
	mov	r3, r1
	mov	r0, r4
	mov	r1, r5
	bl	__aeabi_dadd
	mov	r3, r0
	mov	r4, r1
	mov	r0, r3
	mov	r1, r4
	bl	__aeabi_d2f
	mov	r3, r0
	str	r3, [fp, #-60]	@ float
	ldr	r2, [fp, #-76]
	ldr	r3, [fp, #-40]
	add	r4, r2, r3
	ldr	r1, .L34+40
	ldr	r0, [fp, #-56]	@ float
	bl	__aeabi_fdiv
	mov	r3, r0
	mov	r1, #1140850688
	mov	r0, r3
	bl	__aeabi_fadd
	mov	r3, r0
	ldr	r1, .L34+44
	mov	r0, r3
	bl	__aeabi_fdiv
	mov	r3, r0
	mov	r0, r3
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	round
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	__aeabi_d2uiz
	mov	r3, r0
	and	r3, r3, #255
	strb	r3, [r4]
	ldr	r2, [fp, #-80]
	ldr	r3, [fp, #-40]
	add	r4, r2, r3
	ldr	r1, .L34+40
	ldr	r0, [fp, #-60]	@ float
	bl	__aeabi_fdiv
	mov	r3, r0
	mov	r1, #1140850688
	mov	r0, r3
	bl	__aeabi_fadd
	mov	r3, r0
	ldr	r1, .L34+44
	mov	r0, r3
	bl	__aeabi_fdiv
	mov	r3, r0
	mov	r0, r3
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	round
	mov	r2, r0
	mov	r3, r1
	mov	r0, r2
	mov	r1, r3
	bl	__aeabi_d2uiz
	mov	r3, r0
	and	r3, r3, #255
	strb	r3, [r4]
	ldr	r3, [fp, #-40]
	add	r3, r3, #1
	str	r3, [fp, #-40]
	ldr	r3, [fp, #-44]
	add	r3, r3, #1
	str	r3, [fp, #-44]
	ldr	r3, [fp, #-28]
	add	r3, r3, #1
	str	r3, [fp, #-28]
.L3:
	ldr	r2, [fp, #-28]
	ldr	r3, [fp, #8]
	cmp	r2, r3
	bcc	.L16
	ldr	r3, [fp, #-24]
	add	r3, r3, #2
	str	r3, [fp, #-24]
	ldr	r2, [fp, #8]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	ldr	r2, [fp, #-32]
	add	r3, r2, r3
	str	r3, [fp, #-32]
	ldr	r2, [fp, #8]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	ldr	r2, [fp, #-36]
	add	r3, r2, r3
	str	r3, [fp, #-36]
	ldr	r2, [fp, #-44]
	ldr	r3, [fp, #8]
	add	r3, r2, r3
	str	r3, [fp, #-44]
.L2:
	ldr	r2, [fp, #-24]
	ldr	r3, [fp, #4]
	cmp	r2, r3
	bcc	.L17
	nop
	sub	sp, fp, #20
	@ sp needed
	pop	{r4, r5, r6, r7, fp, lr}
	bx	lr
.L35:
	.align	3
.L34:
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
	.word	1132462080
	.word	1082130432
	.size	add_ints, .-add_ints
	.section	.rodata
	.align	2
.LC1:
	.ascii	"Vectorization test\000"
	.align	2
.LC2:
	.ascii	"Y[%d] = %u\012\000"
	.align	2
.LC3:
	.ascii	"Cb[%d] = %u\012\000"
	.align	2
.LC4:
	.ascii	"Cr[%d] = %u\012\000"
	.align	2
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
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu softvfp
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 96
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #104
	str	r0, [fp, #-96]
	str	r1, [fp, #-100]
	ldr	r0, .L44
	bl	puts
	mov	r3, #4
	str	r3, [fp, #-12]
	mov	r3, #4
	str	r3, [fp, #-16]
	ldr	r3, .L44+4
	sub	ip, fp, #64
	mov	lr, r3
	ldmia	lr!, {r0, r1, r2, r3}
	stmia	ip!, {r0, r1, r2, r3}
	ldmia	lr!, {r0, r1, r2, r3}
	stmia	ip!, {r0, r1, r2, r3}
	ldm	lr, {r0, r1, r2, r3}
	stm	ip, {r0, r1, r2, r3}
	sub	ip, fp, #64
	sub	r2, fp, #88
	sub	r1, fp, #84
	sub	r0, fp, #80
	ldr	r3, [fp, #-16]
	str	r3, [sp, #4]
	ldr	r3, [fp, #-12]
	str	r3, [sp]
	mov	r3, ip
	bl	add_ints
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L37
.L38:
	sub	r2, fp, #80
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r1, [fp, #-8]
	ldr	r0, .L44+8
	bl	printf
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L37:
	ldr	r3, [fp, #-8]
	cmp	r3, #15
	ble	.L38
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L39
.L40:
	sub	r2, fp, #84
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r1, [fp, #-8]
	ldr	r0, .L44+12
	bl	printf
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L39:
	ldr	r3, [fp, #-8]
	cmp	r3, #3
	ble	.L40
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L41
.L42:
	sub	r2, fp, #88
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r1, [fp, #-8]
	ldr	r0, .L44+16
	bl	printf
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L41:
	ldr	r3, [fp, #-8]
	cmp	r3, #3
	ble	.L42
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, lr}
	bx	lr
.L45:
	.align	2
.L44:
	.word	.LC1
	.word	.LC0
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.size	main, .-main
	.ident	"GCC: (GNU Tools for ARM Embedded Processors 6-2017-q1-update) 6.3.1 20170215 (release) [ARM/embedded-6-branch revision 245512]"
