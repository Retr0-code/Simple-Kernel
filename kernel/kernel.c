#include "lib/std/io.h"

extern void main()
{
    uint16_t* tty_buffer = (uint16_t*)0xb8000;
    clear(tty_buffer, (color_t){CYAN, BLUE});
    coords center = {
        VGA_WIDTH / 2 - 2,
        VGA_HEIGHT / 2 - 1
    };

    uint16_t offset = set_cursor_position(center);
    
    offset = print("Hey!", (color_t){CYAN, BLUE}, offset, tty_buffer);
    set_cursor_position((coords){0, 0});
    return;
}