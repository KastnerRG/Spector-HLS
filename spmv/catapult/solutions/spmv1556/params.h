#ifndef PARAMS_H_
#define PARAMS_H_
#define num_rows 512
#define UNROLL_F 1
#define PRAGMA_SUB(x) _Pragma (#x)
#define PRAGMA_HLS(x) PRAGMA_SUB(x)

#if UNROLL_F==1
const int loop_tripcount1=3;
const int loop_tripcount2=0;
#endif

#if UNROLL_F==2
const int loop_tripcount1=2;
const int loop_tripcount2=1;
#endif

#if UNROLL_F>2
const int loop_tripcount1=1;
const int loop_tripcount2=3;
#endif

#endif
