# DISCRETE COSINE TRANSFORM

## Description

This algorithm is loosely based on NVIDIA CUDA implementation of DCT explained here: http://developer.download.nvidia.com/assets/cuda/files/dct8x8.pdf. 
It is adapted from spector benchmarks which can be seen here :https://github.com/KastnerRG/spector/tree/master/dct. This is a 2-dimensional DCT that works on 8x8 blocks. It takes a 2-dimensional signal as input and returns the signal transformed into the frequency domain using 8x8 blocks.

### Data Structure

The input signal is given as an array of 32-bits floating-point values organized in a row-major format. The stride between rows is given as input and can be different from the image width. The output signal has the same format.

## Usage

* `src` contains the base files to generate the designs
* `scripts` contains scripts to generate the designs, compile, run and parse them.
* `result` constains the csv file and the jupyter notebooks which have the pareto points obtained by Sherlock.

## Algorithm

The algorithm loops over the entire width and height and divides the input signal into 8x8 blocks. 
Each 8x8 block is then processed by calculating DCT for rows, then for columns. The DCT coefficients are precalculated. There are also knobs that enable multiple blocks to processed parallely, and multiple rows and columns to be processed simultaneously.

```
for every 8 pixels over image height
	for every 8 pixels over image width
		for each row-wise 8 block 
			for each row in the block until block dimension 
				calculate DCT
	  	for each column-wise 8 block 
	    		for each column in the block until block dimension 
		    		calculate DCT
```
### Knobs

- `blockdim_x`       : Number of pixels to process in parallel within a block of 8 pixels in a row
- `blockdim_y`       : Number of pixels to process in parallel within a block of 8 pixels in a column
- `unroll_dct`       : Unroll factor for DCT8 computation
- `unroll_width`     : Unroll factor for conputing DCT8*8 over entire image width
- `unroll_height`    : Unroll factor for conputing DCT8*8 over entire image height
- `partition_factor` : Partition factor to divide all buffers to complement unroll factors to perform parallel operations
