#ifndef NORMALS_H
#define NORMALS_H
#include <ac_int.h>
#include <ac_channel.h>
#include <ac_fixed.h>

#include "params.h"

typedef ac_fixed<20, 8, true> fl;
typedef ac_int<32, true> dint32;

struct DATA_MEM {
	fl data[TVAL];
};
#endif
