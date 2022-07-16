#include "io.h"
#include "../../drivers/port_io.h"

uint16_t print(
    const char* _s,
    color_t _c,
    uint16_t _offset,
    uint16_t* _tty_buf)
{
    uint16_t index = 0;
    while (_s[index] != 0x00)   // 0 byte is string terminator
    {
        switch (_s[index])
        {
            case '\n':
                _offset = set_cursor_position(
                    (coords){0, _offset / VGA_WIDTH + 1});
                index++ ;
                break;
            case '\r':
                _offset = set_cursor_position(
                    (coords){0, _offset / VGA_WIDTH});
                index++ ;
                break;
            case '\t':
                coords current_pos = get_cursor_position(_offset);
                current_pos.x -= current_pos.x % 4;
                current_pos.x += 4;
                _offset = set_cursor_position(current_pos);
                index++ ;
                break;
            default:
                _offset = print_char(_s[index], _c, _offset, _tty_buf);
                index++ ;
        };
    }
    return _offset;
}

uint16_t print_char(
    const char _c,
    color_t _col,
    uint16_t _offset,
    uint16_t* _buf)
{
    _buf[_offset] = vga_struct(_c, _col);   /*
        Packs char and color and writes it to memory*/
    _offset++ ;
    return _offset;
}

void fill(uint16_t* _tty_buf, const char _f, color_t _c)
{
    for (uint8_t h = 0; h < VGA_HEIGHT; h++)
        for (uint8_t w = 0; w < VGA_WIDTH; w++)
            print_char(_f, _c, h * VGA_WIDTH + w, _tty_buf);
}

uint16_t strlen(const char* _s)
{
    uint16_t len = 0;
    while (_s[len] != 0x00)
        len++ ;
    return len;
}

bool strcmp(const char* _s1, const char* _s2)
{
    uint16_t s1_len = strlen(_s1);  // Length of first string

    if (s1_len == strlen(_s2)) /*
    If length of both strings are equal
    starts character by character comparison*/
        for (uint16_t i = 0; i < s1_len; i++)
            if (_s1[i] != _s2[i])
                return false;

    return true;
}