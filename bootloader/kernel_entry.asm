[bits 32]

extern main
global _load_kernel

section .text:
    _load_kernel:
        call main
        jmp $