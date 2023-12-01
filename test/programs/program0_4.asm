	.text
	.file	"grace"
	.globl	_start.main.aux
	.p2align	4, 0x90
	.type	_start.main.aux,@function
_start.main.aux:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	movq	%rsi, 16(%rsp)
	cmpl	$1, (%rsi)
	jne	.LBB0_2
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB0_2:
	.cfi_def_cfa_offset 32
	movq	8(%rsp), %rdi
	callq	_start.main.rec@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	_start.main.aux, .Lfunc_end0-_start.main.aux
	.cfi_endproc

	.globl	_start.main.rec
	.p2align	4, 0x90
	.type	_start.main.rec,@function
_start.main.rec:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	movl	$1, 8(%rdi)
	movq	(%rsp), %rdi
	leaq	8(%rdi), %rsi
	callq	_start.main.aux@PLT
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_start.main.rec, .Lfunc_end1-_start.main.rec
	.cfi_endproc

	.globl	_start.main
	.p2align	4, 0x90
	.type	_start.main,@function
_start.main:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 8(%rsp)
	leaq	8(%rsp), %rdi
	callq	_start.main.rec@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	_start.main, .Lfunc_end2-_start.main
	.cfi_endproc

	.globl	_start
	.p2align	4, 0x90
	.type	_start,@function
_start:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsp, %rdi
	callq	_start.main@PLT
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	_start, .Lfunc_end3-_start
	.cfi_endproc

	.section	".note.GNU-stack","",@progbits
