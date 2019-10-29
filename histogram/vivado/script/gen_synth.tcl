open_project histogram_batch
set_top histogram_main
add_files histogram_hls.cpp
add_files histogram_hls.h
add_files histogram_main.cpp
add_files params.h
add_files -tb ../../src/input.dat
add_files -tb main_test.cpp

#Solution
open_solution -reset "solutionx"
set_part {xc7z020clg400-1} -tool vivado
create_clock -period 10

#source "./histogram/solution1/directives.tcl"
csim_design
csynth_design
#export_design


exit
