global _read_disk

section .text:
    _read_disk:
        pusha
        push dx

        mov ah, 0x02
        mov al, dh
        mov cl, 0x02
        mov ch, 0x00
        mov dh, 0x00

        int 0x13
        jc disk_error

        pop dx
        cmp al, dh
        jne sectors_error
        popa
        ret


    disk_error:
        push DISK_ERROR
        call _printformat

    sectors_error:
        push SECTORS_ERROR
        call _printformat

    DISK_ERROR: db "Disk read error", 0
    SECTORS_ERROR: db "Incorrect number of sectors read", 0