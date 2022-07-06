#include "port_io.hpp"

// Send byte
void pb_out(uint16_t port, uint8_t data)
{
    __asm__("outb %%al, %%dx" : : "a"(data), "d"(port));
	return;
}

// Send word
void pw_out(uint16_t port, uint16_t data)
{
    __asm__("outw %%ax, %%dx" : : "a"(data), "d"(port));
	return;
}

// Send dword
void pd_out(uint16_t port, uint32_t data)
{
    __asm__("outl %%eax, %%edx" : : "a"(data), "d"(port));
	return;
}

// Receive byte
uint8_t pb_in(uint16_t port)
{
    uint8_t result = 0;
    __asm__("inb %%dx, %%al" : "=a"(result) : "d"(port));
    return result;
}

// Receive word
uint16_t pw_in(uint16_t port)
{
    uint16_t result = 0;
    __asm__("inw %%dx, %%ax" : "=a"(result) : "d"(port));
    return result;
}

// Receive dword
uint32_t pd_in(uint16_t port)
{
    uint32_t result = 0;
    __asm__("inl %%edx, %%eax" : "=a"(result) : "d"(port));
    return result;
}