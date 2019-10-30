open_project sobel_filter_subdimy
set_top sobel_y
add_files sobel_subdimy.cpp
add_files sobel.h
add_files params.h
add_files -tb ../../src/image_in.txt
add_files -tb ../../src/image_out_ref.txt
add_files -tb sobel_test_subdimy.cpp

#Solution
open_solution -reset "solutionx"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10

#source "./histogram/solution1/directives.tcl"
csim_design
csynth_design
#export_design


exit
