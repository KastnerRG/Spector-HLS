#ifndef DCT_H
#define DCT_H
#include <ac_channel.h>
#include <ac_fixed.h>
#include "params.h"

typedef ac_fixed<20,8,true> fl1;

struct DATA_MEM {
	fl1 data[size_im];
};
#endif
