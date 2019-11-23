open_project matrix_mul
set_top matrix_mul
add_files matrix_mul.cpp
add_files matrix_mul.h
add_files params.h
add_files -tb ../../src/A_input_1024.txt
add_files -tb ../../src/B_input_1024.txt
add_files -tb ../../src/C_ref_1024.txt

add_files -tb matrix_mul_test.cpp

#Solution
open_solution -reset "solutionx"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10

#source "./histogram/solution1/directives.tcl"
csim_design
csynth_design
#export_design


exit
