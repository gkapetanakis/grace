	.text
	.file	"grace"
	.globl	main.doSomething
	.p2align	2
	.type	main.doSomething,@function
main.doSomething:
	.cfi_startproc
	sub	sp, sp, #48
	stp	x30, x19, [sp, #32]
	.cfi_def_cfa_offset 48
	.cfi_offset w19, -8
	.cfi_offset w30, -16
	str	x0, [sp]
	bl	readChar
	strb	w0, [sp, #8]
	bl	readInteger
	mov	x8, sp
	str	w0, [sp, #12]
	add	x19, x8, #16
	mov	w0, #10
	mov	x1, x19
	bl	readString
	ldrb	w0, [sp, #8]
	bl	writeChar
	mov	w0, #10
	bl	writeChar
	ldr	w0, [sp, #12]
	bl	writeInteger
	mov	w0, #10
	bl	writeChar
	mov	x0, x19
	bl	writeString
	mov	w0, #10
	bl	writeChar
	ldp	x30, x19, [sp, #32]
	add	sp, sp, #48
	ret
.Lfunc_end0:
	.size	main.doSomething, .Lfunc_end0-main.doSomething
	.cfi_endproc

	.globl	main
	.p2align	2
	.type	main,@function
main:
	.cfi_startproc
	str	x30, [sp, #-16]!
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	add	x0, sp, #8
	bl	main.doSomething
	mov	w0, wzr
	ldr	x30, [sp], #16
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc

	.section	".note.GNU-stack","",@progbits
