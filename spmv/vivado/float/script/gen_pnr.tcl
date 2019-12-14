open_project spmv
set_top spmv
add_files spmv.cpp
add_files params.h
add_files -tb spmv_test.cpp
add_files -tb my_spmv_common.h
add_files -tb csrmatrix_R1_N512_D5000_S01
#Solution
open_solution -reset "solutionx"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10

#source "./histogram/solution1/directives.tcl"
csim_design
csynth_design
export_design -flow impl


exit
