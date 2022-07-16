i386-elf-ld -o build/full_kernel.elf -Ttext 0x1000 build/*.o
qemu-system-i386 -s -S -cdrom OS.iso & i386-elf-gdb -ex "target remote localhost:1234" -ex "symbol-file build/full_kernel.elf"