#ifndef NORMALS_H
#define NORMALS_H
#include <ac_int.h>
#include <ac_channel.h>
#include <ac_fixed.h>
#include <ac_math/ac_sqrt_pwl.h>
#include "params.h"

typedef ac_fixed<20, 8, false> fl;
typedef ac_fixed<16, 8, true, AC_RND, AC_SAT> FL;
typedef ac_int<32, true> dint32;

struct DATA_MEM {
	fl data[TVAL];
};
#endif
