#ifndef PARAMS_H
#define PARAMS_H
#include <math.h>

#define PRAGMA_SUB(x) _Pragma(#x)
#define PRAGMA_HLS(x) PRAGMA_SUB(x)
#define MVAL 32
#define TMVAL MVAL*MVAL
#define Mlog 5
#define PARTITION_FACTOR 32
#define SUBDIM_X 32
#define SUBDIM_Y 32
#define UNROLL_FACTOR1 4
#define UNROLL_FACTOR2 4
#define UNROLL_FACTOR3 4
#endif
