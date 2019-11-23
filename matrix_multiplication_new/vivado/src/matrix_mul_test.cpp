#include<iostream>
#include "matrix_mul.h"
#include"params.h"
void matrix_mul(dtype* ,float [M*M],float [M*M]);
int main()
{
	int ct=0;
dtype *A=(dtype*)(malloc(sizeof(dtype)*M*M));
float *B=(float*)(malloc(sizeof(float)*M*M));
float *Cref=(float*)(malloc(sizeof(float)*M*M));
float *C=(float*)(calloc(M*M,sizeof(float)));
FILE* fa =fopen("A_input_1024.txt","r");
FILE* fb =fopen("B_input_1024.txt","r");
FILE *fc=fopen("C_ref_1024.txt","r");
FILE *fd=fopen("C_out.txt","w");
for(int i=0;i<M*M;i++)
{
	fscanf(fa,"%f",&A[i].data);
	fscanf(fb,"%f",&B[i]);
	fscanf(fc,"%f",&Cref[i]);
}
	fclose(fa);
	fclose(fb);
	fclose(fc);

matrix_mul(A,B,C);
for(int i=0;i<M*M;i++)
	fprintf(fd,"%.3f\n",C[i]);
fclose(fd);
fd=fopen("C_out.txt","r");
for(int i=0;i<M*M;i++)
	fscanf(fd,"%f",&C[i]);
fclose(fd);
for(int i=0;i<M*M;i++)
if(abs(C[i]-Cref[i])<=0.002)
ct++;
else
	std::cout<<C[i]<<" "<<Cref[i]<<std::endl;
	if (ct==M*M)
	std::cout<<"PASS"<<std::endl;
else
	std::cout<<"FAIL"<<std::endl;
std::cout<<ct;
return 0;
	}
