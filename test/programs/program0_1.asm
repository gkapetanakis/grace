	.text
	.file	"grace"
	.globl	_start.main
	.p2align	4, 0x90
	.type	_start.main,@function
_start.main:
	.cfi_startproc
	movq	%rdi, -8(%rsp)
	retq
.Lfunc_end0:
	.size	_start.main, .Lfunc_end0-_start.main
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
.Lfunc_end1:
	.size	_start, .Lfunc_end1-_start
	.cfi_endproc

	.section	".note.GNU-stack","",@progbits
