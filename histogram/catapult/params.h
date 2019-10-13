#ifndef PARAMS_H_
#define PARAMS_H_


#define KNOB_NUM_HIST        8 // actually knob_num_work_items

#define HIST_BIT_SIZE        8
// log2(KNOB_HIST_SIZE)

/* 	
	Currently we use KNOB_HIST_SIZE as 256. Can be extended to 1024
*/

#define KNOB_HIST_SIZE       256

/* 
	DATA_SIZE implies the array size which stores all the data to be passed
	to the histogram function. DATA_SIZE *has* to be divisible by 2 or powers
	of 2. Histogram does not match in case this is not followed.
 */
#define DATA_SIZE			         65536

#define DATA_BIT_SIZE        16   

// used to fill up histograms after leftover loop 1048576
#define LEFTOVER_LOOP 		(DATA_SIZE/(KNOB_NUM_WORK_ITEMS*KNOB_NUM_WORK_GROUPS))%KNOB_NUM_HIST
/*
 * INCR informs the number of increments needed to add to a loop in histogram_hls
 */
#define INCR 				 DATA_SIZE/(KNOB_NUM_WORK_ITEMS*KNOB_NUM_WORK_GROUPS)

#define TRIPCNT				 INCR - KNOB_NUM_HIST + 1
/*
 * PIPE_FACTOR denotes the initiation interval for hist_loop in histogram_hls
 * If 0 it indicates no pipeline directive and more indicates a pipeline pragma
 * in the hist_loop
 */
#define PIPE_FACTOR			 0
/*
 *  UNROLL_FACTOR used for the main histogram loop. Recommended to use either 1
 *  or 2 but not more as it could lead to compiler declining to execute simulation
 *  as unrolling may require too many resources. This is evident when using really
 *  large data sizes. If unroll factor > 1 we will have to make PIPE_FACTOR equal
 *  to 0
 */

// implies each histogram_hls function that will be running
#define KNOB_NUM_WORK_ITEMS  8
// In this case Number of work groups remain one, but each histogram_main function
// acts as a workgroup. This implementation only works for values 1, 2, 4 and 8
#define KNOB_NUM_WORK_GROUPS 1

#define KNOB_SIMD            1
#define KNOB_COMPUTE_UNITS   1

#define KNOB_ACCUM_SMEM      0

#define KNOB_UNROLL_FACTOR   2

/*
 * Used for unrolling loop to transfer values from data to
 * data1 and data2 in a faster way
 */
#define UNROLL_ARR_ASSIGN    8



#define TOTAL_WORK_ITEMS (KNOB_NUM_WORK_ITEMS * KNOB_NUM_WORK_GROUPS)



#endif /* PARAMS_H_ */
