/*
	Filename: fir_test.h
		FIR lab wirtten for WES237C class at UCSD.
		Testbench file
		Calls fir() function from fir.cpp
		Compares the output from fir() with out.gold.dat
*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "fir.h"


struct Rmse
{
	int num_sq;
	float sum_sq;
	float error;

	Rmse(){ num_sq = 0; sum_sq = 0; error = 0; }

	float add_value(float d_n)
	{
		num_sq++;
		sum_sq += (d_n*d_n);
		error = sqrtf(sum_sq / num_sq);
		return error;
	}

};

Rmse rmse_calc;

int main ()
{
  float golden_X[1024], golden_Y[1024];
  float diff, rms_error = 0;


  const int SAMPLES = 1024;

  const int print_results = 0;

  data_t signal_I[1024]={0}, signal_Q[1024]={0};
  data_t output_X[1024], output_Y[1024];

  int i;


  FILE * fpg  = fopen("out.gold.dat","r");
  FILE * finI = fopen("input_i.dat","r");
  FILE * finQ = fopen("input_q.dat","r");
  FILE * fp   = fopen("out.dat","w");

  for(i = 0; i < SAMPLES; i++)
  {
	  fscanf(finI,"%f", &signal_I[i].data);
	  fscanf(finQ,"%f", &signal_Q[i].data);
	  fscanf(fpg, "%f %f", &golden_X[i], &golden_Y[i]);
  }
	  // Call the HLS block
	  fir(signal_I, signal_Q, output_X, output_Y);
for(i=0;i<SAMPLES;i++)
{
	  // Calculating RMSE
	  diff = sqrtf( (((float)output_X[i].data - golden_X[i]) * ((float)output_X[i].data - golden_X[i]))
			      + (((float)output_Y[i].data - golden_Y[i]) * ((float)output_Y[i].data - golden_Y[i])) );
	  rms_error = rmse_calc.add_value(diff);

	  // Save the results.
	  fprintf(fp,"%f %f\n",(float)output_X[i].data, (float)output_Y[i].data);

	  /*if(print_results)
	  {
		  printf("%i, %f, %f, %f, %f,\n", i, signal_I, signal_Q, (float)output_X, (float)output_Y);
	  }*/
  }

  fclose(fpg);
  fclose(fp);
  fclose(finQ);
  fclose(finI);


  printf("RMSE\n");
  printf("%.15f\n", rms_error);

  float error_threshold = 0.001;

  int success = (rms_error < error_threshold);

  if (success) return 0;
  else return 1;

}
