#include"sobel.h"
void sobel_x(ac_int<8,false> input_image[H][W],ac_int<1,false> output_image[H][W])
{
//directive set input_image:resc -BLOCK_SIZE 10

	int sobel_y_kernel[3][3]={{-1,0,1},{-2,0,2},{-1,0,1}};
	int sobel_x_kernel[3][3]={{-1,-2,-1},{0,0,0},{1,2,1}};
     int luma;
     unsigned int pixel;
     unsigned int clamped;
     int temp;
     int image_reg[3][3];
     unsigned int b,g,r;
    for (int i=1;i<H-1;i++)
    {
        for(int j=1;j<W-1;j=j+subdim_x)
        {

        image_reg[0][0]=input_image[((i-1))][j-1];
        image_reg[0][1]=input_image[((i-1))][j];
        image_reg[0][2]=input_image[((i-1))][j+1];
        image_reg[1][0]=input_image[i][j-1];
        image_reg[1][1]=input_image[i][j];
        image_reg[1][2]=input_image[i][j+1];
        image_reg[2][0]=input_image[(i+1)][j-1];
        image_reg[2][1]=input_image[(i+1)][j];
        image_reg[2][2]=input_image[(i+1)][j+1];

        for(int k=0;k<subdim_x;k++)
        {
            int resultx=0;
            int resulty=0;
            
            for (int m=0;m<3;m++)
			{
				for (int n=0;n<3;n++)
				{
				    #pragma hls_uroll 
					pixel = image_reg[m][n];
					b = pixel & 0xff;
					g = (pixel >> 8) & 0xff;
					r = (pixel >> 16) & 0xff;

					luma = r * 66 + g * 129 + b * 25;
					luma = (luma + 128) >> 8;
					luma =luma + 16;

					resultx=resultx+sobel_x_kernel[m][n]*luma;
					resulty=resulty+sobel_y_kernel[m][n]*luma;
					//printf("%d ",pixel);
				}
				//printf("\n");
			}
            //printf("\n");
			resultx=resultx>0?resultx*1:resultx*-1;
			resulty=resulty>0?resulty*1:resulty*-1;
			temp=resultx+resulty;
			clamped=temp>32?1:0;

			output_image[i][j+k]=clamped;

			if (k+1<subdim_x)
			{
				//shift the reg col
				image_reg[0][0]=image_reg[0][1];
				image_reg[1][0]=image_reg[1][1];
				image_reg[2][0]=image_reg[2][1];

				image_reg[0][1]=image_reg[0][2];
				image_reg[1][1]=image_reg[1][2];
				image_reg[2][1]=image_reg[2][2];
				
				image_reg[0][2]=input_image[(i-1)][j+(k+1)+1];
				image_reg[1][2]=input_image[i][j+(k+1)+1];
				image_reg[2][2]=input_image[(i+1)][j+(k+1)+1];
			}
			if(j+k+2==W)
				break;
        }

    }
  }


}
