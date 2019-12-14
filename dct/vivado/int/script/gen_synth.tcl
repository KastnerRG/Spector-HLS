open_project dct
set_top DCT
add_files dct.cpp
add_files dct.h
add_files params.h
add_files -tb ../../src/input.txt
add_files -tb ../../src/ref_output.txt
add_files -tb dct_test.cpp

#Solution
open_solution -reset "solutionx"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10

#source "./histogram/solution1/directives.tcl"
csim_design
csynth_design
#export_design


exit
