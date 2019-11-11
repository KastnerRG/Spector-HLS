# written for flow package Vivado 
set sdc_version 1.7 

create_clock -name virtual_io_clk -period 10.0
## IO TIMING CONSTRAINTS
set_input_delay 0.0 -clock virtual_io_clk [get_ports {clk}]
set_input_delay 0.0 -clock virtual_io_clk [get_ports {rst}]

