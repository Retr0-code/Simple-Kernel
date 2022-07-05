#ifndef VGA_TEXT_MODE_H
#define VGA_TEXT_MODE_H

#include "datatypes.h"
#include "../../drivers/port_io.h"

#define VGA_RESOLUTION  80

extern void printformat(const char* _string, uint8_t _color);

extern bool set_cursor_position(coords _pos);

#endif