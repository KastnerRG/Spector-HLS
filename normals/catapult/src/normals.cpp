#include "normals.h"

using namespace ac_math;
#pragma design inline
/*void normalized(fl v[3])
{
    fl val = (v[0]*v[0])+(v[1]*v[1])+(v[2]*v[2]);
	fl t;
	ac_sqrt(val, t);
	for(int i=0;i<3;i++)
	  v[i]=v[i] * t;
}

#pragma design inline
void cross(fl A[3],fl B[3],fl P[3])
{
    P[0] = A[1] * B[2] - A[2] * B[1];
    P[1] = (A[0] * B[2] - A[2] * B[0])*-1;
    P[2] = A[0] * B[1] - A[1] * B[0];
}
*/
#pragma design top
void normals(ac_channel<fl> &vmap, ac_channel<fl> &nmap)
{
//PRAGMA_HLS(HLS array_partition variable=vmap factor=partition_factor BLOCK)
	DATA_MEM mem1, mem2;
	#ifdef __SYNTHESIS__
	while(vmap.available(TVAL))
	#endif
	{
		LOAD_MEM_MAIN: for(unsigned i=0; i<TVAL;i++) {
			mem1.data[i] = vmap.read();
			mem2.data[i] = nmap.read();
		}
		fl data0[(1+KNOB_WINDOW_SIZE_X)*3];
		fl data1[KNOB_WINDOW_SIZE_X*3];
		for(int i=0;i<(1+KNOB_WINDOW_SIZE_X)*3;i++)
			data0[i]=mem1.data[i];
		for(int i=0;i<(KNOB_WINDOW_SIZE_X)*3;i++)
			data1[i]=mem1.data[(cols*3)+i];
loop1:for(int i=0,j=0;i<(rows)*cols*3;i=i+(KNOB_WINDOW_SIZE_X*3))
		{
//		PRAGMA_HLS(HLS UNROLL FACTOR=outer_unroll)

			loop_2:for(int x=0;x<KNOB_WINDOW_SIZE_X*3;x++,j++)
			{
//			PRAGMA_HLS(HLS UNROLL FACTOR=inner_unroll1)
				if(j==cols-1)
				{
					j=-1;
					mem2.data[i + x*3] = NAN;
				}
				const dint32 index00 = (x + 0) * 3;
				const dint32 index01 = (x + 1) * 3;
				const dint32 index10 = (x + 0) * 3;

				fl v00[3],v01[3],v10[3];
				v00[0] = data0[index00];
				v01[0] = data0[index01];
				v10[0] = data1[index10];

				if (v00[0] != NAN && v01[0] != NAN && v10[0] != NAN)
				{
					v00[1] = data0[index00 + 1];
					v01[1] = data0[index01 + 1];
					v10[1] = data1[index10 + 1];

					v00[2] = data0[index00 + 2];
					v01[2] = data0[index01 + 2];
					v10[2] = data1[index10 + 2];

					fl in1[3],in2[3],r[3];
					for(int l=0;l<3;l++)
					{
						in1[l]=v01[l]-v00[l];
						in2[l]=v10[l]-v00[l];
					}
					// cross 
					r[0] = in1[1] * in2[2] - in1[2] * in2[1];
    				    r[1] = (in1[0] * in2[2] - in1[2] * in2[0])*-1;
    				    r[2] = in1[0] * in2[1] - in1[1] * in2[0];
					// normalized
					fl val;
					val = 1/(fl)((r[0]*r[0])+(r[1]*r[1])+(r[2]*r[2]));
					fl t;
					FL x1 = (fl) val;
					FL y1;
					ac_sqrt_pwl(x1, y1);
					t = (fl) y1;
					
					for (int i=0;i<3;i++)
						r[i]=r[i] * t;
					
					mem2.data[i + 0 + x*3] = r[0];
					mem2.data[i + 1 + x*3] = r[1];
					mem2.data[i + 2 + x*3] = r[2];
				} else {
					mem2.data[i + x*3] = NAN;
				}
			}

			data0[0] = data0[KNOB_WINDOW_SIZE_X * 3 + 0];
			data0[1] = data0[KNOB_WINDOW_SIZE_X * 3 + 1];
			data0[2] = data0[KNOB_WINDOW_SIZE_X * 3 + 2];

loop_3:for(int x = 0; x < KNOB_WINDOW_SIZE_X; x++)
			{
	//		PRAGMA_HLS(HLS UNROLL FACTOR=inner_unroll2)
				const dint32 index = (x+1) * 3;
				data0[index + 0] = mem1.data[i+KNOB_WINDOW_SIZE_X*3 + index + 0];
				data0[index + 1] = mem1.data[i+KNOB_WINDOW_SIZE_X*3 + index + 1];
				data0[index + 2] = mem1.data[i+KNOB_WINDOW_SIZE_X*3 + index + 2];
			}

loop_4:for(int x = 0; x < KNOB_WINDOW_SIZE_X; x++)
			{
		//	PRAGMA_HLS(HLS UNROLL FACTOR=inner_unroll2)
				data1[x*3 + 0] = mem1.data[3*cols + i+KNOB_WINDOW_SIZE_X*3 + x*3 + 0];
				data1[x*3 + 1] = mem1.data[3*cols + i+KNOB_WINDOW_SIZE_X*3 + x*3 + 1];
				data1[x*3 + 2] = mem1.data[3*cols + i+KNOB_WINDOW_SIZE_X*3 + x*3 + 2];
			}
		}
loop_5:for(dint32 k=(rows-1)*cols*3;k<rows*cols*3;k++)
			mem2.data[k]=NAN;
	}
}

