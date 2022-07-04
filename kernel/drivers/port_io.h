#ifndef PORT_IO_H
#define PORT_IO_H

#include "../lib/std/datatypes.h"

void pb_out(uint16_t port, uint8_t data);
void pw_out(uint16_t port, uint16_t data);
void pd_out(uint16_t port, uint32_t data);

uint8_t pb_in(uint16_t port);
uint16_t pw_in(uint16_t port);
uint32_t pd_in(uint16_t port);

#endif