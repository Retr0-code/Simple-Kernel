#include "io.h"
#include "../../drivers/port_io.h"

uint16_t set_cursor_position(coords _pos)
{
    uint16_t offset = _pos.y * VGA_RESOLUTION + _pos.x;
    if (_pos.x >= 0 && _pos.y >= 0 && offset < 0x7d0)
    {
        pb_out(0x3d4, 0x0f);
        pb_out(0x3d5, (uint8_t)(offset));
        pb_out(0x3d4, 0x0e);
        pb_out(0x3d5, (uint8_t)(offset << 8));
        return offset;
    }
    return offset;
}

uint8_t color_sum(color_t _c)
{
    return _c.bg << 4 | _c.fg;
}

uint16_t vga_struct(const char _char, color_t _color)
{
    return color_sum(_color) << 8 | _char;
}

void print(
    const char* _s,
    color_t _c,
    uint16_t _offset,
    uint16_t* _tty_buf)
{
    uint16_t index = 0;
    while (_s[index] != 0x00)
    {
        print_char(_s[index], _c, _offset, _tty_buf);
        index++ ;
    }
}

void print_char(
    const char _c,
    color_t _col,
    uint16_t _offset,
    uint16_t* _buf)
{
    _buf[_offset] = vga_struct(_c, _col);
    _offset += 2;
}