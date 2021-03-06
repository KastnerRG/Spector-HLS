# Spector-HLS

### Organization

There are eight benchmarks: **DCT**, **histogram**, **matrix multiplication**, **merge sort**, **normals**, **Sobel filter**, **sparse matrix vector multiply**, and **template matching**. Each benchmark is divided into its own directory. Each benchmark directory has implementations and results for Mentor Graphics Catapult HLS and Xilinx Vivado HLS. Additionally, there is a **results** subfolder holding Jupyter notebooks that perform different analysis on the various design spaces. 

Folder organisation is of the following format:

- #### Algorithm
	- ##### Tool folders (catapult/vivado)
		- src folder
		- script files for generating Design Space
	- ##### Result folder
		- postproc
			- ipython notebooks processing csv file data
		- csv
			- FPGA csv files having latency and resources outputs
		- asic
			- ASIC Design space having area and latency outputs

Note: the **miscellaneous** directory consists of the csv files and notebooks present in the results, the incomplete implementation of FIR filter, few of the vivado results for the Pynq board and some script files. 

### Design Spaces
The repository tries to get a wide variety of algorithms to generate various design spaces from the tools for analysis and prediction. The results display the design spaces of these algorithms when passing through various tools or various modes of the tools. 

The idea is to be able to provide a set of algorithms which a researcher can play with to improve upon the algorithms to generate better machine learning models to generate more accurate and efficient Design Space Exploration algorithms.

This repository is inspired by [Spector](https://github.com/KastnerRG/spector "Spector"), an OpenCL benchmark suite for FPGA.

### This project was supported by:
<img src="AWS-Cloud-Credits-for-Research-Program.png"  height="75">  
<img src="mentor_graphics_logo.png"  height="75"> 
