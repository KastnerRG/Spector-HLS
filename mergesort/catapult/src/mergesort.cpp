#include "mergesort.h"

#pragma hls design top
void mergesort(ac_channel<dint> &in, ac_channel<dint> &out)
{
//	PRAGMA_HLS(HLS array_partition variable=in factor=partition_factor block)
//	PRAGMA_HLS(HLS array_partition variable=out factor=partition_factor block)
DATA_MEM mem1, mem2;

#ifndef __SYNTHESIS__
while(in.available(no_size)) 
#endif
{
	
	loop_LMM:for(dint i=0; i<no_size; i++)
	{
		mem1.data[i] = in.read();
	}
loop1:for(dint i=2;i<=no_size;i=i*2)
	{
	PRAGMA_HLS (HLS unroll factor=outer_unroll)
		loop2:for(dint j=0;j<no_size/i;j++)
		{
			
//#pragma HLS loop_tripcount min=1 max=max_iter
		PRAGMA_HLS (HLS unroll factor=inner_unroll1)
		dint left=i*j;
		dint right=(i*j)+i-1;
		dint mid=((2*i*j)+i-1)/2;

					const dint size_left  = mid - left + 1;
					const dint size_right = right - mid;

					dint ii = 0;    // counter for left elements
					dint jj = 0;    // counter for right elements
					dint k = left; // counter for output

					loop3:for(;ii < size_left && jj < size_right;k++)
					{
			//#pragma HLS loop_tripcount min=1 max=no_size_loop
						
				PRAGMA_HLS (HLS unroll factor=merge_unroll)
						dint left_val  = mem1.data[ii+left];
						dint right_val = mem1.data[jj+mid+1];


						if (left_val <= right_val)
						{
							mem2.data[k] = left_val;
							ii++;
						}
						else
						{
							mem2.data[k] = right_val;
							jj++;
						}
					}

					loop4:for (;ii < size_left;ii++)
					{
//#pragma HLS loop_tripcount min=0 max=9
						
						mem2.data[k] = mem1.data[ii+left];
						k++;
					}

					loop5:for (;jj < size_right; jj++)
					{
//#pragma HLS loop_tripcount min=0 max=9
						
						mem2.data[k] = mem1.data[jj+mid+1];
						k++;
					}


		}
			loop6:for(dint k=0;k<no_size;k++)
//		PRAGMA_HLS (HLS unroll factor=inner_unroll2)
			mem1.data[k]=mem2.data[k];
	}
	loop7:for(dint k=0; k<no_size; k++)
		out.write(mem2.data[k]);
}
}
