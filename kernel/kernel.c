#include "lib/std/io.h"

extern void main()
{
    uint16_t* tty_buffer = (uint16_t*)0xb8000;
    //printformat("Hey! I am writing straight to video memory", 0x0f);
    uint16_t offset = set_cursor_position((coords){10, 1});
    print("Hey!", (color_t){0x0f, 0x00}, offset, tty_buffer);
    //tty_buffer[offset] = vga_struct('C', (color_t){0x0f, 0x00});
    return;
}