global _read_disk

section .text:
    _read_disk:
        pusha               ; Push registers
        push dx             ; Save dx to the stack

        mov ah, 0x02        ; Enable disk reading
        mov al, dh          ; Amount sectors to read
        mov cl, 0x02        ; Read from second sector
        mov ch, 0x00        ; Cylinder to read from
        mov dh, 0x00        ; Head that read

        int 0x13            ; BIOS interupt to read data
        jc disk_error       ; If carry is set raise an error

        pop dx              ; Recover DX from stack
        cmp al, dh          ; Check amount of readen sectors
        jne sectors_error   ; If they are not equal raise an error
        popa                ; Recover registers
        ret                 ; Exit the function


    disk_error:
        push DISK_ERROR
        call _printformat

    sectors_error:
        push SECTORS_ERROR
        call _printformat

    DISK_ERROR: db "Disk read error", 0
    SECTORS_ERROR: db "Incorrect number of sectors read", 0