#include "histogram.h"

/*
 * This code is the higher level portion of histogram. This will be
 * using the histogram_hls() function as a single work item and will
 * be pipelined under one workgroup. This way, we will have
 * DATA_SIZE/KNOB_NUM_WORK_ITEMS being processed in a single pipeline.
 * Eventually we will have multiple such workgroups that will execute this
 * in a parallel fashion.
 * AUTHOR: MAYUNK KULKARNI
*/
#pragma hls_design top
void histogram_main(ac_channel<h_uint> &data_in, ac_channel<HIST_MEM> &hist_out)
{
    #ifndef __SYNTHESIS__
        while(data_in.available(DATA_SIZE))
    #endif
    {
    BIG_MEM mem; 
    HIST_MEM hist;
    
    LOAD_MEM_MAIN: for(unsigned i=0; i<DATA_SIZE; i++) {
        mem.data[i] = data_in.read();
    }
    // channel in declarations
    #if KNOB_NUM_WORK_ITEMS >= 1
         DATA_MEM data_in1
    #if KNOB_NUM_WORK_ITEMS >= 2
        , data_in2
    #if KNOB_NUM_WORK_ITEMS >= 4
        , data_in3, data_in4
    #if KNOB_NUM_WORK_ITEMS >= 8
        , data_in5, data_in6, data_in7, data_in8
    #endif
    #endif
    #endif
    #endif
    ;
    
    // channel out declarations
    #if KNOB_NUM_WORK_ITEMS >= 1
        HIST_MEM hist_out1
    #if KNOB_NUM_WORK_ITEMS >= 2
        , hist_out2
    #if KNOB_NUM_WORK_ITEMS >= 4
        , hist_out3, hist_out4
    #if KNOB_NUM_WORK_ITEMS >= 8
        , hist_out5, hist_out6, hist_out7, hist_out8
    #endif
    #endif
    #endif
    #endif
    ;
    
    MEM_TRANSFER_MAIN:for(d_uint i=0; i < DATA_SIZE/KNOB_NUM_WORK_ITEMS; i+KNOB_NUM_WORK_ITEMS) {
        #if KNOB_NUM_WORK_ITEMS >= 1
        data_in1.data[i] = mem.data[i];
        #if KNOB_NUM_WORK_ITEMS >= 2
        data_in2.data[i] = mem.data[i+1];
        #if KNOB_NUM_WORK_ITEMS >= 4
        data_in3.data[i] = mem.data[i+2];
        data_in4.data[i] = mem.data[i+3];
        #if KNOB_NUM_WORK_ITEMS >= 8
        data_in5.data[i] = mem.data[i+4];
        data_in6.data[i] = mem.data[i+5];
        data_in7.data[i] = mem.data[i+6];
        data_in8.data[i] = mem.data[i+7];
        #endif
        #endif
        #endif
        #endif
    }
    
    HIST_ZERO_LOOP_MAIN:for(d_uint i=0; i < KNOB_HIST_SIZE; i++) {
        #if KNOB_NUM_WORK_ITEMS >= 1
        hist_out1.data[i] = 0;
        #if KNOB_NUM_WORK_ITEMS >= 2
        hist_out2.data[i] = 0;
        #if KNOB_NUM_WORK_ITEMS >= 4
        hist_out3.data[i] = 0;
        hist_out4.data[i] = 0;
        #if KNOB_NUM_WORK_ITEMS >= 8
        hist_out5.data[i] = 0;
        hist_out6.data[i] = 0;
        hist_out7.data[i] = 0;
        hist_out8.data[i] = 0;
        #endif
        #endif
        #endif
        #endif
    }
    
    #if KNOB_NUM_WORK_ITEMS >= 1
    static ac_channel<DATA_MEM> dataCh1
    #if KNOB_NUM_WORK_ITEMS >= 2
        , dataCh2
    #if KNOB_NUM_WORK_ITEMS >= 4
        , dataCh3, dataCh4
    #if KNOB_NUM_WORK_ITEMS >= 8
        , dataCh5, dataCh6, dataCh7, dataCh8
    #endif
    #endif
    #endif
    #endif
    ;
    
    #if KNOB_NUM_WORK_ITEMS >= 1
    dataCh1.write(data_in1);
    #if KNOB_NUM_WORK_ITEMS >= 2
    dataCh2.write(data_in2);
    #if KNOB_NUM_WORK_ITEMS >= 4
    dataCh3.write(data_in3);
    dataCh4.write(data_in4);
    #if KNOB_NUM_WORK_ITEMS >= 8
    dataCh5.write(data_in5);
    dataCh6.write(data_in6);
    dataCh7.write(data_in7);
    dataCh8.write(data_in8);
    #endif
    #endif
    #endif
    #endif
    
    #if KNOB_NUM_WORK_ITEMS >= 1
    static ac_channel<HIST_MEM> histCh1
    #if KNOB_NUM_WORK_ITEMS >= 2
        , histCh2
    #if KNOB_NUM_WORK_ITEMS >= 4
        , histCh3, histCh4
    #if KNOB_NUM_WORK_ITEMS >= 8
        , histCh5, histCh6, histCh7, histCh8
    #endif
    #endif
    #endif
    #endif
    ;
        
    #if KNOB_NUM_WORK_ITEMS >= 1
    histogram_hls(dataCh1, histCh1);
    #if KNOB_NUM_WORK_ITEMS >= 2
    histogram_hls(dataCh2, histCh2);
    #if KNOB_NUM_WORK_ITEMS >= 4
    histogram_hls(dataCh3, histCh3);
    histogram_hls(dataCh4, histCh4);
    #if KNOB_NUM_WORK_ITEMS >= 8
    histogram_hls(dataCh5, histCh5);
    histogram_hls(dataCh6, histCh6);
    histogram_hls(dataCh7, histCh7);
    histogram_hls(dataCh8, histCh8);
    #endif
    #endif
    #endif
    #endif
     
    #if KNOB_NUM_WORK_ITEMS >= 1
    histCh1.read(hist_out1);
    #if KNOB_NUM_WORK_ITEMS >= 2
    histCh2.read(hist_out2);
    #if KNOB_NUM_WORK_ITEMS >= 4
    histCh3.read(hist_out3);
    histCh4.read(hist_out4);
    #if KNOB_NUM_WORK_ITEMS >= 8
    histCh5.read(hist_out5);
    histCh6.read(hist_out6);
    histCh7.read(hist_out7);
    histCh8.read(hist_out8);
    #endif
    #endif
    #endif
    #endif       

    MAIN_HIST_TRANSFER:for(d_uint i=0; i < KNOB_HIST_SIZE; i++) {
        #if KNOB_NUM_WORK_ITEMS >= 1
        hist.data[i] = hist_out1.data[i] 
        #if KNOB_NUM_WORK_ITEMS >= 2
                        + hist_out2.data[i]
        #if KNOB_NUM_WORK_ITEMS >= 4
                        + hist_out3.data[i] + hist_out4.data[i]
        #if KNOB_NUM_WORK_ITEMS >= 8
                        + hist_out5.data[i] + hist_out6.data[i] + hist_out7.data[i] + hist_out8.data[i]
        #endif
        #endif
        #endif
        #endif
        ;
    }
    
    hist_out.write(hist);
    }
}
