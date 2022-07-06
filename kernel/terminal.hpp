#pragma once
#include "io.hpp"
#include "lib/std/datatypes.hpp"

class Terminal
{
private:
    coords _cursor_pos;
    uint16_t* _tty_buffer;

public:
    Terminal(color_t color);

};