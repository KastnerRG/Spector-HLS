set proj_name "matmul_ip"
set folder_name "./matmul_ip"
create_project $proj_name $folder_name -part xcvu9p-flga2104-1-e
#set_property  ip_repo_paths  /home/siva/logic_new/ip [current_project]
#update_ip_catalog
add_files -norecurse {./concat_rtl.v ./rtl.v}
import_files -force -norecurse
import_files -fileset constrs_1 -force -norecurse ./constr.xdc
update_compile_order -fileset sources_1
ipx::package_project -root_dir $folder_name/matmul_ip.srcs -vendor user.org -library user -taxonomy /UserIP
set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  {./matmul_ip/matmul_ip.srcs} [current_project]
update_ip_catalog
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv user.org:user:matrix_mul:1.0 matrix_mul_0
endgroup
startgroup
make_bd_pins_external  [get_bd_cells matrix_mul_0]
make_bd_intf_pins_external  [get_bd_cells matrix_mul_0]
endgroup
assign_bd_address
foreach bd_port [get_bd_intf_ports] {
  set_property name [regsub {_0$} [get_property name $bd_port] {}] $bd_port
}
foreach bd_port [get_bd_ports -filter {INTF!=TRUE}] {
  set_property name [regsub {_0$} [get_property name $bd_port] {}] $bd_port
}
make_wrapper -files [get_files $folder_name/matmul_ip.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $folder_name/matmul_ip.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
set_property top design_1_wrapper [current_fileset]
update_compile_order -fileset sources_1
generate_target all [get_files  $folder_name/matmul_ip.srcs/sources_1/bd/design_1/design_1.bd]
catch { config_ip_cache -export [get_ips -all design_1_matrix_mul_0_0] }
export_ip_user_files -of_objects [get_files $folder_name.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] $folder_name/matmul_ip.srcs/sources_1/bd/design_1/design_1.bd]
launch_runs -jobs 4 design_1_matrix_mul_0_0_synth_1
#export_simulation -of_objects [get_files /home/siva/Siva/RA/histogram_ip/histogram_ip.srcs/sources_1/bd/design_1/design_1.bd] -directory /home/siva/Siva/RA/histogram_ip/histogram_ip.ip_user_files/sim_scripts -ip_user_files_dir /home/siva/Siva/RA/histogram_ip/histogram_ip.ip_user_files -ipstatic_source_dir /home/siva/Siva/RA/histogram_ip/histogram_ip.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/siva/Siva/RA/histogram_ip/histogram_ip.cache/compile_simlib/modelsim} {questa=/home/siva/Siva/RA/histogram_ip/histogram_ip.cache/compile_simlib/questa} {ies=/home/siva/Siva/RA/histogram_ip/histogram_ip.cache/compile_simlib/ies} {xcelium=/home/siva/Siva/RA/histogram_ip/histogram_ip.cache/compile_simlib/xcelium} {vcs=/home/siva/Siva/RA/histogram_ip/histogram_ip.cache/compile_simlib/vcs} {riviera=/home/siva/Siva/RA/histogram_ip/histogram_ip.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
source -notrace ./extraction.tcl
launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1
run_report report_utilization -file $folder_name/matmul_utilization_synth.rpt
run_report report_timing_summary -file $folder_name/matmul_timing_synth.rpt
launch_runs impl_1 -jobs 4
wait_on_run impl_1
open_run impl_1
run_report report_route_status -file $folder_name/matmul_status_routed.rpt
run_report report_utilization -file $folder_name/matmul_utilization_routed.rpt
run_report report_timing -max_paths 10 -file $folder_name/matmul_timing_paths_routed.rpt
run_report report_timing_summary -file $folder_name/matmul_timing_routed.rpt
check_impl_run impl_1 false
if { [catch { compile_reports_vivado 1 10 $folder_name matmul ./report/verilog xcvu9p-flga2104-1-e $proj_name solution1 } err] } {
    puts "ERROR \[IMPL-251\] Errors occured while compiling report: $err"
    exit 1
}
