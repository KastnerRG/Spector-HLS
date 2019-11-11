#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "fir_hls.h"
#include <math.h>
using namespace std;

void firCPU(float*, float*, float*, unsigned int, unsigned int, unsigned int);
void elCplxMul(float *, float *, float *, unsigned int);

int main() {

	unsigned int inputLength, filterLength, resultLength, numFilters;
#if __SYNTHESIS__
	float input_arr[1000000], filter_arr[1000000], answer_arr[1000000],
	result_arr[1000000], result2_arr[1000000];
#else
	// input file read
	FILE *fp;
	fp = fopen("input.dat", "r");
	if(fp == NULL) {
		cout<<"ERROR: cannot open file!";
		return 1;
	}
	cout<<"INPUT FILE DETAILS: "<<endl;
	int dim1;
	fscanf(fp, "%d", &dim1);
	cout << "dimensions are "<<dim1<<endl;
	long tlen1=2;
	for(int i=0; i<dim1; i++) {
		int val;
		fscanf(fp, "%d", &val);
		if(i==1)
			inputLength = val;
		tlen1 *= val;
	}
	cout<<"tlen = "<<tlen1<<endl;
	float *input_arr = (float*)calloc(tlen1, sizeof(float));
	for(long i=0; i<tlen1; i++){
		float val;
		fscanf(fp, "%f", &val);
		input_arr[i] = val;
	}
	cout<<input_arr[1]<<"\t"<<input_arr[2]<<"\t"<<endl<<endl;
	fclose(fp);
	// filter file read
	fp = fopen("filter.dat", "r");
		if(fp == NULL) {
			cout<<"ERROR: cannot open file!";
			return 1;
		}
	cout<<"FILTER FILE DETAILS: "<<endl;
	int dim2;
	fscanf(fp, "%d", &dim2);
	cout << "dimensions are "<<dim2<<endl;
	long tlen2=2;
	for(int i=0; i<dim2; i++) {
		int val;
		fscanf(fp, "%d", &val);
		if(i==1)
			filterLength = val;
		else
			numFilters = val;
		tlen2 *= val;
	}
	cout<<"tlen = "<<tlen2<<endl;
	float *filter_arr = (float*)calloc(tlen2, sizeof(float));
	for(long i=0; i<tlen2; i++){
		float val;
		fscanf(fp, "%f", &val);
		filter_arr[i] = val;
	}
	cout<<filter_arr[1]<<"\t"<<filter_arr[2]<<"\t"<<endl<<endl;
	fclose(fp);
	// answer file read
	fp = fopen("answer.dat", "r");
	if(fp == NULL) {
		cout<<"ERROR: cannot open file!";
		return 1;
	}
	cout<<"ANSWER FILE DETAILS: "<<endl;
	int dim3;
	fscanf(fp, "%d", &dim3);
	cout << "dimensions are "<<dim3<<endl;
	long tlen3=2;
	for(int i=0; i<dim3; i++) {
		int val;
		fscanf(fp, "%d", &val);
		if(i==1)
			resultLength = val;
		tlen3 *= val;
	}
	cout<<"tlen = "<<tlen3<<endl;
	float *answer_arr = (float*)calloc(tlen3, sizeof(float));
	for(long i=0; i<tlen3; i++){
		float val;
		fscanf(fp, "%f", &val);
		answer_arr[i] = val;
	}
	cout<<answer_arr[tlen3-1]<<"\t"<<answer_arr[2]<<"\t"<<endl<<endl;
	fclose(fp);
// ============== Reads Complete! ================== //
	float *result_arr = (float*)calloc(tlen3, sizeof(float));
	float *result2_arr = (float*)calloc(tlen3, sizeof(float));

	// create a result array on which results will be copied

	cout<<"numFilters: "<<numFilters<<endl;
	cout<<"FIR CPU TEST RUN" <<endl;
	firCPU(input_arr, filter_arr, result_arr, inputLength, filterLength, numFilters);
	cout<<result_arr[tlen3-1]<<"\t"<<result_arr[2]<<"\t"<<endl<<endl;
	unsigned int paddingEndTotalLength = ceil((filterLength - 1 + inputLength) / float(KNOB_NUM_PARALLEL)) * KNOB_NUM_PARALLEL - inputLength;
	unsigned int paddingCoefLoad = NUM_COEF_LOADS * KNOB_NUM_PARALLEL;
	unsigned int paddedNumInputPoints = inputLength + paddingCoefLoad + paddingEndTotalLength;
	unsigned int totalDataInputLengthKernelArg = (paddedNumInputPoints * (FILTER_NO / TOTAL_WORK_ITEMS));
	unsigned int numIterationsKernelArg = totalDataInputLengthKernelArg / KNOB_NUM_PARALLEL;
	unsigned int paddedSingleInputLengthMinus1KernelArg = paddedNumInputPoints - KNOB_NUM_PARALLEL;
	unsigned int extraPadding = paddingEndTotalLength - (filterLength - 1);
	// padded number of points per filter, 16 points of zero when we are loading
	// the filter coefficients and 127 points of zero at the end when we're
	// computing the tail end for the result
	//each point is a complex, so need to multiply be 2 (for real, imag)
	unsigned int paddedSingleInputLength = 2 * paddedNumInputPoints;
	//this is the size of the input data buffers we need to allocate
	unsigned int totalDataInputLength = paddedSingleInputLength * numFilters;
	//this is the number of total points we are computing
	// these are just 1 less than the padded single input points, used as a parameter
	// for the kernel to know when to start loading in the next set of filter
	// coefficients
	unsigned int totalFiltersLengthKernelArg = filterLength * (numFilters / TOTAL_WORK_ITEMS);
	cout << paddingCoefLoad << "  " << inputLength << "  " << paddingEndTotalLength << endl;
    // we pad the beginning of the result buffer with 16 complex points of zero
	unsigned int paddedNumResultLength = 2*(resultLength+extraPadding+paddingCoefLoad);
	float *paddedInputPtr = (float* ) calloc(totalDataInputLength, sizeof(float));
	memset(paddedInputPtr, '\0', sizeof(float) * totalDataInputLength);

	// Need to copy the input data into the padded structure
	// (with an offset of 16 complex points)
	for (int filter = 0; filter < numFilters; filter++)
	{
		memcpy(paddedInputPtr + filter * paddedSingleInputLength + 2*paddingCoefLoad,
		       input_arr + (filter * (2*inputLength)),
		       sizeof(float) * 2 * inputLength);
	}

	float* paddedResultPtr = (float* ) calloc(paddedNumResultLength *numFilters, sizeof(float));
	memset(paddedResultPtr, '\0', sizeof(float) * paddedNumResultLength * numFilters);
	cout<<"padded: "<<paddedNumResultLength*numFilters<<" "<<totalDataInputLength<<endl;
#endif
#if ___SYNTHESIS__
	float paddedInputPtr[541696], paddedResultPtr[541696];
#endif
	fir_hls(paddedInputPtr, filter_arr, paddedResultPtr, totalDataInputLengthKernelArg, paddedSingleInputLengthMinus1KernelArg, totalFiltersLengthKernelArg);
	cout<<"FIR FPGA TEST RUN" <<endl;
	for(int i=0; i<512; i++){
	cout<<paddedResultPtr[i]<<endl;
	}
	//for(int i=0; i<tlen3-1; i++){
	//	if(result2_arr[i]!=result_arr[i]){
	//		cout<<"ERROR: MISMATCH\t FPGA: "<<result2_arr[i]<<" CPU: "<<result_arr[i]<<endl;
	//	}
	//}
	return 0;
}

