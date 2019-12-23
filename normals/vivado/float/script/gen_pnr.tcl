open_project normals
set_top normals
add_files normals.cpp
add_files params.h
add_files -tb ../../src/nmap2.bin
add_files -tb ../../src/vmap2.bin
add_files -tb normals_test.cpp
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
