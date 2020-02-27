#include "fpga_temp_matching.h"

#pragma design top
void SAD_MATCH(axis_t INPUT[size_m], axis_t OUTPUT[size_m]){
	
	axis_t templ[tmpsize];
	loop_tmpz:for(unsigned i=0; i<tmpsize; i++)
		templ[i] = 0;
	axis_t row_buf[tmpdim][tmpdim];
	axis_t win_buf[tmpdim][tmpdim];
    axis_t cur;
	int cur_data;
	int out[size_m];
	int i = 0, j = 0, k = 0, o = 0, m = 0, n = 0, l = 0;
	// Pull next pixel into buffer
	loop_1:for (i = 0; i < size_m; i++) {
		cur = INPUT[i];
		cur_data = cur;
		row_buf[tmpdim-1][k] = cur_data;
		// shift window
		loop_2:for (m = 0; m < tmpdim-1; m++) {
			loop_3:for (n = 0; n < tmpdim; n++) {
				win_buf[n][m] = win_buf[n][m+1];
			}
		}
		// pull column from buffer into window
		loop_4:for (l = 0; l < tmpdim; l++) {
			win_buf[l][tmpdim-1] = row_buf[l][k];
		}
		// SAD (Sum of Absolute Differences)
	    int y, z, sad = 0;
	    int absl = 0;
	    loop_5:for (y = 0; y < tmpdim; y++) {
	        loop_6:for (z = 0; z < tmpdim; z++) {
	            absl = win_buf[y][z]-templ[z+tmpdim*y] > 0 ? (int)(win_buf[y][z]-templ[z+tmpdim*y]) : (int)(win_buf[y][z]-templ[z+tmpdim*y] * -1);
	            sad+= absl;
	        }
	    }
	    out[i] = (sad < thre ? 1:0);
		// if the buffer row is filled, shift buffer row up by 1
	    k++;
		if (k == indim) {
			k = 0;
			loop_7:for (j = 0; j < tmpdim - 1; j++){
				loop_8:for(o = 0; o < indim; o++) {
					row_buf[j][o] = row_buf[j+1][o];
				}
			}
		}
    cur = out[i];
    OUTPUT[i] = cur;
	}
}
