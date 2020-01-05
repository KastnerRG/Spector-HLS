#include "fpga_temp_matching.h"

int main() {

	axis_t * INPUT;
	INPUT=(axis_t *)malloc(sizeof(axis_t)*size);
	axis_t * OUTPUT;
	OUTPUT=(axis_t *)malloc(sizeof(axis_t)*size);
	axis_t * OUTPUT_REF;
	OUTPUT_REF=(axis_t *)malloc(sizeof(axis_t)*size);



	int i,ct=0;


	FILE *f_in,*f_ref;
	if(indim==400)
	{
	f_in=fopen("img_400_400.txt","r");
	if(tmpdim==20)
		f_ref=fopen("out_ref_400_400_20.txt","r");
	else if(tmpdim==10)
		f_ref=fopen("out_ref_400_400_10.txt","r");
	else if(tmpdim==5)
		f_ref=fopen("out_ref_400_400_5.txt","r");
	}
	else if(indim==200)
	{
		f_in=fopen("img_200_200.txt","r");
		if(tmpdim==20)
			f_ref=fopen("out_ref_200_200_20.txt","r");
		else if(tmpdim==10)
			f_ref=fopen("out_ref_200_200_10.txt","r");
		else if(tmpdim==5)
			f_ref=fopen("out_ref_200_200_5.txt","r");
	}
	else if(indim==100)
	{
		f_in=fopen("img_100_100.txt","r");
		if(tmpdim==20)
			f_ref=fopen("out_ref_100_100_20.txt","r");
		else if(tmpdim==10)
			f_ref=fopen("out_ref_100_100_10.txt","r");
		else if(tmpdim==5)
			f_ref=fopen("out_ref_100_100_5.txt","r");
	}



	for (i = 0; i < size; i++) {
		fscanf(f_in,"%u",&INPUT[i].data);
	}
	fclose(f_in);



	for (i = 0; i < size; i++) {
		fscanf(f_ref,"%u",&OUTPUT_REF[i].data);
	}
	fclose(f_ref);

	SAD_MATCH(INPUT, OUTPUT);

	for(i=0;i<size;i++)
	if (OUTPUT[i].data==OUTPUT_REF[i].data)
	ct++;	
	if(ct==size)
	printf("PASS");
else
	printf("FAIL");

	return 0;

}
