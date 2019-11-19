# Sobel filter

## Description

This code applies a Sobel filter on an input image, which size is defined at compile-time. It applies the 3x3 filter on X and Y, combines the results and applies a threshold to give back a b&w image of the contours.
It is based on the Altera OpenCL example of a Sobel filter (https://www.altera.com/support/support-resources/design-examples/design-software/opencl/sobel-filter.html).

### Data structure

The input image is an array of unsigned integers, each representing a pack of 8-bits (r,g,b,~) values. The output is an array of unsigned integers containing 0 or 1 to denote a contour.

## Usage

* `src` contains the base files to generate the designs
* `scripts` contains scripts to generate the designs, compile, run and parse them.
* `result` constains the csv file and the jupyter notebooks which have the pareto points obtained by Sherlock.

## Algorithm

Basically, for each pixel of the input image, the algorithm takes the 8 pixels around, converts them all to grayscale, applies a 3x3 kernel for X and another kernel for Y, 
combines the results and write this to the output.

```
for every pixel in the x direction
  for every first pixel of sliding window in y direction
    Obtain center pixel and neighboring 8 pixels
    for every value in sliding window
      Compute filtered value
      Shift pixel using sliding window
```

## Knobs

- `SUBDIM_X`              : Size of sliding window in x direction.
- `UNROLL_FACTOR`         : Unroll factor for outer loop to get pixel in x direction.
- `DIMX_PARTITION_FACTOR` : Partition factor of arrays along x direction.
- `DIMY_PARTITION_FACTOR` : Partition factor of arrays along y direction.
