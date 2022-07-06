#include "lib/std/io.h"

extern void main()
{
    printformat("Hey! I am writing straight to video memory", 0x0f);
    coords pos = {10, 0};
    set_cursor_position(pos);
    while (1) {};
    return;
}