#ifndef PARAMS_H
#define PARAMS_H


#define PRAGMA_SUB(x) _Pragma(#x)
#define PRAGMA_HLS(x) PRAGMA_SUB(x)

#define outer_unroll 1
#define inner_unroll 1
#define coeff_partition 2
#define shiftreg_partition 2
#endif
