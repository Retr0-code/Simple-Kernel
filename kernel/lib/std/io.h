#ifndef VGA_TEXT_MODE_H
#define VGA_TEXT_MODE_H

#include "datatypes.h"
#include "../../drivers/port_io.h"
#include "../../drivers/vga_text_driver.h"

enum VGA_COLORS
{
    BLACK,
	BLUE,
	GREEN,
	CYAN,
	RED,
	MAGENTA,
	BROWN,
	LIGHT_GREY,
	DARK_GREY,
	LIGHT_BLUE,
	LIGHT_GREEN,
	LIGHT_CYAN,
	LIGHT_RED,
	LIGHT_MAGENTA,
	LIGHT_BROWN,
	WHITE,
};

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

// Fills screen with specific character
extern void fill(uint16_t* _tty_buf, const char _f, color_t _c);

/*	Calculates string length _s
	returns length of string
*/
extern uint16_t strlen(const char* _s);

/*	Compares string _s1 with string _s2
	return true if _s1 = _s2
*/
extern bool strcmp(const char* _s1, const char* _s2);

#endif