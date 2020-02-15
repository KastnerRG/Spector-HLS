# written for flow package Vivado 
set sdc_version 1.7 

create_clock -name clk -period 10.0 -waveform { 0.0 5.0 } [get_ports {clk}]
set_clock_uncertainty 0.0 [get_clocks {clk}]

create_clock -name virtual_io_clk -period 10.0
## IO TIMING CONSTRAINTS
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {rst}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {dst_rsc_dat[*]}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {dst_rsc_vld}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {dst_rsc_rdy}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {src_rsc_dat[*]}]
set_input_delay -clock [get_clocks {clk}] 0.0 [get_ports {src_rsc_vld}]
set_output_delay -clock [get_clocks {clk}] 0.0 [get_ports {src_rsc_rdy}]

