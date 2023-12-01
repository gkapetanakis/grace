	.text
	.file	"grace"
	.globl	_start.doSomething
	.p2align	4, 0x90
	.type	_start.doSomething,@function
_start.doSomething:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	movl	$".LHello world\n\n", %edi
	callq	writeString@PLT
	popq	%rax
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	_start.doSomething, .Lfunc_end0-_start.doSomething
	.cfi_endproc

	.globl	_start
	.p2align	4, 0x90
	.type	_start,@function
_start:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rsp, %rdi
	callq	_start.doSomething@PLT
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	_start, .Lfunc_end1-_start
	.cfi_endproc

	.type	".LHello world\n\n",@object
	.section	.rodata.str1.1,"aMS",@progbits,1
".LHello world\n\n":
	.asciz	"Hello world\n\n"
	.size	".LHello world\n\n", 14

	.section	".note.GNU-stack","",@progbits
