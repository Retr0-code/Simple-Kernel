#include "lib/std/io.h"

extern void main()
{
    _printk("Hey! I am writing straight to video memory", 0x0f);
    return;
}