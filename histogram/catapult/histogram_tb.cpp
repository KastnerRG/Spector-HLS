#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <mc_scverify.h>

#include "histogram.h"

using namespace std;

void histogram_cpu(h_uint data[DATA_SIZE], d_uint hist[KNOB_HIST_SIZE], unsigned long data_size)
{
    for(int i=0; i<KNOB_HIST_SIZE; i++){
        hist[i] = 0;
    }
    for(unsigned long i=0; i<data_size;i++){
        hist[data[i]]++;
    }
}

CCS_MAIN(int argc, char **argv)
{
    static ac_channel<h_uint> inputData;
    h_uint inputDataCheck[DATA_SIZE];
    FILE *fp;
    fp = fopen("input.dat", "r");
    if(fp == NULL) {
        cerr << "ERROR: Cannot open file";
        return 1;
    }
    int arr;
    for(int i=0; i<DATA_SIZE; i++) {
        fscanf(fp, "%d", &arr);
        inputData.write(arr);
        inputDataCheck[i] = arr;
    }
    fclose(fp);
    
    static ac_channel<HIST_MEM> histogram;
    d_uint histogram_check[KNOB_HIST_SIZE];
    CCS_DESIGN(histogram_main) (inputData, histogram);
    histogram_cpu(inputDataCheck, histogram_check, DATA_SIZE);
    bool success=true;
    HIST_MEM histp = histogram.read();
    for(int i=0; i<KNOB_HIST_SIZE-1; i++) {
		if(histp.data[i] != histogram_check[i]){
			printf("ERROR: HISTOGRAM NOT MATCHING!\t");
			printf("array no: %d\thist_cpu: %d\t hist_hls: %d\n", i, histogram_check[i], histogram[i]);
			bool = false;
		}
	}
	if(success)
	   printf("HISTOGRAM MATCHES!\n");
    CCS_RETURN(0);
}
