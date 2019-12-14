#include "params.h"
#include "matrix_mul.h"

#pragma design top
void matrix_mul(ac_channel<dtype> &A, dtype B[TMVAL], dtype C[TMVAL])
{
	DATA_MEM mem;
  #ifndef __SYNTHESIS__
	while(A.available(TMVAL))
	#endif
	{
		LOAD_MEM_MAIN: for(unsigned i=0; i<TMVAL; i++){
			mem.data[i] = A.read();
		}
		loop1:for(int i=0;i<TMVAL;i=i+SUBDIM_X)
		{
			loop2:for(int p=0;p<SUBDIM_X;p++)
			{
				dtype temp;
				temp=mem.data[MVAL*i+p];
				int t=(i+p)>>int(Mlog);
				int r=(i+p)%MVAL;
				loop3:for(int j=0;j<MVAL;j=j+SUBDIM_Y)
				{
					loop4:for(int l=0;l<SUBDIM_Y;l++)
						C[t*MVAL+j+l]=C[t*MVAL+j+l]+temp*B[r*MVAL+j+l];
				}
			}
		}
	}
}

