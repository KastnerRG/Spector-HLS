#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include "params.h"

using namespace std;
void histogram_main(unsigned char *, unsigned int *);
void histogram_hls(unsigned char *, unsigned int *, unsigned long);
void histogram_cpu(unsigned char data[DATA_SIZE], unsigned int hist[KNOB_HIST_SIZE], unsigned long value){
for(int i=0; i<KNOB_HIST_SIZE; i++){
	hist[i] = 0;
}
for(unsigned long i=0; i<value;i++){
	hist[data[i]]++;
}
}
int main() {
	unsigned char inputData[DATA_SIZE];
	FILE *fp;
	fp = fopen("input.dat", "r");
	if (fp == NULL) {
		cout<<"Error while opening file";
		return 1;
	}
	int arr;
	for(int i=0; i<DATA_SIZE; i++){
	fscanf(fp, "%d", &arr);
	inputData[i] = arr;
	}
	fclose(fp);

	unsigned int histogram[KNOB_HIST_SIZE], histogram_check[KNOB_HIST_SIZE];
	histogram_main(inputData, histogram);
	histogram_cpu(inputData, histogram_check, DATA_SIZE);
	for(int i=0; i<255; i++) {
		if(histogram[i] != histogram_check[i]){
			printf("ERROR: HISTOGRAM NOT MATCHING!\t");
			printf("array no: %d\thist_cpu: %d\t hist_hls: %d\n", i, histogram_check[i], histogram[i]);
		}
	}
	printf("HISTOGRAM MATCHES!");
	return 0;

}


