#include<math.h>
#include<stdlib.h>
#include<stdio.h>
#include"dct.h"
//#include"params.h"


int main()
{
int *h_Input, *h_Output, *h_Outputref;



FILE * input_file;
FILE * ref_file;
FILE * output_file;
ref_file=fopen("ref_output.txt","r");
input_file=fopen("input.txt","r");

	h_Input     = (int *)malloc(imageH * stride * sizeof(int));
	h_Output = (int *)malloc(imageH * stride * sizeof(int));
	h_Outputref = (int *)malloc(imageH * stride * sizeof(int));
	for(int i = 0; i < imageH; i++)
		for(int j = 0; j < imageW; j++)
		{
			fscanf(input_file,"%d",&h_Input[i*stride+j]);
			//h_Input[i*stride+j]=(i*stride)+j;
			fscanf(ref_file,"%d",&h_Outputref[i*stride+j]);

		}

	fclose(ref_file);
	fclose(input_file);
DCT(h_Output,h_Input);
//for(int i = 0; i < imageH; i++)
	//for(int j = 0; j < imageW; j++)
//printf("%f\n",h_Output[i*stride+j]);
		double sum = 0, delta = 0;
		double L2norm;
		for(int i = 0; i < imageH; i++)
		{
			for(int j = 0; j < imageW; j++){
			sum += h_Outputref[i * stride + j] * h_Outputref[i * stride + j];
				delta += (h_Output[i * stride + j] - h_Outputref[i * stride + j]) * (h_Output[i * stride + j] - h_Outputref[i * stride + j]);
			}
		}

		L2norm = sqrt(delta / sum);
		printf("Relative L2 norm: %.3e\n\n", L2norm);

		if (L2norm <0.001)
		{
			printf("PASSED!\n");
		}
		else
		{
			printf("FAILED!\n");
		}



return 0;
}
