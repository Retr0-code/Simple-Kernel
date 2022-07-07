#ifndef VGA_TEXT_DRIVER_H
#define VGA_TEXT_DRIVER_H

#include "../lib/std/datatypes.h"

#define VGA_WIDTH   80
#define VGA_HEIGHT  25

#define VGA_LOW_OFFSET  0x0e
#define VGA_HIGH_OFFSET 0x0f

#define VGA_CTRL_REGISTER   0x3d4
#define VGA_DATA_REGISTER   0x3d5


/*  Set cursor to coordinate _pos
    returns address offset of its position
*/
extern uint16_t set_cursor_position(coords _pos);

/*  Packs character _char and its color _color
    return 16 bit (2 byte) structure to put into VGA memory
*/
extern uint16_t vga_struct(const char _char, color_t _color);

/*  Packs foreground and background _c in 8 bit struct
    return 8 bit struct
*/
uint8_t color_sum(color_t _c);

#endif