#include "dct.h"

fl1 C_norm=0.35355339059327376220042218105242;
/*
void DCT8_auto(float *D_O,float *D_I,int ostride, int istride){


    PRAGMA_HLS(HLS array_partition variable=C factor=partition_factor block)
    PRAGMA_HLS(HLS array_partition variable=buf factor=partition_factor block)
    PRAGMA_HLS(HLS array_partition variable=D_O factor=partition_factor block)
    PRAGMA_HLS(HLS array_partition variable=D_I factor=partition_factor block)
    for(int x = 0; x < 8; x++){
    	buf[x] = 0;
        for(int y = 0; y< 8; y++)
            buf[x] += D_I[y*istride] * C[(2*y*x+x)%16]*(((2*y*x+x)/16)%2?-1:1);
    }

    D_O[0*ostride] = buf[0]* C_norm;
    for(int z = 1; z < 8; z++)
        D_O[z*ostride] = buf[z] * 0.5f;
}
*/

#pragma design top
void DCT(fl1 dst[size_im], fl1 src[size_im]){	
	fl1 C[16]= { 1.0, 0.98078528040323043057924223830923, 0.92387953251128673848313610506011, 0.8314696123025452356714026791451, 0.70710678118654752440084436210485, 0.55557023301960228867102387084742, 0.38268343236508983729038391174981, 0.19509032201612833135051516819658, 0, -0.19509032201612819257263709005201, -0.38268343236508972626808144923416, -0.55557023301960195560411648330046, -0.70710678118654752440084436210485, -0.83146961230254534669370514166076, -0.92387953251128673848313610506011, -0.98078528040323043057924223830923};
    fl1 buf[8];
	loop_1:for (int i = 0; i + 8 - 1 < imageH; i=i+(8)){
		loop_2:for (int j = 0; j + 8 - 1 < imageW; j =j+ (8)){
			loop_3:for(int k = 0; k < 8; k=k+blockdim_x){
				loop_4:for(int l=0;l<blockdim_x;l++){
					loop_5:for(int x = 0; x < 8; x++){
						buf[x] = 0;
						loop_6:for(int y = 0; y< 8; y++)
							buf[x] += src[ ((i+l) + k) * stride + (j)+y] * C[(2*y*x+x)%16]*(((2*y*x+x)/16)%2?-1:1);
					}
					dst[ (i + k+l) * stride + (j)]=(buf[0]*C_norm);
					loop_7:for(int z = 1; z < 8; z++)
						dst[ (i + k+l) * stride + (j)+z]=(buf[z] * fl1(0.5));
				//DCT8_auto(dst [ (i + k+l) * stride + (j)], src [ ((i+l) + k) * stride + (j)], 1, 1);
				}
			}
			loop_9:for(int k = 0; k < 8; k=k+blockdim_y){
				loop_10:for(int m=0;m<blockdim_y;m++){
					loop_11:for(int x = 0; x < 8; x++){
						buf[x] = 0;
						loop_12:for(int y = 0; y< 8; y++)
							buf[x] +=  dst[ (i) * stride + ((j+m) + k)+(y*stride)] * C[(2*y*x+x)%16]*(((2*y*x+x)/16)%2?-1:1);
					}
					dst[(i) * stride + ((j+m) + k)]=(buf[0]* C_norm);
					loop_13:for(int z = 1; z < 8; z++)
						dst[(i) * stride + ((j+m) + k)+(z*stride)]=( buf[z] * fl1(0.5));
            //DCT8_auto(dst [(i) * stride + ((j+m) + k)], dst [ (i) * stride + ((j+m) + k)], stride, stride);
				}
			}
		}
	}
}
