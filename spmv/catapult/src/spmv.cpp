#include "spmv.h"
//#define FLOAT_VECT float
/*
float sub_sum(FLOAT_VECT  tmp_Ax[UNROLL_F], FLOAT_VECT  tmp_x[UNROLL_F])
{
	 FLOAT_VECT tmp_sum=0;
//parallel mul
	for (int ii=0; ii<UNROLL_F; ii++)
PRAGMA_HLS(HLS UNROLL factor=inner_unroll2)
		tmp_sum+= tmp_Ax[ii]*tmp_x[ii];

//reduction
	return tmp_sum;

}
*/
#pragma design top
void spmv(ac_channel<int> &Ap, ac_channel<int> &Aj,ac_channel<FLOAT_VECT> &Ax,ac_channel<FLOAT_VECT> &x,ac_channel<FLOAT_VECT> &y)
{
INT_MEM mem_Ap, mem_Aj;
FL_MEM mem_Ax, mem_x, mem_y;
#ifndef __SYNTHESIS__
while(Ap.available(num_rows))
#endif
{
LOOP_LMM:for(int i=0; i<num_rows; i++)
{
mem_Ap.data[i] = Ap.read();
mem_Aj.data[i] = Aj.read();
mem_Ax.data[i] = Ax.read();
mem_x.data[i] = x.read();
}
loop_1:for(int row=0;row<num_rows;row++)
{
FLOAT_VECT sum=mem_y.data[row];
unsigned int row_start=mem_Ap.data[row];
unsigned int row_end   = mem_Ap.data[row+1];
int jj,ii,kk;
FLOAT_VECT p_Ax[UNROLL_F];
FLOAT_VECT p_x[UNROLL_F];

loop_2:for(jj = row_start; jj < row_end; jj=jj+UNROLL_F)
		{
			if(jj+UNROLL_F-1 < row_end)
			{
		loop_3:for(ii=0; ii<UNROLL_F; ii++)
					p_x[ii] = mem_x.data[mem_Aj.data[jj+ii]];

		loop_4:for(ii=0; ii<UNROLL_F; ii++){
				p_Ax[ii] = mem_Ax.data[jj+ii];
				FLOAT_VECT tmp_sum=0;
				loop_5:for(int ii=0;ii<UNROLL_F;ii++)
					tmp_sum+=p_Ax[ii]*p_x[ii];
				sum=sum+tmp_sum;
			}
				//sum += sub_sum(p_Ax, p_x);
			}
			else
			{
			loop_6:for(kk=jj; kk<row_end; kk++)
				{
					sum += mem_Ax.data[kk] * mem_x.data[mem_Aj.data[kk]];
				}
			}

		}
		mem_y.data[row] = sum;
	}
LOOP_LOAD:for(int i=0; i<num_rows; i++)
	y.write(mem_y.data[i]);
}
}
