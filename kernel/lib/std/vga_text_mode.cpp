#include "io.hpp"
#include "../../drivers/port_io.hpp"

uint8_t color_sum(color_t _color)
{
    return (_color.fg << 4) | _color.bg;
}

bool set_cursor_position(coords _pos, uint16_t* _tty_buf)
{
    uint16_t absolute_pos = _pos.y * VGA_RESOLUTION + _pos.x;
    if (absolute_pos < 0x7d0
    && _pos.x >= 0 && _pos.y >= 0)
    {
        pb_out(0x3d4, 0x0f);
        pb_out(0x3d5, (uint8_t)(_pos.x & 0xff));
        pb_out(0x3d4, 0x0e);
        pb_out(0x3d5, (uint8_t)(_pos.y & 0xff));

        _tty_buf = (uint16_t*)(VGA_BASE_ADDR + absolute_pos);

        return true;
     }
     return false;
}

void clear(color_t _color, uint16_t* _tty_buf)
{
    for (uint8_t h = 0; h < VGA_HEIGHT; h++)
    {
        for (uint8_t w = 0; w < VGA_WIDTH; w++)
        {
            const uint16_t index = h * VGA_RESOLUTION + w;
            _tty_buf[index] = vga_entry(' ', _color);
        }
    }
}

uint16_t vga_entry(char _c, color_t _color)
{
    return (uint16_t)color_sum(_color) << 8 | _c;
}

void init_vga(uint16_t* _tty_buf, color_t _color)
{
    _tty_buf = (uint16_t*)VGA_BASE_ADDR;
    set_cursor_position((coords){0, 0}, _tty_buf);
    clear(_color, _tty_buf);
}


void print(const char* _string, color_t _color, uint16_t* _tty_buf)
{
    uint16_t c = 0;
    while (_string[c] != 0)
    {
        _tty_buf[c] = vga_entry(_string[c], _color);
        c++ ;
    }
}