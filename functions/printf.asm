global _printf

section .text:
    _printformat:
        push bp
        mov bp, sp

        mov ah, 0xe                 ; Enables console character output (TTY)

        mov bx, [bp+4]              ; Write buffer address to BX

        _print_next_char:           ; Printing subroutine label
            mov al, [bx]            ; Writes character from address that stores in BX to AL
        
        _format_check:
            cmp al, 0x0             ; Compares AL to 0 (0 is end of a string)
            je _done_printf         ; If equals exits
            cmp al, 0x5c            ; If equals '\'
            je _format              ; Start format
            
            int 10h                 ; Else draws a char
            inc bx                  ; Increment BX (Switches to address of next character)
            jmp _print_next_char    ; Repeats this until the end of string

        _done_printf:
            pop bp                  ; Recovers BP value
            ret                     ; Returns from function

    ; Moves cursor to new line
    _newline:
        pusha                       ; Retrieves registers from the stack
        
        mov ah, 0x0e                ; Enables console char output (TTY)
        mov al, 0x0a                ; 0x0A = '\n'
        int 0x10                    ; Call the interuption
        mov al, 0x0d                ; 0x0D = '\r'
        int 0x10                    ; Call the interuption
        
        popa                        ; Pops registers 
        ret                         ; Returns from function

    ; Manages formats
    _format:
        
        inc bx                      ; Incriments BX
        mov al, [bx]                ; Moves addresses value to AL
        
        cmp al, 0x6e                ; If character is 'n'
        call _newline                 ; Call new line
        cmp al, 0x30                ; If character is '0'
        je _done_printf             ; Exits if was \0
        
        inc bx                      ; Incriment BX
        jmp _print_next_char        ; Jump to next char