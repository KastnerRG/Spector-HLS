#include"params.h"
#include<stdio.h>

void DCT8_auto(float *D_O,float *D_I,int ostride, int istride){
    float buf[8];
    float  C[16]= { 1.0f, 0.98078528040323043057924223830923f, 0.92387953251128673848313610506011f, 0.8314696123025452356714026791451f, 0.70710678118654752440084436210485f, 0.55557023301960228867102387084742f, 0.38268343236508983729038391174981f, 0.19509032201612833135051516819658f, 0, -0.19509032201612819257263709005201f, -0.38268343236508972626808144923416f, -0.55557023301960195560411648330046f, -0.70710678118654752440084436210485f, -0.83146961230254534669370514166076f, -0.92387953251128673848313610506011f, -0.98078528040323043057924223830923f};
    PRAGMA_HLS(HLS array_partition variable=C factor=partition_factor block)
    PRAGMA_HLS(HLS array_partition variable=buf factor=partition_factor block)
    for(int k = 0; k < 8; k++){
    	PRAGMA_HLS(HLS UNROLL FACTOR=unroll_dct)
    	buf[k] = 0;
        for(int n = 0; n < 8; n++)
            buf[k] += D_I[n*istride] * C[(2*n*k+k)%16]*(((2*n*k+k)/16)%2?-1:1);
    }

    D_O[0*ostride] = buf[0]* C_norm;
    for(int i = 1; i < 8; i++)
#pragma HLS pipeline
        D_O[i*ostride] = buf[i] * 0.5f;
}


void DCT(float dst[size], float src[size]){

PRAGMA_HLS(HLS array_partition variable=dst factor=partition_factor block)
PRAGMA_HLS(HLS array_partition variable=src factor=partition_factor block)
    for (int i = 0; i + 8 - 1 < imageH; i=i+(8)){
PRAGMA_HLS(HLS UNROLL FACTOR=unroll_height)
        for (int j = 0; j + 8 - 1 < imageW; j =j+ (8)){
PRAGMA_HLS(HLS UNROLL FACTOR=unroll_width)
            for(int k = 0; k < 8; k=k+blockdim_x){

            for(int l=0;l<blockdim_x;l++)
#pragma HLS unroll
            DCT8_auto(dst + (i + k+l) * stride + (j), src + ((i+l) + k) * stride + (j), 1, 1);
        	}
        	 for(int k = 0; k < 8; k=k+blockdim_y){

    		for(int m=0;m<blockdim_y;m++)
#pragma HLS unroll
            DCT8_auto(dst + (i) * stride + ((j+m) + k), dst + (i) * stride + ((j+m) + k), stride, stride);
        	}
        }
    }
}
