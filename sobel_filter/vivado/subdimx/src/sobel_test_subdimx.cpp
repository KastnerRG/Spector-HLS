#include<stdio.h>
#include"sobel.h"
#include<stdlib.h>
#include<iostream>
#include<fstream>


int main()
{

unsigned int * image_in;
image_in=(unsigned int *)malloc(sizeof(unsigned int)*W*H);

unsigned int * image_out;
unsigned int * image_out_ref;

image_out=(unsigned int *)malloc(sizeof(unsigned int)*W*H);
image_out_ref=(unsigned int *)malloc(sizeof(unsigned int)*W*H);

int cnt=0;
FILE *input;
input=fopen("image_in.txt","r");
for(int i=0;i<W*H;i++)
fscanf(input,"%u",&image_in[i]);
fclose(input);



ap_uint<8> image_in_2[H][W];
ap_uint<1> image_out_2[H][W];

for (int i=0;i<H;i++)
	for(int j=0;j<W;j++)
	image_in_2[i][j]=image_in[i*W+j];

sobel_x(image_in_2,image_out_2);


FILE *output_ref;
output_ref=fopen("image_out_ref.txt","r");
for(int i=0;i<W*H;i++)
	fscanf(output_ref,"%u",&image_out_ref[i]);
fclose(output_ref);



for(int i=0;i<H;i++)
{
	for(int j=0;j<W;j++)
	{
		if((i!=0)&&(j!=0)&&(i!=H-1)&&(j!=W-1))
cnt=cnt+(image_out_2[i][j]-image_out_ref[i*W+j])*(image_out_2[i][j]-image_out_ref[i*W+j]);
	}
}
if(cnt)
	printf("FAIL\n");
else
	printf("PASS\n");


return 0;
}