void firCPU(float* input_arr, float* filter_arr, float* result_arr, 
	unsigned int inputlength, unsigned int filterlength, unsigned int numFilters)
{
  int index;
  int filter;
  float *inputPtr  = input_arr;
  float *filterPtr = filter_arr;
  float *resultPtr = result_arr;
  float *inputPtrSave  = input_arr;
  float *filterPtrSave = filter_arr;
  float *resultPtrSave = result_arr;
  unsigned int  filterLength = filterlength;
  unsigned int  inputLength  = inputlength;
  unsigned int  resultLength = filterLength + inputLength - 1;
//  double startTime = getCurrentTimestamp();
 // double stopTime = 0.0f;

  for(filter = 0; filter < numFilters; filter++)
  {
    inputPtr  = inputPtrSave  + (filter * (2*inputLength)); 
    filterPtr = filterPtrSave + (filter * (2*filterLength)); 
    resultPtr = resultPtrSave + (filter * (2*resultLength));

    /*
    	elCplxMul does an element wise multiply of the current filter element by
    	the entire input vector.
    	Input Parameters:
    	tdFirVars->input.data  - pointer to input
    	tdFirVars->filter.data - pointer to filter
    	tdFirVars->result.data - pointer to result space
    	tdFirVars->inputLength - integer value representing length of input
     */
    for(index = 0; index < filterLength; index++)
	  {
  	  elCplxMul(inputPtr, filterPtr, resultPtr, inputLength);
  	  resultPtr+=2;
  	  filterPtr+=2;
  	}/* end for filterLength*/
  }/* end for each filter */

  /*
    Stop the timer.  Print out the
    total time in Seconds it took to do the TDFIR.
  */
  //printf("Done.\n  Latency: %f s.\n", tdFirVars->time.data[0])
  //printf("  Throughput: %.3f GFLOPs.\n", 268.44f / tdFirVars->time.data[0] / 1000.0f );
}

void elCplxMul(float *dataPtr, float *filterPtr, float *resultPtr, unsigned int inputLength)
{
  int index;
  float filterReal = *filterPtr; 
  float filterImag = *(filterPtr+1);

  for(index = 0; index < inputLength; index++)
  {
    /*      COMPLEX MULTIPLY   */
    /* real  */
    *resultPtr += (*dataPtr) * filterReal - (*(dataPtr+1)) * filterImag;
    resultPtr++;
    /* imag  */
    *resultPtr += (*dataPtr) * filterImag + (*(dataPtr+1)) * filterReal;
    resultPtr++;
    dataPtr+=2;
  }
}
