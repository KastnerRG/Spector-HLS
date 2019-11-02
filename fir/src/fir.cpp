#include "fir.h"
#include"params.h"
void firI1 (
  data_t *y,
  data_t *x
  ) {

	coef_t c[N] = {1,    -1,    1,    -1,    -1,    -1,    1,    1,    -1,    -1,    -1,    1,    1,    -1,    1,    -1,    -1,    -1,    -1,    1,    1,    1,    1,    1,    -1,    -1,    1,    1,    1,    -1,    -1,    -1};
	PRAGMA_HLS(HLS ARRAY_PARTITION variable=c block factor=coeff_partition)
	static data_t shift_reg[N];
PRAGMA_HLS(HLS ARRAY_PARTITION variable=shift_reg block factor=shiftreg_partition)
	acc_t acc;
	int i;
	acc=0;
	Shift_Accum_Loop: for (i=N-1;i>=0;i--) {
PRAGMA_HLS(HLS UNROLL FACTOR=inner_unroll)
		if (i==0) {
			acc+=x->data*c[0];
			shift_reg[0].data=x->data;
		} else {
			shift_reg[i].data=shift_reg[i-1].data;
			acc+=shift_reg[i].data*c[i];
		}
	}
  y->data=acc;
 //return acc;
}


void firI2 (
  data_t *y,
  data_t *x
  ) {

	coef_t c[N] = {1,    -1,    1,    -1,    -1,    -1,    1,    1,    -1,    -1,    -1,    1,    1,    -1,    1,    -1,    -1,    -1,    -1,    1,    1,    1,    1,    1,    -1,    -1,    1,    1,    1,    -1,    -1,    -1};
	PRAGMA_HLS(HLS ARRAY_PARTITION variable=c block factor=coeff_partition)
	static data_t shift_reg[N];
	PRAGMA_HLS(HLS ARRAY_PARTITION variable=shift_reg block factor=shiftreg_partition)
	acc_t acc;
	int i;
	acc=0;
	Shift_Accum_Loop: for (i=N-1;i>=0;i--) {
PRAGMA_HLS(HLS UNROLL FACTOR=inner_unroll)
		if (i==0) {
			acc+=x->data*c[0];
			shift_reg[0].data=x->data;
		} else {
			shift_reg[i].data=shift_reg[i-1].data;
			acc+=shift_reg[i].data*c[i];
		}
	}
  y->data=acc;
 //return acc;
}

void firQ1 (
  data_t *y,
  data_t *x
  ) {

	coef_t c[N] = {-1,    -1,    1,    -1,    1,    -1,    1,    -1,    -1,    -1,    -1,    1,    -1,    1,    -1,    1,    1,    -1,    1,    -1,    -1,    1,    -1,    1,    1,    1,    1,    -1,    1,    -1,    1,    1};
	PRAGMA_HLS(HLS ARRAY_PARTITION variable=c block factor=coeff_partition)

	static data_t shift_reg[N];
	PRAGMA_HLS(HLS ARRAY_PARTITION variable=shift_reg block factor=shiftreg_partition)
	acc_t acc;
	int i;
	acc=0;
	Shift_Accum_Loop: for (i=N-1;i>=0;i--) {
PRAGMA_HLS(HLS UNROLL FACTOR=inner_unroll)
		if (i==0) {
			acc+=x->data*c[0];
			shift_reg[0].data=x->data;
		} else {
			shift_reg[i].data=shift_reg[i-1].data;
			acc+=shift_reg[i].data*c[i];
		}
	}
  y->data=acc;
}

void firQ2 (
  data_t *y,
  data_t *x
  ) {

	coef_t c[N] = {-1,    -1,    1,    -1,    1,    -1,    1,    -1,    -1,    -1,    -1,    1,    -1,    1,    -1,    1,    1,    -1,    1,    -1,    -1,    1,    -1,    1,    1,    1,    1,    -1,    1,    -1,    1,    1};

	PRAGMA_HLS(HLS ARRAY_PARTITION variable=c block factor=coeff_partition)
	static data_t shift_reg[N];
	PRAGMA_HLS(HLS ARRAY_PARTITION variable=shift_reg block factor=shiftreg_partition)
	acc_t acc;
	int i;
	acc=0;
	Shift_Accum_Loop: for (i=N-1;i>=0;i--) {
PRAGMA_HLS(HLS UNROLL FACTOR=inner_unroll)
		if (i==0) {
			acc+=x->data*c[0];
			shift_reg[0].data=x->data;
		} else {
			shift_reg[i].data=shift_reg[i-1].data;
			acc+=shift_reg[i].data*c[i];
		}
	}
  y->data=acc;
}


void fir (
  data_t *I,
  data_t *Q,

  data_t *X,
  data_t *Y
  ) {

#pragma HLS INTERFACE axis depth=100 port=I
#pragma HLS INTERFACE axis depth=100 port=Q
#pragma HLS INTERFACE axis depth=100 port=X
#pragma HLS INTERFACE axis depth=100 port=Y
	//Calculate X
	for (int i=0;i<1024;i++)
	{
PRAGMA_HLS(HLS UNROLL FACTOR=outer_unroll)
	data_t x1,i1,temp1,temp2;
	i1=*I++;
	firI1(&x1,&i1);

	data_t x2,q1;
	q1=*Q++;
	firQ1(&x2,&q1);

	temp1.data=x1.data+x2.data;

	//Calculate Y
	data_t y1;
	firI2(&y1,&q1);

	data_t y2;
	firQ2(&y2,&i1);

	temp2.data=y2.data-y1.data;

	if (i==1023)
	{
		temp1.last=1;
		temp2.last=1;
	}
	else
	{
		temp1.last=0;
		temp2.last=0;
	}
	*X++=temp1;
	*Y++=temp2;
	}
}

