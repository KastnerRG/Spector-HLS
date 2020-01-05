#include "params.h"
#include<stdio.h>
#include<ac_math.h>
#include<ac_std_float.h>

typedef ac_ieee_float<binary32> ac_float;
#pragma design inline
void normalized(ac_float v[3])
{
    ac_float val = 1 / (ac_float)((v[0]*v[0])+(v[1]*v[1])+(v[2]*v[2]));
	ac_float t;
	ac_sqrt_pwl(val, t);
	for (int i=0;i<3;i++)
	v[i]=v[i] * t;
}
#pragma design inline
void cross(ac_float A[3],ac_float B[3],ac_float P[3])
{
    P[0] = A[1] * B[2] - A[2] * B[1];
    P[1] = (A[0] * B[2] - A[2] * B[0]) * (ac_float)-1;
    P[2] = A[0] * B[1] - A[1] * B[0];
}
#pragma design top
void normals(ac_float vmap[rows*cols*3],ac_float nmap[rows*cols*3])
{
	ac_float data0[(1+KNOB_WINDOW_SIZE_X)*3];
	ac_float data1[KNOB_WINDOW_SIZE_X*3];
for(int i=0;i<(1+KNOB_WINDOW_SIZE_X)*3;i++)
data0[i]=vmap[i];
for(int i=0;i<(KNOB_WINDOW_SIZE_X)*3;i++)
	data1[i]=vmap[(cols*3)+i];
for(int i=0,j=0;i<(rows)*cols*3;i=i+(KNOB_WINDOW_SIZE_X*3))
{
	for(int x=0;x<KNOB_WINDOW_SIZE_X*3;x++,j++)
	{
		if(j==cols-1)
		{
			j=-1;
			nmap[i + x*3] = NAN;
		}
		const int index00 = (x + 0) * 3;
		const int index01 = (x + 1) * 3;
		const int index10 = (x + 0) * 3;

				ac_float v00[3],v01[3],v10[3];
				v00[0] = data0[index00];
				v01[0] = data0[index01];
				v10[0] = data1[index10];

				if (!isnan (v00[0]) && !isnan (v01[0]) && !isnan (v10[0]))
								{
									v00[1] = data0[index00 + 1];
									v01[1] = data0[index01 + 1];
									v10[1] = data1[index10 + 1];

									v00[2] = data0[index00 + 2];
									v01[2] = data0[index01 + 2];
									v10[2] = data1[index10 + 2];


									ac_float in1[3],in2[3],r[3];
									for(int l=0;l<3;l++)
									{
										in1[l]=v01[l]-v00[l];
										in2[l]=v10[l]-v00[l];
									}
										cross(in1,in2,r);

									normalized(r);

									nmap[i + 0 + x*3] = r[0];
									nmap[i + 1 + x*3] = r[1];
									nmap[i + 2 + x*3] = r[2];
								}
								else
								{
									nmap[i + x*3] = NAN;
								}

						}

		data0[0] = data0[KNOB_WINDOW_SIZE_X * 3 + 0];
		data0[1] = data0[KNOB_WINDOW_SIZE_X * 3 + 1];
		data0[2] = data0[KNOB_WINDOW_SIZE_X * 3 + 2];

		for(int x = 0; x < KNOB_WINDOW_SIZE_X; x++)
				{
					const int index = (x+1) * 3;
					data0[index + 0] = vmap[i+KNOB_WINDOW_SIZE_X*3 + index + 0];
					data0[index + 1] = vmap[i+KNOB_WINDOW_SIZE_X*3 + index + 1];
					data0[index + 2] = vmap[i+KNOB_WINDOW_SIZE_X*3 + index + 2];
				}

		for(int x = 0; x < KNOB_WINDOW_SIZE_X; x++)
		{
			data1[x*3 + 0] = vmap[3*cols + i+KNOB_WINDOW_SIZE_X*3 + x*3 + 0];
			data1[x*3 + 1] = vmap[3*cols + i+KNOB_WINDOW_SIZE_X*3 + x*3 + 1];
			data1[x*3 + 2] = vmap[3*cols + i+KNOB_WINDOW_SIZE_X*3 + x*3 + 2];
		}
}
for(int k=(rows-1)*cols*3;k<rows*cols*3;k++)
nmap[k]=NAN;

	}

