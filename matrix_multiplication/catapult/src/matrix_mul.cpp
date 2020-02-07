#include "params.h"
#include "matrix_mul.h"

#pragma design top
void matrix_mul(ac_channel<dtype> &A, ac_channel<dtype> &B, ac_channel<dtype> &C)
{
	DATA_MEM memA, memB, memC;
  #ifndef __SYNTHESIS__
	while(A.available(TMVAL))
	#endif
	{
		LOAD_MEM_MAIN: for(unsigned i=0; i<TMVAL; i++){
			memA.data[i] = A.read();
			memB.data[i] = B.read();
			memC.data[i] = 0;
		}
		loop1:for(int i=0;i<TMVAL;i=i+SUBDIM_X)
		{
			loop2:for(int p=0;p<SUBDIM_X;p++)
			{
				dtype temp;
				temp=memA.data[MVAL*i+p];
				int t=(i+p)>>int(Mlog);
				int r=(i+p)%MVAL;
				loop3:for(int j=0;j<MVAL;j=j+SUBDIM_Y)
				{
					loop4:for(int l=0;l<SUBDIM_Y;l++)
						memC.data[t*MVAL+j+l]=memC.data[t*MVAL+j+l]+temp*memB.data[r*MVAL+j+l];
				}
			}
		}
		loop_5:for(int i=0; i<MVAL; i++)
						 C.write(memC.data[i]);
	}
}

