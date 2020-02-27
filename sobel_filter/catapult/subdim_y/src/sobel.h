#ifndef SOBEL_H_
#define SOBEL_H_
#include <ac_int.h>
#include <ac_channel.h>

#include "params.h"

typedef ac_int<8, false> uint8;
typedef ac_int<1, false> uint1;
#define H 1080
#define W 1920
#define HW H*W

void sobel_y(uint8 i[H][W], uint1 o[H][W]);
void sobel_x(uint8 i[H][W], uint1 o[H][W]);
#endif

