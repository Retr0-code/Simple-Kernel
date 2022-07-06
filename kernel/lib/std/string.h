#include "io.h"

uint16_t strlen(const char* _s)
{
    uint16_t count = 0;
    while (_s[count] != 0x00)
        count++ ;
    return count;
}

