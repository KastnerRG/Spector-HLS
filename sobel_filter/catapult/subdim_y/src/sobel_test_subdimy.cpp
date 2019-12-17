#include<stdio.h>
#include"sobel.h"
#include<stdlib.h>
#include <mc_scverify.h>
CCS_MAIN(int argc, char *argv[])
{

unsigned int * image_in;
unsigned int * image_out;
unsigned int * image_out_ref;
image_in=(unsigned int *)malloc(sizeof(unsigned int)*W*H);
image_out=(unsigned int *)malloc(sizeof(unsigned int)*W*H);
image_out_ref=(unsigned int *)malloc(sizeof(unsigned int)*W*H);

ac_int<32,false> cnt=0;
FILE *input;
input=fopen("/home/siva/Siva/RA/sobel/image_in.txt","r");
for(int i=0;i<W*H;i++)
fscanf(input,"%u",&image_in[i]);
fclose(input);

ac_int<8,false> image_in_2[H][W];
ac_int<1,false> image_out_2[H][W];

for (int i=0;i<H;i++)
	for(int j=0;j<W;j++)
	image_in_2[i][j]=image_in[i*W+j];


CCS_DESIGN(sobel_y)(image_in_2,image_out_2);

FILE *output;
output=fopen("/home/siva/Siva/RA/sobel/image_out_ref.txt","r");
for(int i=0;i<W*H;i++)
	fscanf(output,"%u",&image_out_ref[i]);


for(int i=0;i<H;i++)
	for(int j=0;j<W;j++)
	{
		if(i!=0&&j!=0&&i!=H-1&&j!=W-1)
cnt=cnt+(image_out_2[i][j]-image_out_ref[i*W+j])*(image_out_2[i][j]-image_out_ref[i*W+j]);
	}
printf("%d\n",cnt);
if(cnt)
	printf("FAIL");
else
	printf("PASS");

CCS_RETURN(0);
}
