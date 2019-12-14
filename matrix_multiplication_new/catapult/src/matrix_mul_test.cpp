#include<iostream>
#include "matrix_mul.h"
#include"params.h"

void matrix_mul(dtype* ,dtype [MVAL*MVAL],dtype [MVAL*MVAL]);

CCS_MAIN(int argc, char **argv)
{
	int ct=0;
	static ac_channel<dtype> A;
	dtype *B=(dtype*)(malloc(sizeof(dtype)*MVAL*MVAL));
	dtype *Cref=(dtype*)(malloc(sizeof(dtype)*MVAL*MVAL));
	dtype *C=(dtype*)(calloc(MVAL*MVAL,sizeof(dtype)));
	FILE* fa =fopen("A_input_1024.txt","r");
	FILE* fb =fopen("B_input_1024.txt","r");
	FILE *fc=fopen("C_ref_1024.txt","r");
	FILE *fd=fopen("C_out.txt","w");
	dtype buf;
	for(int i=0;i<MVAL*MVAL;i++)
	{
		fscanf(fa,"%f",&buf);
		A.write(buf);
		fscanf(fb,"%f",&B[i]);
		fscanf(fc,"%f",&Cref[i]);
	}
	fclose(fa);
	fclose(fb);
	fclose(fc);

  CCS_DESIGN (matrix_mul) (A, B, C);
	for(int i=0;i<MVAL*MVAL;i++)
		fprintf(fd,"%.3f\n",C[i]);
	fclose(fd);
	fd=fopen("C_out.txt","r");
	for(int i=0;i<MVAL*MVAL;i++)
		fscanf(fd,"%f",&C[i]);
	fclose(fd);
	for(int i=0;i<MVAL*MVAL;i++)
	if(abs(C[i]-Cref[i])<=0.002)
		ct++;
	else
		std::cout<<C[i]<<" "<<Cref[i]<<std::endl;
	if (ct==MVAL*MVAL)
		std::cout<<"PASS"<<std::endl;
	else
		std::cout<<"FAIL"<<std::endl;
	std::cout<<ct;
	return 0;
}
