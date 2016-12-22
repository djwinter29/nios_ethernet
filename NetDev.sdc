#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name {Ref_Clk}  -period 8.000 -waveform { 0.000 4.000 } [get_ports {Ref_clk}] 

# Marvell Ethernet RX clock from PHY
create_clock -name rgmii_rx_clk -period 8.000  -waveform { 0.000 4.000 } [get_ports Enet_rx_clk]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks 

set tx_clk_125 {thePLL|*pll1|clk[1]}

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


# JTAG
set_input_delay -clock altera_reserved_tck -clock_fall 2 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 2 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck -clock_fall 2 [get_ports altera_reserved_tdo]


#**************************************************************
# Output Delay Constraints (Edge Aligned, Same Edge Capture)
#**************************************************************  
# max delay = tsu (-0.9) + skew (0.075) 
# min delay = -th ( 2.7) - skew (0.075) 
set_output_delay -add_delay -clock [get_clocks $tx_clk_125] -max -0.825 [get_ports {Enet_tx_en Enet_tx_d*}]
set_output_delay -add_delay -clock [get_clocks $tx_clk_125] -min -2.775 [get_ports {Enet_tx_en Enet_tx_d*}]
set_output_delay -add_delay -clock [get_clocks $tx_clk_125] -max -clock_fall -0.825 [get_ports {Enet_tx_en Enet_tx_d*}]
set_output_delay -add_delay -clock [get_clocks $tx_clk_125] -min -clock_fall -2.775 [get_ports {Enet_tx_en Enet_tx_d*}]

#enet_gtx_clk_125
# On same edge capture DDR interface the paths from RISE to RISE and FALL to FALL are not valid for hold analysis
set_false_path -setup -rise_from [get_clocks $tx_clk_125] -fall_to [get_clocks $tx_clk_125]
set_false_path -setup -fall_from [get_clocks $tx_clk_125] -rise_to [get_clocks $tx_clk_125]

#**************************************************************
# Input Delay Constraints (Center aligned, Same Edge Analysis)
#**************************************************************
# max delay = tco (-1.2) + skew (0.075)
# min delay = tcomin (-2.8) - skew (0.075)

# Constraint the path to the rising edge of the phy clock
set_input_delay -add_delay -clock rgmii_rx_clk -max -1.125 [get_ports {Enet_rx_en Enet_rx_d*}]
set_input_delay -add_delay -clock rgmii_rx_clk -min -2.875 [get_ports {Enet_rx_en Enet_rx_d*}]

# Constraint the path to the falling edge of the phy clock
set_input_delay -add_delay -clock rgmii_rx_clk -max -clock_fall -1.125 [get_ports {Enet_rx_en Enet_rx_d*}]
set_input_delay -add_delay -clock rgmii_rx_clk -min -clock_fall -2.875 [get_ports {Enet_rx_en Enet_rx_d*}]


# On a same edge capture DDR interface the paths from RISE to FALL and
# from FALL to RISE on not valid for setup analysis
set_false_path -setup -rise_from [get_clocks rgmii_rx_clk] -fall_to [get_clocks rgmii_rx_clk]
set_false_path -setup -fall_from [get_clocks rgmii_rx_clk] -rise_to [get_clocks rgmii_rx_clk]

# On a same edge capture DDR interface the paths from RISE to RISE and
# FALL to FALL are not avlid for hold analysis
set_false_path -hold -rise_from [get_clocks rgmii_rx_clk] -rise_to [get_clocks rgmii_rx_clk]
set_false_path -hold -fall_from [get_clocks rgmii_rx_clk] -fall_to [get_clocks rgmii_rx_clk]

# TSE MAC MDIO and reset
set_min_delay  2 -from * -to [get_ports {Enet_mdc Enet_mdio}]
set_max_delay 10 -from * -to [get_ports {Enet_mdc Enet_mdio}]

set_min_delay  0 -from [get_ports {Enet_mdio}] -to *
set_max_delay  6 -from [get_ports {Enet_mdio}] -to *

# Marvell Reset
set_min_delay  2 -from * -to [get_ports {Enet_reset_n}]
set_max_delay 10 -from * -to [get_ports {Enet_reset_n}]
