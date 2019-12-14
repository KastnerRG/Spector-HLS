
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct csr_matrix
{//if ith row is empty Ap[i] = Ap[i+1]
    unsigned int index_type;
    float value_type;
    unsigned int num_rows, num_cols, num_nonzeros,density_ppm;
    double density_perc,nz_per_row,stddev;

    int * Ap;  //row pointer
    int * Aj;  //column indices
    float * Ax;  //nonzeros
}
csr_matrix;






int float_array_comp(const float* control, const float* experimental, const unsigned int N, const unsigned int exec_num);
void spmv_csr_cpu(const csr_matrix* csr,const float* x,const float* y,float* out);
csr_matrix* read_csr(unsigned int* num_csr,const char* file_path);
void free_csr(csr_matrix* csr,const unsigned int num_csr);
