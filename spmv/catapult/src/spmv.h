#ifndef SPMV_H_
#define SPMV_H_

#include "params.h"
#include <ac_channel.h>
#include <ac_fixed.h>

typedef ac_fixed<20, 8, true> FLOAT_VECT;

struct FL_MEM {
	FLOAT_VECT data[num_rows];
};

struct INT_MEM {
	int data[num_rows];
};

#endif
