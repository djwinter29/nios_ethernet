#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name {Ref_Clk}  -period 8.000 -waveform { 0.000 4.000 } [get_ports {Ref_clk}] 

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks 

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


# JTAG
set_input_delay -clock altera_reserved_tck -clock_fall 2 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 2 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck -clock_fall 2 [get_ports altera_reserved_tdo]