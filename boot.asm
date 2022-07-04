[bits 16]       ; Defines architecture of bootloader
org 0x7c00      ; Defines general offset


global _start   ; Defines entrypoint

; Code section
section .text:
    _start:
        mov bp, 0x8000              ; Set origin of stack
        push bp
        mov bp, sp

        mov ax, 0x03                ; Clears screen
        int 10h                     ; Use interuption

        push ax                     ; Saves AX to stack
        push bx                     ; Saves BX to stack
        push msg1                   ; Loads message to stack
        call _printformat           ; Prints the message
        pop ax                      ; Recover AX value from stack
        pop bx                      ; Recover BX value from stack

        mov bx, buffer              ; Writes input buffer address to BX
        push ax                     ; Saves AX to stack
        push bx                     ; Saves BX to stack
        push 1                      ; Writes buffer length
        call _gets                  ; Calls _gets
        pop ax                      ; Recover AX value from stack
        pop bx                      ; Recover BX value from stack

        mov ax, [buffer]
        cmp ax, 0x4e
        je _stop

        mov [disk_index], dl        ; Save boot disk to variable
        mov bx, kernel_address      ; Write to BX kernel origin
        mov dh, 1                   ; Read one sectors
        call _read_disk             ; Read 16 bits from disk


        cli                         ; Disables BIOS interupts
        lgdt [GDT_descriptor]       ; Load GDT
        mov eax, cr0                ; Write CR0 value to EAX
        or eax, 1                   ; Change it to one by logical OR
        mov cr0, eax                ; Swap values
        jmp CODE_SEG:_enter_protected_mode

    _stop:
        push msg2
        call _printformat
        call _shutdown


; Data Section
%include "bootloader/io.asm"
%include "bootloader/disk_mng.asm"
%include "bootloader/shutdown.asm"

        msg1: db "Hello, There!\nDo You want to enter 32 bit mode?[Y]/[N](default=Y) \0" ; Printable string
        msg2: db "Goodby!\0"

        buffer: db 'Y'        ; Defines input buffer

        kernel_address: equ 0x1000  ; Kernel origin
        disk_index: db 0            ; Variable to store boot drive index

        CODE_SEG: equ GDT_code - GDT_start
        DATA_SEG: equ GDT_data - GDT_start


; Global Descriptor Table
GDT_start:
    GDT_null:
        dd 0x0
        dd 0x0

    GDT_code:
        dw 0xffff           ; Segment limit (size)
        dw 0x0              ; 8 bit base
        db 0x0              ; 4 bit base
        db 0b10011010
        ; 1 - defines a segment 00 - defines highest privilege 1 - defines code segment
        ; 1 - code segment 0 - disable execution from low privileged segments 1 - readable 0 - access by CPU
        db 0b11001111
        ; 1 - size *= 4096 1 - enable 32 bit memory
        db 0x0

    GDT_data:
        dw 0xffff           ; Segment limit (size)
        dw 0x0              ; 8 bit base
        db 0x0              ; 4 bit base
        db 0b10010010
        ; 1 - defines a segment 00 - defines highest privilege 1 - defines code segment
        ; 0 - data segment 0 - expandable upwords segment 1 - writable
        db 0b11001111
        ; 1 - size *= 4096 1 - enable 32 bit memory
        db 0x0

        GDT_end:

    GDT_descriptor:
        dw GDT_end - GDT_start - 1      ; Size of GDT
        dd GDT_start                    ; Start of GDT

    [bits 32]
    _enter_protected_mode:
        mov al, 'A'
        mov ah, 0x0f
        mov [0xb8000], ax
        jmp $


    times 510-($-$$) db 0       ; Fills binary with 0 to keep the offset of 512
    dw 0xAA55                   ; Magic Word

    times 512 db 'A' ; sector 2 = 512 bytes