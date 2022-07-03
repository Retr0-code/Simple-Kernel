global _gets


section .text:
    ; Get string function
    _gets:
        push bp
        mov bp, sp


        mov si, 0           ; Sets SI to 0 as is is a counter
        mov ah, 0           ; Sets read key-press mode 

        mov bx, [bp+6]      ; Writes address of buffer to BX

        _read_char:         ; Subroutine that reads input
            cmp al, 0x0d    ; If "Enter" pressed
            je _done_gets   ; Exits
            cmp si, [bp+4]  ; If last character was entered
            je _done_gets   ; Exits
            
            int 16h         ; Calls BIOS interuption to read key

            mov ah, 0xe     ; Sets console output mode
            int 10h         ; Calls BIOS output interuption
            mov ah, 0       ; Sets read key-press mode

            mov [bx], al    ; Writes character to buffer
            inc bx          ; Shifts the buffer address
            inc si          ; Incriments the counter
            jmp _read_char  ; Reads next character
            

        _done_gets:
            call _newline   ; Moves cursor to a new line

            pop bp          ; Restores BP
            ret             ; Exits function