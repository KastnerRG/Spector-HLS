#include <ac_int.h>
#include <ac_channel.h>
#define DATA_SIZE	65536

#define KNOB_HIST_SIZE	256

#define KNOB_NUM_HIST	3
#define LEFTOVER_LOOP	DATA_SIZE % KNOB_NUM_HIST
#define TRIPCNT		DATA_SIZE - KNOB_NUM_HIST + 1

typedef ac_int<9, false> uint9;
typedef ac_int<17, false> uint17;

typedef struct {
    uint9 data[DATA_SIZE];
} DATA_MEM;
void histogram_hls(ac_channel<uint9> &data_in, uint17 hist[KNOB_HIST_SIZE]);

