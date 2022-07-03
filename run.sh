#!/bin/bash

nasm -f bin -o boot.bin boot.asm
qemu-system-x86_64 boot.bin
