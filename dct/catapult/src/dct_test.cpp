#include<math.h>
#include<stdlib.h>
#include<stdio.h>
#include"dct.h"
#include"params.h"
#include <mc_scverify.h>
#include<iostream>
void DCT(fl1 [size_im],fl1 [size_im]); 
fl1 mysqrt(fl1 no)
{
   fl1 x=no;
   fl1 y=1;
   fl1 e=0.000001;
   while(x-y>e)
   {
    x=x+y/2;
    y=no/x;   
   }
   return x;
}
CCS_MAIN(int argc, char *argv[])
{
fl1 *h_Input, *h_Output, *h_Outputref;



FILE * input_file;
FILE * ref_file;
FILE * output_file;
ref_file=fopen("ref_output.txt","r");
input_file=fopen("input.txt","r");

	h_Input     = (fl1 *)malloc(imageH * stride * sizeof(fl1));
	h_Output = (fl1 *)malloc(imageH * stride * sizeof(fl1));
	h_Outputref = (fl1 *)malloc(imageH * stride * sizeof(fl1));
	for(int i = 0; i < imageH; i++)
		for(int j = 0; j < imageW; j++)
		{
			fscanf(input_file,"%f",&h_Input[i*stride+j]);
			//h_Input[i*stride+j]=(i*stride)+j;
			fscanf(ref_file,"%f",&h_Outputref[i*stride+j]);

		}

	fclose(ref_file);
	fclose(input_file);
DCT(h_Output,h_Input);
//for(int i = 0; i < imageH; i++)
	//for(int j = 0; j < imageW; j++)
//printf("%f\n",h_Output[i*stride+j]);
		fl1 sum = 0, delta = 0;
		fl1 L2norm;
		for(int i = 0; i < imageH; i++)
		{
			for(int j = 0; j < imageW; j++){
			sum += h_Outputref[i * stride + j] * h_Outputref[i * stride + j];
				delta += (h_Output[i * stride + j] - h_Outputref[i * stride + j]) * (h_Output[i * stride + j] - h_Outputref[i * stride + j]);
			}
		}
		
		std::cout<<delta<<std::endl;
		std::cout<<sum<<std::endl;

		L2norm = mysqrt(delta/sum);
		//printf("Relative L2 norm: %.3e\n\n", L2norm);
        std::cout<<L2norm<<std::endl;
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
