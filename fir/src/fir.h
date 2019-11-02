#ifndef FIR_H_
#define FIR_H_
//#include "/home/siva/Vivado/2018.3/include/gmp.h"
#include <ap_int.h>

const int N = 32;

typedef int	coef_t;
struct data_t{
	float data;
	ap_uint<1> last;
};
typedef float acc_t;

void fir (
  data_t *I,
  data_t *Q,

  data_t *X,
  data_t *Y
  );



#endif
