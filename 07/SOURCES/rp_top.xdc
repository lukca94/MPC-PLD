
# ------------------------------------------------------------------------------ #
# LEDs
# ------------------------------------------------------------------------------ #
set_property IOSTANDARD LVCMOS33 [get_ports {LED[*]}]
set_property DRIVE 4 [get_ports {LED[*]}]
set_property PACKAGE_PIN F16 [get_ports {LED[0]}]
set_property PACKAGE_PIN F17 [get_ports {LED[1]}]
set_property PACKAGE_PIN G15 [get_ports {LED[2]}]
set_property PACKAGE_PIN H15 [get_ports {LED[3]}]
set_property PACKAGE_PIN K14 [get_ports {LED[4]}]
set_property PACKAGE_PIN G14 [get_ports {LED[5]}]
set_property PACKAGE_PIN J15 [get_ports {LED[6]}]
set_property PACKAGE_PIN J14 [get_ports {LED[7]}]




# ------------------------------------------------------------------------------ #
# 50 MHz clock (shield oscillator)
# ------------------------------------------------------------------------------ #
set_property PACKAGE_PIN H16 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports CLK]
set_input_jitter clk 0.100

# Overconstrained clock signal (for maximum frequency test)
# create_clock -period 2.000 -name clk -waveform {0.000 1.000} [get_ports CLK]

