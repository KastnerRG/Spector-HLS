# Template Matching

## Description

Performs template matching of an input image of varying sizes, using sum of absolute differences function, for templates of varying sizes.
Output image is a set of 0's and 1's. 1 if the pixel is part of the template and 0 if not.

## Structure

The input and output are streamed using axistream and hence custom data structure is used which has a data field and last bit.

## Usage

* `src` contains the base files to generate the designs
* `scripts` contains scripts to generate the designs, compile, run and parse them.
* `result` constains the csv file and the jupyter notebooks which have the pareto points obtained by Sherlock.

## Algorithm

The algorithm compares the pixel of input image with the template. Sum of absolute difference of the entire template size of input image
is taken and compared. To improve throughput, the pixels are stored in sliding windows to reuse.

```
for every pixel in input image
  store value in row buffer
  shift window buffer left
  pull column from row buffer into window buffer
  Perform SAD for entire window buffer
  if row buffer is filled , shift it up by 1
  Store the output in output pointer
```

## Knobs
- `UNROLL_FACTOR` : Unroll factor for outer loop to pull pixel from stream.
- `UNROLL_LOOP1`  : Unroll factor for shifting the window buffer left.
- `UNROLL_LOOP2`  : Unroll factor for loop to store column from row buffer into window buffer.
- `UNROLL_LOOP3`  : Unroll factor to perform SAD algorithm.
- `UNROLL_LOOP4`  : Unroll factor for loop to shift row buffer if it is full.
- `tmpdim`        : Array partition factor to partition the window buffer.
- `tmpsize`       : Array partition factor to partition the template buffer.
