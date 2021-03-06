#ifndef DATATYPES_H
#define DATATYPES_H

typedef char int8_t;
typedef short int int16_t;
typedef int int32_t;
typedef long long int int64_t;

typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long int uint64_t;

// Boolean logic type
typedef enum { false, true } bool;

// Stores coordinates
typedef struct
{
    uint8_t x;
    uint8_t y;
} coords;

typedef struct
{
    uint8_t fg;
    uint8_t bg;
} color_t;

#endif