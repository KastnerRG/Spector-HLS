#include "my_spmv_common.h"
#include <iostream>
#include <mc_scverify.h>
#include<math.h>
void spmv(int*,int*,FLOAT_VECT*,FLOAT_VECT*,FLOAT_VECT*);
#define NUM_REP 1000
void check(int b,const char* msg)
{
	if(!b)
	{
		fprintf(stderr,"error: %s\n\n",msg);
		exit(-1);
	}
}


int* int_new_array(const size_t N,const char* error_msg)
{
	int* ptr;
	int err;

	ptr = (int*)malloc(N * sizeof(int));
	check(ptr != NULL,error_msg);

	return ptr;
}

long* long_new_array(const size_t N,const char* error_msg)
{
	long* ptr;
	int err;
	ptr = (long*)malloc(N * sizeof(long));
	check(ptr != NULL,error_msg);

	return ptr;
}



FLOAT_VECT* float_new_array(const size_t N,const char* error_msg)
{
	FLOAT_VECT* ptr;
	int err;

	ptr = (FLOAT_VECT*)malloc(N * sizeof(FLOAT_VECT));
	check(ptr != NULL,error_msg);

	return ptr;
}


FLOAT_VECT* float_array_realloc(FLOAT_VECT* ptr,const size_t N,const char* error_msg)
{
	int err;

	ptr = (FLOAT_VECT*)realloc(ptr,N * sizeof(FLOAT_VECT));
	check(ptr != NULL,error_msg);

	return ptr;
}


/**
 * Compares N float values and prints error msg if any corresponding entries differ by greater than .001
 */
int float_array_comp(const FLOAT_VECT* control, const FLOAT_VECT* experimental, const unsigned int N, const unsigned int exec_num)
{
	unsigned int j;
	FLOAT_VECT diff,perc;
	for (j = 0; j < N; j++)
	{
		diff = experimental[j] - control[j];
		FLOAT_VECT tm=-1;
		diff=diff>FLOAT_VECT(0)?diff:FLOAT_VECT(diff*tm);
		if( diff> FLOAT_VECT(.0001))
		{
		    FLOAT_VECT tm1=FLOAT_VECT(diff/control[j]);
		    tm1=tm1>FLOAT_VECT(0)?tm1:FLOAT_VECT(tm1*tm);
			perc = tm1 * 100;
			//fprintf(stderr,"Possible error on exec #%u, difference of %.3f (%.1f%% error) [control=%.3f, experimental=%.3f] at row %d \n",exec_num,diff,perc,control[j],experimental[j],j);
			return 1;
		}
	}
	return 0;
}


/**
 * Sparse Matrix-Vector Multiply
 *
 * Multiplies csr matrix by vector x, adds vector y, and stores output in vector out
 */
void spmv_csr_cpu(const csr_matrix* csr,const FLOAT_VECT* x,const FLOAT_VECT* y,FLOAT_VECT* out)
{
	unsigned int row,row_start,row_end,jj;
	FLOAT_VECT sum = 0;
	for(row=0; row < csr->num_rows; row++)
	{
		sum = y[row];
		row_start = csr->Ap[row];
		row_end   = csr->Ap[row+1];

		for (jj = row_start; jj < row_end; jj++){
			sum += csr->Ax[jj] * x[csr->Aj[jj]];
		}
		out[row] = sum;
	}
}

