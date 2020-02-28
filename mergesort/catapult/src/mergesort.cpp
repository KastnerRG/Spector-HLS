#include "mergesort.h"

#pragma hls_design top
void mergesort(dint in[no_size],dint  out[no_size])
{
//	PRAGMA_HLS(HLS array_partition variable=in factor=partition_factor block)
//	PRAGMA_HLS(HLS array_partition variable=out factor=partition_factor block)
	loop1:for(dint i=2;i<=no_size;i=i*2)
	{
		loop2:for(dint j=0;j<no_size/i;j++)
		{			
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
				dint left_val  = in[ii+left];
				dint right_val = in[jj+mid+1];
				if (left_val <= right_val)
				{
					out[k] = left_val;
					ii++;
				}
				else
				{
					out[k] = right_val;
					jj++;
				}
			}

			loop4:for (;ii < size_left;ii++)
			{				
				out[k] = in[ii+left];
				k++;
			}
			loop5:for (;jj < size_right; jj++)
			{		
				out[k] = in[jj+mid+1];
				k++;
			}
		}
	loop6:for(dint k=0;k<no_size;k++)
		in[k]=out[k];
	}
}
