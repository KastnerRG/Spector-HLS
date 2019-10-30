#ifndef PARAMS_H
#define PARAMS_H
#include <math.h>

#define PRAGMA_SUB(x) _Pragma(#x)
#define PRAGMA_HLS(x) PRAGMA_SUB(x)
#define M 1024
#define Mlog log2(M)
#define PARTITION_FACTOR 32
#define SUBDIM_X 32
#define UNROLL_FACTOR1 4
#define UNROLL_FACTOR2 4
#endif
