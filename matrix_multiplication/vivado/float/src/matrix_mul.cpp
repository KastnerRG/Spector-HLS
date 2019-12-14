#include "params.h"
#include "matrix_mul.h"
void matrix_mul(dtype *A,float B[M*M],float C[M*M])
{

PRAGMA_HLS(HLS array_partition variable=B factor=PARTITION_FACTOR block)
PRAGMA_HLS(HLS array_partition variable=C factor=PARTITION_FACTOR block)
#pragma HLS INTERFACE axis depth=50 port=A

	for(int i=0;i<M*M;i=i+SUBDIM_X)
	{
PRAGMA_HLS(HLS UNROLL FACTOR=UNROLL_FACTOR1)
		for(int p=0;p<SUBDIM_X;p++)
		{
PRAGMA_HLS(HLS UNROLL FACTOR=UNROLL_FACTOR2)
		dtype temp;
		temp=*A++;
		int t=(i+p)>>int(Mlog);
		int r=(i+p)%M;
			for(int j=0;j<M;j=j+SUBDIM_Y)
			{
				for(int l=0;l<SUBDIM_Y;l++)
PRAGMA_HLS(HLS UNROLL FACTOR=UNROLL_FACTOR3)
			C[t*M+j+l]=C[t*M+j+l]+temp.data*B[r*M+j+l];
			}

		}
	}
}

