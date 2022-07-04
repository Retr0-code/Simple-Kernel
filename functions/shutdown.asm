global _shutdown

section .text:
    _shutdown:
        mov al, 0x01        ; Connect to real mode interface
        mov ah, 0x53        ; Use APM control
        xor bx, bx          ; BX is BIOS id so it set to 0 
        int 15h             ; Use BIOS interruption for additional functions
    
        mov al, 0x0e        ; Set APM version function
        mov ah, 0x53        ; Use APM control
        xor bx, bx          ; BX is BIOS id so it set to 0 
        mov ch, 0x01        ; Set major APM version to 1
        mov cl, 0x02        ; Set minor APM version to 2
        int 15h             ; Use BIOS interruption for additional functions

        mov al, 0x07        ; Set device state function
        mov ah, 0x53        ; Use APM control
        mov bx, 0x0001      ; Select all devices
        mov cx, 0x03        ; Set shutdown mode
        int 15h             ; Use BIOS interruption for additional functions