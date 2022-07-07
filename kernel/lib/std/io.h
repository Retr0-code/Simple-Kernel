#ifndef VGA_TEXT_MODE_H
#define VGA_TEXT_MODE_H

#include "datatypes.h"
#include "../../drivers/port_io.h"

#define VGA_RESOLUTION  80

extern void printformat(const char* _string, uint8_t _color);

extern uint16_t set_cursor_position(coords _pos);

extern uint16_t vga_struct(const char _char, color_t _color);

uint8_t color_sum(color_t _c);

extern void print(
    const char* _s,
    color_t _c,
    uint16_t _offset,
    uint16_t* _tty_buf);

void print_char(
    const char _c,
    color_t _col,
    uint16_t _offset,
    uint16_t* _buf);

#endif