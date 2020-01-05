# Environment variable settings
global env
set CATAPULT_HOME "/usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home"
## Set the variable for file path prefixing 
set RTL_TOOL_SCRIPT_DIR /home/mdk/Spector-HLS/template_matching/catapult/Catapult/SAD_MATCH.v3/vivado_concat_vhdl
set RTL_TOOL_SCRIPT_DIR [file dirname [file normalize [info script] ] ]
puts "-- RTL_TOOL_SCRIPT_DIR is set to '$RTL_TOOL_SCRIPT_DIR' "
# Vivado Non-Project mode script starts here
puts "==========================================="
puts "Catapult driving Vivado in Non-Project mode"
puts "==========================================="
set outputDir /home/mdk/Spector-HLS/template_matching/catapult/Catapult/SAD_MATCH.v3/vivado_concat_vhdl
set outputDir $RTL_TOOL_SCRIPT_DIR
create_project -force ip_tcl_concat_vhdl
   read_vhdl -library work ../concat_rtl.vhdl
# set up XPM libraries for XPM-related IP like the Catapult Xilinx_FIFO
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY XPM_FIFO} [current_project]
read_xdc $outputDir/concat_rtl.vhdl.xv.sdc
set_property part xcvu13p-flga2577-2-i [current_project]
