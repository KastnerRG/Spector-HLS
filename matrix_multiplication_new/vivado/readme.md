# Matrix Multiplication

## Description

This code implements a simple matrix multiply A * B = C with squared floating-point matrices. This is loosely bases on the spector benchmark here : https://github.com/KastnerRG/spector/tree/master/mm,
which is based on the Altera OpenCL example of Matrix Multiplication (https://www.altera.com/support/support-resources/design-examples/design-software/opencl/matrix-multiplication.html).

### Data structure

The matrices are simply stored in contiguous arrays of float values. dtype data structure is used for matrix A to enable streaming.

## Usage

* `src` contains the base source code for matrix multiplication.
* `scripts` contains the high-level scripts to generate designs, compile , run and parse them.
* `result` contains the csv file and the jupyter notebook with the pareto optimal points obtained by running Sherlock alogrithm.

## Algorithm

This is a typical blocking matrix multiplication algorithm. The resulting matrix C is divided into blocks. 
Matrix A is streamed in using axistream protocol.
Each block is computed by performing multiple small matrix multiplications between streamed matrix A and blocks of matrix B. 
The implementation includes several parameters to change the size of the blocks and to process multiple blocks at once.

```
for every subdimension of input values in a row over entire size of matrix
	for every input over entire subdimension of values in a row
    		Obtain input from Matrix A
    		for every subdimension of input values in a column over entire size of matrix
    			for every input over entire subdimension of values in a column
      				Perform matrix multiplication
```
## Knobs

- `PARTITION_FACTOR`: Knob to divide matrices B and C into blocks for parallelizing.
- `SUBDIM_X`        : Knob to process different number of blocks in a row.
- `SUBDIM_Y`        : Knob to process different number of blocks in a column.
- `UNROLL_FACTOR1`  : Knob to unroll upper loop to obtain different number of inputs from stream for Matrix A.
- `UNROLL_FACTOR2`  : Knob to unroll inner loop to compute different number of blocks in a row in parallel.
- `UNROLL_FACTOR3`  : Knob to unroll inner loop to compute different number of blocks in a column in parallel.
