# vivado.tcl - Vivado batch flow for cojt_dounyu project

# Project settings
set project_dir "./project"
set project_name "cojt_dounyu"
set top_module "BASYS3_CLOCK24"
set part "xc7a35tcpg236-1"

create_project $project_name $project_dir -part $part -force

# Read RTL sources
read_verilog -sv [ glob target/*.sv ]
read_verilog -sv [ glob src/sv/*.sv ]

# Import and generate clock IP
import_ip src/ip/clk_core.xci
update_ip_catalog

# Add constraints file for Basys3
add_files -fileset constrs_1 [ glob src/constr/*.xdc ]

# Set the top-level module
set_property top $top_module [current_fileset]
update_compile_order -fileset sources_1

reset_project

# Run synthesis
launch_runs synth_1 -jobs 6
wait_on_run synth_1

# Run implementation up to bitstream generation
launch_runs impl_1 -jobs 6
wait_on_run impl_1
open_run impl_1

report_utilization -file [file join $project_dir "project.rpt"]
report_timing -file [file join $project_dir "project.rpt"] -append

launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1

# Exit Vivado
close_project
exit
