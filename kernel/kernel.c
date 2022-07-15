#include "lib/std/io.h"

extern void main()
{
    uint16_t* tty_buffer = (uint16_t*)0xb8000;
    clear(tty_buffer, (color_t){CYAN, BLUE});

    uint16_t offset = 0;

    const char* string = "Hey! I like how its done, but I don't understand why it does not work sometimes.";
    offset = print(string, (color_t){CYAN, BLUE}, offset, tty_buffer);

    set_cursor_position((coords){0, 0});
    return;
}