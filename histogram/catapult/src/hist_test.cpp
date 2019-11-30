#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <mc_scverify.h>

#include "params.h"
#include "histogram_hls.h"

using namespace std;
void histogram_cpu(unsigned char data[DATA_SIZE], unsigned int hist[KNOB_HIST_SIZE], unsigned long value){
for(int i=0; i<KNOB_HIST_SIZE; i++){
	hist[i] = 0;
}
for(unsigned long i=0; i<value;i++){
	hist[data[i]]++;
}
}

CCS_MAIN(int argc, char **argv) {
	unsigned char inputData[DATA_SIZE];
	static ac_channel<uint9> input_hls;
	FILE *fp;
	fp = fopen("input.dat", "r");
	if (fp == NULL) {
		cout<<"Error while opening file";
		return 1;
	}
	int arr;
	for(int i=0; i<DATA_SIZE; i++){
	fscanf(fp, "%d", &arr);
	input_hls.write(arr);
	inputData[i] = arr;
	}
	fclose(fp);

	unsigned int histogram_check[KNOB_HIST_SIZE];
	uint17 histogram[KNOB_HIST_SIZE];	
	CCS_DESIGN(histogram_hls) (input_hls, histogram);
	histogram_cpu(inputData, histogram_check, DATA_SIZE);
	for(int i=0; i<256; i++) {
		if(histogram[i] != histogram_check[i]){
			printf("ERROR: HISTOGRAM NOT MATCHING!\t");
		}
	}
	printf("HISTOGRAM MATCHES!");
	return 0;

}

