open_project mergesort
set_top mergesort
add_files mergesort.cpp
add_files params.h
add_files -tb mergesort_test.cpp
add_files -tb params.h

#Solution
open_solution -reset "solutionx"
set_part {xcvu9p-flga2104-1-e} -tool vivado
create_clock -period 10

#source "./histogram/solution1/directives.tcl"
csim_design
csynth_design
export_design -flow impl


exit
