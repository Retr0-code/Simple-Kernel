#include "lib/std/io.h"

extern void main()
{
    uint16_t* tty_buffer = (uint16_t*)0xb8000;
    fill(tty_buffer, ' ', (color_t){LIGHT_CYAN, BLUE});

    uint16_t offset = 0;

    offset = print("Hey! I like how its done, but I don't understand why it does not work sometimes. Finaly, I fixed it!",
    (color_t){LIGHT_CYAN, BLUE},
    offset,
    tty_buffer);

    set_cursor_position(get_cursor_position(offset));
    return;
}