csr_matrix* read_csr(unsigned int* num_csr,const char* file_path)
{
	FILE* fp;
	int i,j,read_count;
	csr_matrix* csr;

	check(num_csr != NULL,"sparse_formats.read_csr() - ptr to num_csr is NULL!");

	fp = fopen(file_path,"r");
	check(fp != NULL,"sparse_formats.read_csr() - Cannot Open Input File");

	read_count = fscanf(fp,"%u\n\n",num_csr);
	check(read_count == 1,"sparse_formats.read_csr() - Input File Corrupted! Read count for num_csr differs from 1");
	csr = (csr_matrix*)malloc(sizeof(struct csr_matrix)*(*num_csr));

	for(j=0; j<*num_csr; j++)
	{
		read_count = fscanf(fp,"%u\n%u\n%u\n%u\n%lf\n%lf\n%lf\n",&(csr[j].num_rows),&(csr[j].num_cols),&(csr[j].num_nonzeros),&(csr[j].density_ppm),&(csr[j].density_perc),&(csr[j].nz_per_row),&(csr[j].stddev));
		check(read_count == 7,"sparse_formats.read_csr() - Input File Corrupted! Read count for header info differs from 7");

		read_count = 0;
		csr[j].Ap = int_new_array(csr[j].num_rows+1,"sparse_formats.read_csr() - Heap Overflow! Cannot allocate space for csr.Ap");
		for(i=0; i<=csr[j].num_rows; i++)
			read_count += fscanf(fp,"%u ",csr[j].Ap+i);
		check(read_count == (csr[j].num_rows+1),"sparse_formats.read_csr() - Input File Corrupted! Read count for Ap differs from csr[j].num_rows+1");

		read_count = 0;
		csr[j].Aj = int_new_array(csr[j].num_nonzeros,"sparse_formats.read_csr() - Heap Overflow! Cannot allocate space for csr.Aj");
		for(i=0; i<csr[j].num_nonzeros; i++)
			read_count += fscanf(fp,"%u ",csr[j].Aj+i);
		check(read_count == (csr[j].num_nonzeros),"sparse_formats.read_csr() - Input File Corrupted! Read count for Aj differs from csr[j].num_nonzeros");

		read_count = 0;
		csr[j].Ax = float_new_array(csr[j].num_nonzeros,"sparse_formats.read_csr() - Heap Overflow! Cannot allocate space for csr.Ax");
		for(i=0; i<csr[j].num_nonzeros; i++)
			read_count += fscanf(fp,"%f ",csr[j].Ax+i);
		check(read_count == (csr[j].num_nonzeros),"sparse_formats.read_csr() - Input File Corrupted! Read count for Ax differs from csr[j].num_nonzeros");
	}

	fclose(fp);
	return csr;
}


void free_csr(csr_matrix* csr,const unsigned int num_csr)
{
	int k;
	for(k=0; k<num_csr; k++)
	{
		free(csr[k].Ap);
		free(csr[k].Aj);
		free(csr[k].Ax);
	}
	free(csr);
}

CCS_MAIN(int argc, char *argv[])
{
	int result_error=0;
	FILE * fp=NULL;

	unsigned int num_matrices;


	csr_matrix * csr = read_csr(&num_matrices,"./csrmatrix_R1_N512_D5000_S01");

	int num_rows=csr[0].num_rows;
	int num_cols=csr[0].num_cols;
	//read csr
	//read x
	FLOAT_VECT * x_host=(FLOAT_VECT *)malloc(sizeof(FLOAT_VECT)*num_cols);

	for(unsigned int i = 0; i < num_cols; i++)
	{
		x_host[i] = ((FLOAT_VECT)i)*(FLOAT_VECT)(0.035);
	}

int ct=0;
	//read y
	FLOAT_VECT * y_host=(FLOAT_VECT *)malloc(sizeof(FLOAT_VECT)*num_rows);

	for(unsigned int i = 0; i < num_rows; i++)
	{
		y_host[i] = ((FLOAT_VECT)i)*(FLOAT_VECT)0.016;
	}
	for(int k=0; k<num_matrices; k++)
		{
		FLOAT_VECT* device_out=(FLOAT_VECT*)malloc(sizeof(FLOAT_VECT)*csr[k].num_rows);
			FLOAT_VECT * host_out = (FLOAT_VECT*)malloc(sizeof(FLOAT_VECT)*csr[k].num_rows);
	for(int i=0; i<NUM_REP; i++)
	{
		for( k=0; k<num_matrices; k++)
		{

			spmv_csr_cpu(&csr[k],x_host,y_host,host_out);
			CCS_DESIGN(spmv)(csr[k].Ap,csr[k].Aj,csr[k].Ax,x_host,y_host);
        FLOAT_VECT tm=-1;
		FLOAT_VECT tm2=y_host[k]-host_out[k];
		tm2=tm2>FLOAT_VECT(0)?tm2:FLOAT_VECT(tm2*tm);
			if(tm2>FLOAT_VECT(0.001))
			{	//std::cout<<y_host[k]-host_out[k]<<std::endl;
				ct++;
			}
		}

	}

	free(device_out);
	free(host_out);
	}

	free_csr(csr,num_matrices);
	free(x_host);
	free(y_host);

	if (ct)
		{
			printf("Something wrong with the device result\n");
		}
		else
		{
			printf("Pass: Device result matches CPU result\n");
			//printf("Run-time is:%f ms \n",run_time_total/NUM_REP);
			//print_rsl;
		}
return 0;
}
