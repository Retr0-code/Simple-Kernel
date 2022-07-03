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
        

        jmp $                       ; Stops the processor


; Data Section
%include "functions/io.asm"

        msg: db "Hello, There!\nPlease enter your message: ", 0x0 ; Printable string
    
        buffer: times 4 db 0        ; Defines input buffer

        times 510-($-$$) db 0       ; Fills binary with 0 to keep the offset of 512
        dw 0xAA55                   ; Magic Word
