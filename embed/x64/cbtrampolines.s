.text

.global sbx_cbtrampoline
sbx_cbtrampoline:
	// Entrypoint for callbacks. Callback target is in %r10.
	movq lfi_myproc@gottpoff(%rip), %r11
	movq %fs:(%r11), %r11
	xchg 0(%r11), %rsp

	callq *%r10

	// restore %rsp
	movq lfi_myproc@gottpoff(%rip), %r11
	movq %fs:(%r11), %r11
	xchg 0(%r11), %rsp

	// return back to sandbox

// This pop instruction could segfault if the sandbox has provided a bad stack.
userpop:
	popq %r11
	// TODO: different sequence for large sandboxes is needed
	andl $0xffffffe0, %r11d
	orq %r14, %r11
	jmpq *%r11
