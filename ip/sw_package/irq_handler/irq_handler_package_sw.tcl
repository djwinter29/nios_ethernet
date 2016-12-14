#
# mini_tcpip_stack_sw_package_sw.tcl
#

# Create a software package known as "tcpip_stack"
create_sw_package irq_handler

# The version of this driver
set_sw_property version 16.1

#
# Source file listings...
#

# C/C++ source files
set_sw_property bsp_subdirectory HAL

add_sw_property asm_source src/alt_exception_entry.S
add_sw_property asm_source src/alt_irq_entry.S


add_sw_property c_source src/alt_iic_isr_register.c
#add_sw_property c_source src/ipv4_mini.c


# Include files

#add_sw_property include_source EXAMPLE_SW_PACKAGE/inc/example_sw_package.h

# Lib files
#add_sw_property lib_source EXAMPLE_SW_PACKAGE/lib/libexample_sw_package_library.a

# Include paths for headers which define the APIs for this package
# to share w/ app & bsp
# Include paths are relative to the location of this software
# package tcl file
#add_sw_property include_directory EXAMPLE_SW_PACKAGE/inc

# This driver supports HAL & UCOSII BSP (OS) types
add_sw_property supported_bsp_type HAL
#add_sw_property supported_bsp_type UCOSII

# Add example software package system.h setting to the BSP:
#add_sw_setting quoted_string system_h_define \
#  example_sw_package_system_value EXAMPLE_SW_PACKAGE_SYSTEM_VALUE 1 \
#  "Example software package system value"





# End of file
