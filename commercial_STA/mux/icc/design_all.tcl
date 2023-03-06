

derive_pg_connection -power_net VDD		\
			 -ground_net VSS	\
			 -power_pin VDD		\
			 -ground_pin VSS	\
			 -create_ports top
save_mw_cel

#derive_pg_connection \

   #-power_net "VDD" -power_pin "VDD" -ground_net "VSS" -ground_pin "VSS" \

   #-create_ports "top"

# Make an initial floorplan and synthesize power rails. At this point, you

# can see the estimated voltage drops on the power rails.

# The numbers in the right column of the GUI are specied in mW.


create_floorplan -use_vertical_row -start_first_row -left_io2core 20 -bottom_io2core 20 -right_io2core 20 -top_io2core 20

create_fp_placement

synthesize_fp_rail \
  -power_budget "1000" -voltage_supply "1.2" -target_voltage_drop "250" \
  -output_dir "./pna_output" -nets "VDD VSS" -create_virtual_rails "metal1" \
  -synthesize_power_plan -synthesize_power_pads -use_strap_ends_as_pads

commit_fp_rail

# Perform clock tree synthesis. To look at the generated clock tree choose

# Clock > Color By Clock Trees. Hit Reload, and then hit OK on the popup window.

# Now you will be able to see the synthesized clock tree.

commit_fp_rail

#route_opt -initial_route_only

#route_opt -skip_initial_route -effort low

route_auto

insert_stdcell_filler \
 -cell_with_metal "SHFILL1 SHFILL2 SHFILL3" \
 -connect_to_power "VDD" -connect_to_ground "VSS"

extract_rc

 # write_verilog  ../results/crossbar.v

 write_parasitics -output {../results/crossbar.spef}

write_verilog -pg -no_physical_only_cells ../results/crossbar.v

write_verilog -no_physical_only_cells ../results/crossbar_fm.v

write_sdf ../results/crossbar.sdf

write_sdc ../results/crossbar.sdc

save_mw_cel