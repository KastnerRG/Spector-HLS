
#include "ac_int.h"
#include <algorithm>
#include <ac_channel.h>
#include "params.h"
// size of (tmphei * tmpwid + inhei * inwid) = (100x100 + 200x200)




typedef ac_int<8, false> axis_t;

void SAD_MATCH(axis_t INPUT[size_m], axis_t OUTPUT[size_m]);



