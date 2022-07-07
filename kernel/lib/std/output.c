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
    _buf[_offset] = vga_struct(_c, _col);   /*
        Packs char and color and writes it to memory*/
    _offset++ ;
    return _offset;
}

void clear(uint16_t* _tty_buf, color_t _c)
{
    for (uint8_t h = 0; h < VGA_HEIGHT; h++)
        for (uint8_t w = 0; w < VGA_WIDTH; w++)
            print_char(0x20, _c, h * VGA_WIDTH + w, _tty_buf);
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
    if (strlen(_s1) == strlen(_s2))
    {
        uint16_t i = 0;
        while (_s1[i] == _s2[i])    // Char by char comparison
            i++;
        
        if (i == s1_len) /*
            If amount of iterations equals string length
            means strings are equal
        */
            return true;
    }
    return false;
}