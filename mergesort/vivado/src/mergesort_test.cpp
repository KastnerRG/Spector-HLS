#include"params.h"
#include<iostream>
void mergesort(int[],int[]);
int main()
{
srand(2009);
	int in[no_size],out[no_size];
	for(int i=0;i<no_size;i++)
		in[i]=rand();
int ct=0;

	mergesort(in,out);


	for(int i=0;i<no_size;i++)
	if(out[i]<=out[i+1])
		ct++;
	if(ct==no_size-1)
		std::cout<<"PASS"<<std::endl;
	else
	{
		std::cout<<"FAIL"<<std::endl;
		std::cout<<ct<<std::endl;
	}
		return 0;
}
