#include <stdlib.h>
#include <stdio.h>
#include "/opt/Xilinx/Vivado/2018.3/include/gmp.h"
#include "ap_int.h"
#include <algorithm>
#include "params.h"
// size of (tmphei * tmpwid + inhei * inwid) = (100x100 + 200x200)





struct axis_t {
    unsigned char data;
    ap_int<1> last;
};

struct window  {
	unsigned char win[tmpdim][tmpdim];
};


struct buffer {
	unsigned char buf [tmpdim][indim];
};

void SAD_MATCH(axis_t *INPUT, axis_t *OUTPUT);



