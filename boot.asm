bits 16         ; Defines architecture of bootloader
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
        push msg                    ; Loads message to stack
        call _printformat           ; Prints the message
        pop ax                      ; Recover AX value from stack
        pop bx                      ; Recover BX value from stack

        mov bx, buffer              ; Writes input buffer address to BX
        push ax                     ; Saves AX to stack
        push bx                     ; Saves BX to stack
        push 4                      ; Writes buffer length
        call _gets                  ; Calls _gets
        pop ax                      ; Recover AX value from stack
        pop bx                      ; Recover BX value from stack

        push ax                     ; Saves AX to stack
        push bx                     ; Saves BX to stack
        push buffer                 ; Loads input buffer to stack
        call _printformat           ; Prints the buffer
        pop ax                      ; Recover AX value from stack
        pop bx                      ; Recover BX value from stack
        
        mov [disk_index], dl        ; Save boot disk to variable
        mov bx, kernel_address      ; Write to BX kernel origin
        mov dh, 2                   ; Read two sectors
        call _read_disk             ; Read 16 bits from disk

        jmp $                       ; Stops the processor


; Data Section
%include "functions/io.asm"
%include "functions/disk_mng.asm"

        msg: db "Hello, There!\nPlease enter your message: \0" ; Printable string
    
        buffer: times 4 db 0        ; Defines input buffer

        kernel_address: equ 0x1000  ; Kernel origin
        disk_index: db 0            ; Variable to store boot drive index

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

    times 510-($-$$) db 0       ; Fills binary with 0 to keep the offset of 512
    dw 0xAA55                   ; Magic Word
    times 512 db 'A' ; sector 2 = 512 bytes
    times 512 db 'B' ; sector 3 = 512 bytes