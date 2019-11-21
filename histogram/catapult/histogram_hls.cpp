#include "histogram_hls.h"

#pragma design top
void histogram_hls(ac_channel<uint9> &data_in, uint17 hist[KNOB_HIST_SIZE])
{   
    DATA_MEM mem;
    #ifndef __SYNTHESIS__
    while(data_in.available(DATA_SIZE))
    #endif
    {
    
    LOAD_MEM_MAIN: for(unsigned i=0; i<DATA_SIZE; i++) {
        mem.data[i] = data_in.read();
    }
    }

#if KNOB_NUM_HIST >= 1
    static uint17 histogram1[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 2
    static uint17 histogram2[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 3
    static uint17 histogram3[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 4
    static uint17 histogram4[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 5
    static uint17 histogram5[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 6
    static uint17 histogram6[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 7
    static uint17 histogram7[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 8
    static uint17 histogram8[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 9
    static uint17 histogram9[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 10
    static uint17 histogram10[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 11
    static uint17 histogram11[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 12
    static uint17 histogram12[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 13
    static uint17 histogram13[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 14
    static uint17 histogram14[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 15
    static uint17 histogram15[KNOB_HIST_SIZE];
#if KNOB_NUM_HIST >= 16
    static uint17 histogram16[KNOB_HIST_SIZE];
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

    loop_1:for(uint9 i=0; i<KNOB_HIST_SIZE; i++)
    {
#if KNOB_NUM_HIST >= 1
    histogram1[i] = 0;
#if KNOB_NUM_HIST >= 2
    histogram2[i] = 0;
#if KNOB_NUM_HIST >= 3
    histogram3[i] = 0;
#if KNOB_NUM_HIST >= 4
    histogram4[i] = 0;
#if KNOB_NUM_HIST >= 5
    histogram5[i] = 0;
#if KNOB_NUM_HIST >= 6
    histogram6[i] = 0;
#if KNOB_NUM_HIST >= 7
    histogram7[i] = 0;
#if KNOB_NUM_HIST >= 8
    histogram8[i] = 0;
#if KNOB_NUM_HIST >= 9
    histogram9[i] = 0;
#if KNOB_NUM_HIST >= 10
    histogram10[i] = 0;
#if KNOB_NUM_HIST >= 11
    histogram11[i] = 0;
#if KNOB_NUM_HIST >= 12
    histogram12[i] = 0;
#if KNOB_NUM_HIST >= 13
    histogram13[i] = 0;
#if KNOB_NUM_HIST >= 14
    histogram14[i] = 0;
#if KNOB_NUM_HIST >= 15
    histogram15[i] = 0;
#if KNOB_NUM_HIST >= 16
    histogram16[i] = 0;
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
    }
uint17 offset;
    loop_2:for(offset=0; offset<TRIPCNT; offset=offset+KNOB_NUM_HIST){
#if KNOB_NUM_HIST >= 1
	histogram1[mem.data[offset]]++;
#if KNOB_NUM_HIST >= 2
	histogram2[mem.data[offset+1]]++;
#if KNOB_NUM_HIST >= 3
	histogram3[mem.data[offset+2]]++;
#if KNOB_NUM_HIST >= 4
	histogram4[mem.data[offset+3]]++;
#if KNOB_NUM_HIST >= 5
	histogram5[mem.data[offset+4]]++;
#if KNOB_NUM_HIST >= 6
	histogram6[mem.data[offset+5]]++;
#if KNOB_NUM_HIST >= 7
	histogram7[mem.data[offset+6]]++;
#if KNOB_NUM_HIST >= 8
	histogram8[mem.data[offset+7]]++;
#if KNOB_NUM_HIST >= 9
	histogram9[mem.data[offset+8]]++;
#if KNOB_NUM_HIST >= 10
	histogram10[mem.data[offset+9]]++;
#if KNOB_NUM_HIST >= 11
	histogram11[mem.data[offset+10]]++;
#if KNOB_NUM_HIST >= 12
	histogram12[mem.data[offset+11]]++;
#if KNOB_NUM_HIST >= 13
	histogram13[mem.data[offset+12]]++;
#if KNOB_NUM_HIST >= 14
	histogram14[mem.data[offset+13]]++;
#if KNOB_NUM_HIST >= 15
	histogram15[mem.data[offset+14]]++;
#if KNOB_NUM_HIST >= 16
	histogram16[mem.data[offset+15]]++;
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
    }
#if LEFTOVER_LOOP >= 1
    histogram1[mem.data[offset]]++;
#if LEFTOVER_LOOP >= 2
    histogram2[mem.data[offset+1]]++;
#if LEFTOVER_LOOP >= 3
    histogram3[mem.data[offset+2]]++;
#if LEFTOVER_LOOP >= 4
    histogram4[mem.data[offset+3]]++;
#if LEFTOVER_LOOP >= 5
    histogram5[mem.data[offset+4]]++;
#if LEFTOVER_LOOP >= 6
    histogram6[mem.data[offset+5]]++;
#if LEFTOVER_LOOP >= 7
    histogram7[mem.data[offset+6]]++;
#if LEFTOVER_LOOP >= 8
    histogram8[mem.data[offset+7]]++;
#if LEFTOVER_LOOP >= 9
    histogram9[mem.data[offset+8]]++;
#if LEFTOVER_LOOP >= 10
    histogram10[mem.data[offset+9]]++;
#if LEFTOVER_LOOP >= 11
    histogram11[mem.data[offset+10]]++;
#if LEFTOVER_LOOP >= 12
    histogram12[mem.data[offset+11]]++;
#if LEFTOVER_LOOP >= 13
    histogram13[mem.data[offset+12]]++;
#if LEFTOVER_LOOP >= 14
    histogram14[mem.data[offset+13]]++;
#if LEFTOVER_LOOP >= 15
    histogram15[mem.data[offset+14]]++;
#if LEFTOVER_LOOP >= 16
    histogram16[mem.data[offset+15]]++;
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

  loop_3:for(uint9 i=0; i<KNOB_HIST_SIZE; i++)
    {
#if KNOB_NUM_HIST >= 1
        hist[i] = histogram1[i] +
#if KNOB_NUM_HIST >= 2
        histogram2[i] +
#if KNOB_NUM_HIST >= 3
        histogram3[i] +
#if KNOB_NUM_HIST >= 4
        histogram4[i] +
#if KNOB_NUM_HIST >= 5
        histogram5[i] +
#if KNOB_NUM_HIST >= 6
        histogram6[i] +
#if KNOB_NUM_HIST >= 7
        histogram7[i] +
#if KNOB_NUM_HIST >= 8
        histogram8[i] +
#if KNOB_NUM_HIST >= 9
        histogram9[i] +
#if KNOB_NUM_HIST >= 10
        histogram10[i] +
#if KNOB_NUM_HIST >= 11
        histogram11[i] +
#if KNOB_NUM_HIST >= 12
        histogram12[i] +
#if KNOB_NUM_HIST >= 13
        histogram13[i] +
#if KNOB_NUM_HIST >= 14
        histogram14[i] +
#if KNOB_NUM_HIST >= 15
        histogram15[i] +
#if KNOB_NUM_HIST >= 16
        histogram16[i] +
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
 0 ;
   }

}
