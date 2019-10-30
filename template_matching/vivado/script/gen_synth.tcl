open_project template_match
set_top SAD_MATCH
add_files fpga_temp_match.cpp
add_files fpga_temp_matching.h
add_files params.h
add_files -tb ../../src/img_100_100.txt
add_files -tb ../../src/img_200_200.txt
add_files -tb ../../src/img_400_400.txt

add_files -tb ../../src/out_ref_100_100_20.txt
add_files -tb ../../src/out_ref_100_100_10.txt
add_files -tb ../../src/out_ref_100_100_5.txt

add_files -tb ../../src/out_ref_200_200_20.txt
add_files -tb ../../src/out_ref_200_200_10.txt
add_files -tb ../../src/out_ref_200_200_5.txt

add_files -tb ../../src/out_ref_400_400_20.txt
add_files -tb ../../src/out_ref_400_400_10.txt
add_files -tb ../../src/out_ref_400_400_5.txt
add_files -tb testbench.cpp

#Solution
open_solution -reset "solutionx"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10

#source "./histogram/solution1/directives.tcl"
csim_design
csynth_design
#export_design


exit
