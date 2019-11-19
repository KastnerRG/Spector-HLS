# Sparse matrix-vector multiplication (spmv)

## Description

This code performs a simple matrix-vector multiplication and addition y = Ax + y where the matrix A is sparse and the vectors x and y are dense. It is based on the Sparse Matrix-Vector Multiplication FPGA benchmark from the OpenDwarfs project (https://github.com/vtsynergy/OpenDwarfs).

### Data structure

The matrix is stored in the CSR format, with one array for the non-zero elements (floating-point) _Ax_, one array for the cumulated number of elements per row _Ap_, and one array for the column indices for each element _Aj_.

The vectors _x_ and _y_ are simple contiguous arrays of floating-point values.

## Usage

* `src` contains the base files to generate the designs
* `scripts` contains scripts to generate the designs, compile, run and parse them.
* `result` constains the csv file and the jupyter notebooks which have the pareto points obtained by Sherlock.

## Algorithm

The algorithm loops over each row, gets the indices of the elements of this row, the gets the column of each element and multiplies it by the corresponding vector's row. There are some parameters to enable the processing of multiple elements simultaneously.

```
for each row
	initialize sum with y[row]
	get the indices of elements in the row from Ap
	for each element
		get the column index j of this element from Aj
		get x[j] and multiply by this element
		add result to sum
	store the sum back into y
```

## Knobs 

- `outer_unroll`     : Unroll factor for outer loop which loops over all rows.
- `inner_unroll1`    : Unroll factor for inner loop which loops over present array value to next array value.
- `inner_unroll2`    : Unroll factor for inner loop which performs vector multiplication.
- `UNROLL_F`         : Knob to multiply different values at a time.
- `array_partition1` : Knob to partition input and output arrays.
- `array_partition2` : Knob to partition temporary buffers to perform multiplication.
