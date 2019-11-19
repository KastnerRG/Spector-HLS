
# Normal estimation

## Description
This is loosely based on https://github.com/KastnerRG/spector/tree/master/normals which is in turn ,
 inspired by some pre-processing algorithms in Kinfu, the open-source implementation of KinectFusion from the PCL library (http://pointclouds.org/).

It estimates the 3D normals for an organized point cloud. A device such as Microsoft Kinect or Intel RealSense provides a 2D map of distances (depth map) that we can convert into a point cloud. This point cloud is organized since we can estimate neighbors of a 3D point by using neighbors on the 2D map. By using this neighbor information, we can quickly estimate the 3D normals for all the points on the depth map.

### File format

The input is a simple binary file containing a vertex map of size 640x480 stored using 32-bits floats in row-major format. A vertex map is a depth map for which each value has been converted to a 3D coordinate in real distances. The coordinates are interleaved, ie. (x1,y1,z1) (x2,y2,z2) ...

The file containing the normals for verification follows exactly the same format.

### Data structure

The vertex map is stored in a flat array of floats in row-major format with interleaved coordinates. 
The normal map follows the same format.

## Usage

* `src` contains the base files to generate the designs
* `scripts` contains scripts to generate the designs, compile, run and parse them.
* `result` constains the csv file and the jupyter notebooks which have the pareto points obtained by Sherlock.

## Algorithm

For each point on the vertex map, we take this point, the point to the right and the point below (with respect to the 2D map). Then we calculate the cross-product of the difference between each neighbor and the current point. The result is normalized and stored in the normal map. If any of the vertices is null (NaN), the normal is null. The last column and the last row of the normal map are set to null.

```
for each vertex point on the map
	if vertex is on last row or last column
		set normal to null
	else
		get the neighbor on the right and below
		if any of the vertices are null
			set the normal to null
		else
			calculate the difference between each neighbor and the current point
			calculate the cross-product between these differences
			normalize the result
			store the normal into the normal map
```

## Knobs

- `KNOB_WINDOW_SIZE_X`: Size of the sliding window. ie. Number of consecutive elements to potentially process simultaneously.
- `outer_unroll`      : Unroll factor for the outer loop that iterates over all the input data.
- `inner_unroll1`     : Unroll factor for inner loop that performs the normal computation.
- `inner_unroll2`     : Unroll factor for inner loop that performs shifting operation using sliding window.
- `partition_factor` : To split the array into several blocks to complement unrolling.
