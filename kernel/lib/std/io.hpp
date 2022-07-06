#ifndef VGA_TEXT_MODE_H
#define VGA_TEXT_MODE_H

#include "datatypes.hpp"
#include "../../drivers/port_io.hpp"

#define VGA_RESOLUTION  80
#define VGA_HEIGHT      25
#define VGA_WIDTH       80
#define VGA_BASE_ADDR   0xb8000


extern void printformat(const char* _string, uint8_t _color);

extern void print(const char* _string, color_t _color, uint16_t* _tty_buf);

extern uint16_t strlen(const char* _s);

uint8_t color_sum(color_t _color);

extern void clear(color_t _color, uint16_t* _tty_buf);

extern bool set_cursor_position(coords _pos, uint16_t* _tty_buf);

extern uint16_t vga_entry(const char _c, color_t _color);

void set_buffer_position(uint16_t* _tty_buf);

extern void init_vga(uint16_t* _tty_buf, color_t _color);

#endif