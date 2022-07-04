#!/bin/bash

nasm -f bin -o build/boot.bin boot.asm
nasm -f bin -o build/zeroes.bin bootloader/zeroes.asm
nasm -f elf -o build/kernel_entry.o bootloader/kernel_entry.asm
i386-elf-gcc -ffreestanding -m32 -g -c kernel/kernel.c -o build/kernel.o

i386-elf-ld -o build/full_kernel.bin -Ttext 0x1000 build/kernel_entry.o build/kernel.o --oformat binary

cat build/boot.bin build/full_kernel.bin build/zeroes.bin > build/OS.bin

qemu-system-x86_64 -drive format=raw,file="build/OS.bin",index=0,if=floppy, -m 128M