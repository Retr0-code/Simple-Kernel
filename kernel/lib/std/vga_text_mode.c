#include "io.h"
#include "../../drivers/port_io.h"

bool set_cursor_position(coords _pos)
{
    if (_pos.x >= 0 && _pos.y && _pos.y <= 78 && _pos.x <= 208)
    {
        pb_out(0x3d4, 0x0f);
        pb_out(0x3d5, _pos.x & 0xff);
        pb_out(0x3d4, 0x0e);
        pb_out(0x3d5, _pos.y & 0xff);
        return true;
    }
    return false;
}