bits 16         ; Defines architecture of bootloader
org 0x7c00      ; Defines general offset


global _start   ; Defines entrypoint

; Code section
section .text:
    _start:
        mov bp, 0x8000
        push bp
        mov bp, sp

        mov ax, 0x03                ; Clears screen
        int 10h                     ; Use interuption

        push ax
        push bx
        push msg
        call _printformat          ; Prints the message
        pop ax
        pop bx

        mov bx, buffer
        push ax
        push bx
        push 4
        call _gets
        pop ax
        pop bx

        push ax
        push bx
        push buffer
        call _printformat          ; Prints the buffer
        pop ax
        pop bx
        

        jmp $                       ; Stops the processor


; Data Section
%include "functions/io.asm"

        msg: db "Hello, There!\nPlease enter your message: ", 0x0 ; Printable string
    
        buffer: times 4 db 0        ; Defines input driver

        times 510-($-$$) db 0       ; Fills binary with 0 to keep the offset of 512
        dw 0xAA55                   ; Magic Word
