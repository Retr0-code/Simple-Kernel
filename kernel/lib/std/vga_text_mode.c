#include "io.h"
#include "../../drivers/port_io.h"

uint16_t set_cursor_position(coords _pos)
{
    uint16_t offset = _pos.y * VGA_WIDTH + _pos.x;  /*
        Calculates offset in vga buffer to set cursor
    */
    if (_pos.x >= 0 && _pos.y >= 0 && offset < 0x7d0)
    {
        pb_out(VGA_CTRL_REGISTER, VGA_HIGH_OFFSET);
        pb_out(VGA_DATA_REGISTER, (uint8_t)(offset));
        pb_out(VGA_CTRL_REGISTER, VGA_LOW_OFFSET);
        pb_out(VGA_DATA_REGISTER, (uint8_t)(offset << 8));
        return offset;
    }
    return 0;
}

uint8_t color_sum(color_t _c)
{
    return _c.bg << 4 | _c.fg;
}

uint16_t vga_struct(const char _char, color_t _color)
{
    return color_sum(_color) << 8 | _char;
}

uint16_t print(
    const char* _s,
    color_t _c,
    uint16_t _offset,
    uint16_t* _tty_buf)
{
    uint16_t index = 0;
    while (_s[index] != 0x00)
    {
        _offset = print_char(_s[index], _c, _offset, _tty_buf);
        index++ ;
    }
}

uint16_t print_char(
    const char _c,
    color_t _col,
    uint16_t _offset,
    uint16_t* _buf)
{
    _buf[_offset] = vga_struct(_c, _col);
    _offset++ ;
}

void clear(uint16_t* _tty_buf, color_t _c)
{
    for (uint8_t h = 0; h < VGA_HEIGHT; h++)
        for (uint8_t w = 0; w < VGA_WIDTH; w++)
            print_char(0x20, _c, h * VGA_WIDTH + w, _tty_buf);
}