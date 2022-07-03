global _gets


section .text:
    _gets:
        push bp
        mov bp, sp


        mov si, 0
        mov ah, 0

        mov bx, [bp+6]

        _read_char:
            cmp al, 0x0d
            je _done_gets
            cmp si, [bp+4]
            je _done_gets
            
            int 16h

            mov ah, 0xe
            int 10h
            mov ah, 0

            mov [bx], al
            inc bx
            inc si
            jmp _read_char
            

        _done_gets:
            mov ah, 0xe
            mov al, 0x0a
            int 10h
            mov al, 0x0d
            int 10h
            mov ah, 0

            pop bp
            ret