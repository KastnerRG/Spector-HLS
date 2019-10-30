#include "params.h"
#include "matrix_mul.h"
void matrix_mul_x(dtype *A,float B[M*M],float C[M*M])
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
			for(int j=0;j<M;j++)
			{
#pragma HLS pipeline
			C[t*M+j]=C[t*M+j]+temp.data*B[r*M+j];
			}

		}
	}
}
