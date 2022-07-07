#!/bin/bash

# Parse arguments
POSITIONAL_ARGS=()

Usage()
{
	echo -e "Usage:\t./run.sh binutils-prefix ... i386-prefix ..."
    echo -e "\t./run.sh bp ... ip ...\n"
    echo -e "\tbinutils-prefix\t\tbp\tPath to cross compiled binutils"
    echo -e "\ti386-prefix\t\tip\tPath to cross compiled GCC i386 elf"

}

while [[ $# -gt 0 ]]; do
	case $1 in
    bp | binutils-prefix)
		BIN_PREFIX="$2"
		shift
		shift
		;;
	ip | i386-prefix)
		GCC_PREFIX="$2"
		shift
		shift
		;;
	help)
		Usage
		shift
		;;
	*)
		echo "Unknown option $1"
		exit 1
		;;
	*)
		POSITIONAL_ARGS+=("$1")
		shift
		;;
	esac
done

# Compile OS

if [[ -z "$GCC_PREFIX" ]] || [[ -z "$BIN_PREFIX" ]] ; then
	Usage
	exit 2
fi

/usr/bin/nasm -f bin -o build/boot.bin boot.asm
if [ $? != 0 ] ; then
	echo "E: Bootloader compilation failed"
	exit 3
fi

/usr/bin/nasm -f bin -o build/zeroes.bin bootloader/zeroes.asm
if [ $? != 0 ] ; then
	echo "E: Zeroes offset compilation failed"
	exit 3
fi

/usr/bin/nasm -f elf -o build/kernel_entry.o bootloader/kernel_entry.asm
if [ $? != 0 ] ; then
	echo "E: Kernel entry compilation failed"
	exit 3
fi

drivers_asm=`/bin/ls kernel/drivers/*.asm`
if [ $? == 0 ] ; then
	for driver_asm in $drivers_asm
	do
		/usr/bin/nasm -f elf -o build/$(basename $driver_asm.o) kernel/drivers/$(basename $driver_asm)
		if [ $? != 0 ] ; then
			echo "E: Driver $driver_asm compilation failed"
			exit 3
		fi
	done
fi

drivers_c=`/bin/ls kernel/drivers/*.c`
if [ $? == 0 ] ; then
	for driver_c in $drivers_c
	do
		$GCC_PREFIX/i386-elf-gcc -ffreestanding -m32 -g -c kernel/drivers/$(basename $driver_c)  -o build/$(basename $driver_c.o)
		if [ $? != 0 ] ; then
			echo "E: Driver $driver_c compilation failed"
			exit 3
		fi
	done
fi

libs_asm=`/bin/ls kernel/lib/std/*.asm`
if [ $? == 0 ] ; then
	for lib_asm in $libs_asm
	do
		/usr/bin/nasm -f elf -o build/$(basename $lib_asm.o) kernel/lib/std/$(basename $lib_asm)
		if [ $? != 0 ] ; then
			echo "E: Library $lib_asm compilation failed"
			exit 4
		fi
	done
fi

libs_c=`/bin/ls kernel/lib/std/*.c`
if [ $? == 0 ] ; then
	for lib_c in $libs_c
	do
		$GCC_PREFIX/i386-elf-gcc -ffreestanding -m32 -g -c kernel/lib/std/$(basename $lib_c) -o build/$(basename $lib_c.o)
		if [ $? != 0 ] ; then
			echo "E: Library $lib_c compilation failed"
			exit 4
		fi
	done
fi

$GCC_PREFIX/i386-elf-gcc -ffreestanding -m32 -g -c kernel/kernel.c -o build/kernel.o
if [ $? != 0 ] ; then
	echo "E: Kernel compilation failed"
	exit 5
fi

$BIN_PREFIX/i386-elf-ld -o build/full_kernel.bin -Ttext 0x1000 build/*.o --oformat binary
if [ $? != 0 ] ; then
	echo "E: Linking failed"
	exit 6
fi

/bin/cat build/boot.bin build/full_kernel.bin build/zeroes.bin > build/OS.bin
if [ $? != 0 ] ; then
	echo "E: Kernel packing failed"
	exit 7
fi

/bin/dd if=/dev/zero of=iso/floppy.img bs=1024 count=1440
/bin/dd if=build/OS.bin of=iso/floppy.img seek=0 count=20 conv=notrunc
/usr/bin/genisoimage -quiet -V 'SK-OS' -input-charset iso8859-1 -o OS.iso -b floppy.img -hide floppy.img iso/

# Uncomment this to run straight raw binary kernel
# /usr/bin/qemu-system-x86_64 -drive format=raw,file="build/OS.bin",index=0,if=floppy, -m 128M
/usr/bin/qemu-system-i386 -cdrom OS.iso