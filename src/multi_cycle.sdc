//Copyright (C)2014-2026 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.03 Education 
//Created Time: 2026-05-28 18:26:11

// fast clk to be divided down to ~300 MHz 
create_clock -name hclkin -period 0.417 -waveform {0 0.208} [get_ports {hclkin}]

// divided output
create_generated_clock -name clk  -source [get_ports {hclkin}] -divide_by 8 [get_pins {clkdiv_inst/CLKOUT}]


// target only the math path (from the adder back to the flip-flop)
// give it 2 cycles (6.66 ns) to complete the 22-bit addition. Could be up to ~16 cycles but unneccessary
set_multicycle_path -setup -from [get_cells {*ms_bits*}] -to [get_cells {*ms_bits*}] 2
// fix the hold edge
set_multicycle_path -hold  -from [get_cells {*ms_bits*}] -to [get_cells {*ms_bits*}] 1
