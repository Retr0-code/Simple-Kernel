#include "lib/std/io.hpp"
#include "lib/std/terminal_colors.hpp"

extern void main()
{
    uint16_t* vga_output_buffer = (uint16_t*)VGA_BASE_ADDR;
    init_vga(vga_output_buffer, (color_t){O_BLK, O_WHT});
    print("Hey! I am writing straight to video memory", (color_t){O_BLK, O_WHT}, vga_output_buffer);

    set_cursor_position((coords){0, 1}, vga_output_buffer);
    return;
}