#ifndef VGA_TEXT_MODE_H
#define VGA_TEXT_MODE_H

#include "datatypes.h"
#include "../../drivers/port_io.h"

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

/*  Print string _s with color _c by _offset in _tty_buf
    return offset of buffer after printing
*/
extern uint16_t print(
    const char* _s,
    color_t _c,
    uint16_t _offset,
    uint16_t* _tty_buf);

/*  Print char _c with color _col by _offset in _buf
    return offset of buffer after printing
*/
extern uint16_t print_char(
    const char _c,
    color_t _col,
    uint16_t _offset,
    uint16_t* _buf);

extern void clear(uint16_t* _tty_buf, color_t _c);

#endif