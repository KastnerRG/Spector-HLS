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
void spmv(int Ap[num_rows], int Aj[num_rows], FLOAT_VECT Ax[num_rows],FLOAT_VECT x[num_rows],FLOAT_VECT y[num_rows])
{

	loop_1:for(int row=0;row<num_rows;row++)
	{
	FLOAT_VECT sum=y[row];
	unsigned int row_start=Ap[row];
	unsigned int row_end   = Ap[row+1];
	int jj,ii,kk;
	FLOAT_VECT p_Ax[UNROLL_F];
	FLOAT_VECT p_x[UNROLL_F];

	loop_2:for(jj = row_start; jj < row_end; jj=jj+UNROLL_F)
			{
				if(jj+UNROLL_F-1 < row_end)
				{
			loop_3:for(ii=0; ii<UNROLL_F; ii++)
						p_x[ii] = x[Aj[jj+ii]];

			loop_4:for(ii=0; ii<UNROLL_F; ii++){
					p_Ax[ii] = Ax[jj+ii];
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
						sum += Ax[kk] * x[Aj[kk]];
					}
				}

			}
			y[row] = sum;
		}
}
