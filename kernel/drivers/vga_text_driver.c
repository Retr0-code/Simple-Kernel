#include "vga_text_driver.h"
#include "port_io.h"

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
    return _c.bg << 4 | _c.fg; /*
           0000  | 0000 bits
            BG      FG
    */
}

uint16_t vga_struct(const char _char, color_t _color)
{
    return color_sum(_color) << 8 | _char; /*
    First 8 bits is a color and second bit is a char
    0000 | 0000 | 00000000
    BG      FG      Char
    */
}