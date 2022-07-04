[bits 32]

global _printk

VIDEO_MEMORY: equ 0xb8000           ; Begining of video memory

section .text:
    _printk:
        push ebp
        mov ebp, esp

        mov edx, VIDEO_MEMORY       ; Saves address to EDX

        mov ebx, [ebp+8]             ; Write buffer address to EBX
        mov ah, [ebp+12]            ; Writes color to AX

        _print_next_char:           ; Printing subroutine label
            mov al, [ebx]           ; Writes character from address that stores in BX to AL
        
        _format_check:
            cmp al, 0x0             ; Compares AL to 0 (0 is end of a string)
            je _done_printf         ; If equals exits
            
            mov [edx], ax           ; Else draws a char
            inc ebx                 ; Increment EBX (Switches to address of next character)
            add edx, 2              ; Switch to next position in video memory
            jmp _print_next_char    ; Repeats this until the end of string

        _done_printf:
            pop ebp                 ; Recovers EBP value
            ret                     ; Returns from function