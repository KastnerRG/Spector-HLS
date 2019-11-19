# Merge sort

## Description

This program sorts an array of values by using the merge sort algorithm. We chose the values to be integers in our implementation, but this can be easily changed.

### Structure

The program contains an input and output array of integers.

## Usage

* `src` contains the base files to generate the designs
* `scripts` contains scripts to generate the designs, compile, run and parse them.
* `result` constains the csv file and the jupyter notebooks which have the pareto points obtained by Sherlock.

## Algorithm

The algorithm is implemented using loops instead of recursion. It loops over the input multiple times to merge all the blocks of size 2 first, then double the size of the blocks until merging the last two blocks. 
The basic implementation of the merge algorithm pulls values from memory, compares them and store the smallest back to memory. This is done by alternating the input and output buffers.

```
for block_size from 2 to input_size
	for each block of the input
  	separate block into 2 halfs
	  take 2 values
	  compare
	  store smallest value
	swap input/output buffers

```
## Knobs

- `outer_unroll`     : Unroll factor for outer loop for every value in input array.
- `inner_unroll1`    : Unroll factor to process every block.
- `merge_unroll`     : Unroll factor to merge two subdivision of one block.
- `inner_unroll2`    : Unroll factor for swapping input and outer arrays.
- `partition_factor` : To split the array into several blocks to complement unrolling.
