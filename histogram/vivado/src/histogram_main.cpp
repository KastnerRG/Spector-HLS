#include "histogram_hls.h"
#include <stdio.h>
/*
 * This code is the higher level portion of histogram. This will be
 * using the histogram_hls() function as a single work item and will
 * be pipelined under one workgroup. This way, we will have
 * DATA_SIZE/KNOB_NUM_WORK_ITEMS being processed in a single pipeline.
 * Eventually we will have multiple such workgroups that will execute this
 * in a parallel fashion.
 * AUTHOR: MAYUNK KULKARNI
 */
void histogram_main(unsigned char data[DATA_SIZE], unsigned int histogram[KNOB_HIST_SIZE]){
#pragma HLS INTERFACE ap_memory port=data
	// simulating work items in HLS

init:	for(int i=0;i<KNOB_HIST_SIZE;i++){
#pragma HLS PIPELINE II=1
		histogram[i]=0;
	}

#if KNOB_NUM_WORK_GROUPS == 1
unsigned long offset;
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data cyclic factor=KNOB_NUM_HIST)
wiloop_1:for(offset=0; offset<DATA_SIZE/KNOB_NUM_WORK_GROUPS; offset+=INCR){
		histogram_hls(data, histogram, offset);
	}
#endif

#if KNOB_NUM_WORK_GROUPS >= 2

PRAGMA_HLS(HLS ARRAY_PARTITION variable=data cyclic factor=UNROLL_ARR_ASSIGN)
unsigned long offset;
unsigned char data1[DATA_SIZE/KNOB_NUM_WORK_GROUPS], data2[DATA_SIZE/KNOB_NUM_WORK_GROUPS]
#if KNOB_NUM_WORK_GROUPS >= 4
,data3[DATA_SIZE/KNOB_NUM_WORK_GROUPS], data4[DATA_SIZE/KNOB_NUM_WORK_GROUPS]
#if KNOB_NUM_WORK_GROUPS >= 8
,data5[DATA_SIZE/KNOB_NUM_WORK_GROUPS], data6[DATA_SIZE/KNOB_NUM_WORK_GROUPS],
data7[DATA_SIZE/KNOB_NUM_WORK_GROUPS], data8[DATA_SIZE/KNOB_NUM_WORK_GROUPS]
#endif
#endif
;

unsigned int histm1[KNOB_HIST_SIZE], histm2[KNOB_HIST_SIZE]
#if KNOB_NUM_WORK_GROUPS >= 4
,histm3[KNOB_HIST_SIZE], histm4[KNOB_HIST_SIZE]
#if KNOB_NUM_WORK_GROUPS >= 8
,histm5[KNOB_HIST_SIZE], histm6[KNOB_HIST_SIZE],
histm7[KNOB_HIST_SIZE], histm8[KNOB_HIST_SIZE]
#endif
#endif
;

PRAGMA_HLS(HLS ARRAY_PARTITION variable=data1 cyclic factor=KNOB_NUM_HIST)
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data2 cyclic factor=KNOB_NUM_HIST)
#if KNOB_NUM_WORK_GROUPS >= 4
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data3 cyclic factor=KNOB_NUM_HIST)
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data4 cyclic factor=KNOB_NUM_HIST)
#if KNOB_NUM_WORK_GROUPS >= 8
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data5 cyclic factor=KNOB_NUM_HIST)
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data6 cyclic factor=KNOB_NUM_HIST)
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data7 cyclic factor=KNOB_NUM_HIST)
PRAGMA_HLS(HLS ARRAY_PARTITION variable=data8 cyclic factor=KNOB_NUM_HIST)
#endif
#endif

unsigned long cnt;

data_split: for(cnt=0;cnt<DATA_SIZE/KNOB_NUM_WORK_GROUPS;cnt++){
#pragma HLS PIPELINE II=1
PRAGMA_HLS(HLS UNROLL factor=UNROLL_ARR_ASSIGN)
	data1[cnt] = data[cnt];
	data2[cnt] = data[cnt+(DATA_SIZE/KNOB_NUM_WORK_GROUPS)];
#if KNOB_NUM_WORK_GROUPS >= 4
	data3[cnt] = data[cnt+2*(DATA_SIZE/KNOB_NUM_WORK_GROUPS)];
	data4[cnt] = data[cnt+3*(DATA_SIZE/KNOB_NUM_WORK_GROUPS)];
#if KNOB_NUM_WORK_GROUPS >= 8
	data5[cnt] = data[cnt+4*(DATA_SIZE/KNOB_NUM_WORK_GROUPS)];
	data6[cnt] = data[cnt+5*(DATA_SIZE/KNOB_NUM_WORK_GROUPS)];
	data7[cnt] = data[cnt+6*(DATA_SIZE/KNOB_NUM_WORK_GROUPS)];
	data8[cnt] = data[cnt+7*(DATA_SIZE/KNOB_NUM_WORK_GROUPS)];
#endif
#endif
}
hists_init: for(int i=0;i<KNOB_HIST_SIZE;i++){
#pragma HLS PIPELINE II=1
	histm1[i] = 0;
	histm2[i] = 0;
#if KNOB_NUM_WORK_GROUPS >= 4
	histm3[i] = 0;
	histm4[i] = 0;
#if KNOB_NUM_WORK_GROUPS >= 8
	histm5[i] = 0;
	histm6[i] = 0;
	histm7[i] = 0;
	histm8[i] = 0;
#endif
#endif
}
wiloop:for(offset=0; offset<DATA_SIZE/KNOB_NUM_WORK_GROUPS; offset+=INCR){
		histogram_hls(data1, histm1, offset);
		histogram_hls(data2, histm2, offset);
#if KNOB_NUM_WORK_GROUPS >= 4
		histogram_hls(data3, histm3, offset);
		histogram_hls(data4, histm4, offset);
#if KNOB_NUM_WORK_GROUPS >= 8
		histogram_hls(data5, histm5, offset);
		histogram_hls(data6, histm6, offset);
		histogram_hls(data7, histm7, offset);
		histogram_hls(data8, histm8, offset);
#endif
#endif

	}

accum_loop:for(int i=0; i<KNOB_HIST_SIZE;i++) {
#pragma HLS PIPELINE II=1
	histogram[i] = histm1[i] + histm2[i] +
#if KNOB_NUM_WORK_GROUPS >= 4
			histm3[i] + histm4[i] +
#if KNOB_NUM_WORK_GROUPS >= 8
			histm5[i] + histm6[i] + histm7[i] + histm8[i] +
#endif
#endif
		0;
}

#endif

}
