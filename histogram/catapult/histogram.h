#include "ac_int.h"
#include "ac_channel.h"

#include "params.h"

typedef ac_int<8, false> h_uint;

typedef ac_int<16, false> d_uint;

typedef struct {
    h_uint data[KNOB_HIST_SIZE];
} HIST_MEM;

typedef struct {
    d_uint data[DATA_SIZE/KNOB_NUM_WORK_ITEMS];
} DATA_MEM;

typedef struct {
    d_uint data[DATA_SIZE];
} BIG_MEM;

// function declarations
void histogram_hls(ac_channel<DATA_MEM> &data_in, ac_channel<HIST_MEM> &hist_out);
void histogram_main(ac_channel<h_uint> &data_in, ac_channel<HIST_MEM> &hist_out);
