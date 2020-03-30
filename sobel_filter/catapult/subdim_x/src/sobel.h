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

struct MEM_INT8 {
	uint8 data[H][W];
};

struct MEM_INT1 {
	uint1 data[H][W];
};
void sobel_y(ac_channel<uint8>, ac_channel<uint1>);
void sobel_x(ac_channel<uint8>, ac_channel<uint1>);
#endif

