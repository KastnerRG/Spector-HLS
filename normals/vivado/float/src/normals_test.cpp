#include<fstream>
#include<iostream>
#include<cmath>
#include"params.h"
void normals(float*,float*);
float *h_vmap=(float*)malloc(rows*cols*3*sizeof(float));
float *h_nmaps=(float*)malloc(rows*cols*3*sizeof(float));
float *h_output=(float*)malloc(rows*cols*3*sizeof(float));
int main()
{
std::ifstream file("./vmap2.bin", std::ifstream::binary|std::ifstream::in);
file.read((char*)h_vmap, cols*rows*3*sizeof(float));
file.close();

std::ifstream file2("./nmap2.bin", std::ifstream::binary|std::ifstream::in);
file2.read((char*)h_nmaps, cols*rows*3*sizeof(float));
file2.close();
normals(h_vmap,h_output);

bool passed=true;
float epsilon = 0.0001;
for(int i=0;i<(rows*cols)&&passed;i++)
{
	bool nmaps_isnan  = std::isnan(h_nmaps[i*3]);
			bool output_isnan = std::isnan(h_output[i*3]);

			if( (nmaps_isnan && !output_isnan) || (!nmaps_isnan && output_isnan) )
			{
				passed = false;
			}
			else if(!nmaps_isnan && !output_isnan)
			{
				bool passed0 = std::abs(h_nmaps[i*3+0] - h_output[i*3+0]) < epsilon;
				bool passed1 = std::abs(h_nmaps[i*3+1] - h_output[i*3+1]) < epsilon;
				bool passed2 = std::abs(h_nmaps[i*3+2] - h_output[i*3+2]) < epsilon;

				passed = passed && passed0 && passed1 && passed2;

			}

			if(!passed)
			{
				std::cout << "\nground_truth |  calculated   at " << i << std::endl;
				for(int j = 0; j < 3; j++)
				{
					std::cout << h_nmaps[i*3+j] << " | " << h_output[i*3+j] << std::endl;
				}
				std::cout << std::endl;

				//debug
				std::cout << h_vmap[(i)*3+0] << " " << h_vmap[(i)*3+1] << " " << h_vmap[(i)*3+2] << std::endl << std::endl;
				std::cout << h_vmap[(i)*3+3] << " " << h_vmap[(i)*3+4] << " " << h_vmap[(i)*3+5] << std::endl << std::endl;
				std::cout << h_vmap[(i+cols)*3+0] << " " << h_vmap[(i+cols)*3+1] << " " << h_vmap[(i+cols)*3+2] << std::endl << std::endl;
			}
		}

		std::cout << "Verification: " << (passed? "Passed": "Failed") << std::endl;
return 0;
}
