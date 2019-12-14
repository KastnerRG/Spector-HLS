#include<iostream>
#include "matrix_mul.h"
#include"params.h"
void matrix_mul(dtype* ,int [M*M],int [M*M]);
int main()
{
	int ct=0;int fail=0;
dtype *A=(dtype*)(malloc(sizeof(dtype)*M*M));
int *B=(int*)(malloc(sizeof(int)*M*M));
int *Cref=(int*)(malloc(sizeof(int)*M*M));
int *C=(int*)(calloc(M*M,sizeof(int)));
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
	if (ct==M*M)
	std::cout<<"PASS"<<std::endl;
else
fail=1;
if(fail==1)
	std::cout<<"FAIL"<<std::endl;
std::cout<<ct;
return 0;
	}
