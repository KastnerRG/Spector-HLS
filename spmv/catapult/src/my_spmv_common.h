
//#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include<ac_fixed.h>
typedef ac_fixed<20,8,true> FLOAT_VECT;
typedef struct csr_matrix
{//if ith row is empty Ap[i] = Ap[i+1]
    unsigned int index_type;
    FLOAT_VECT value_type;
    unsigned int num_rows, num_cols, num_nonzeros,density_ppm;
    double density_perc,nz_per_row,stddev;

    int * Ap;  //row pointer
    int * Aj;  //column indices
    FLOAT_VECT * Ax;  //nonzeros
}
csr_matrix;






int float_array_comp(const FLOAT_VECT* control, const FLOAT_VECT* experimental, const unsigned int N, const unsigned int exec_num);
void spmv_csr_cpu(const csr_matrix* csr,const FLOAT_VECT* x,const FLOAT_VECT* y,FLOAT_VECT* out);
csr_matrix* read_csr(unsigned int* num_csr,const char* file_path);
void free_csr(csr_matrix* csr,const unsigned int num_csr);
