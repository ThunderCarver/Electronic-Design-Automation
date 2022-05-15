create_mw_lib  -technology /home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/digital/sc/apollo/tf/smic18_6lm.tf	\
		-mw_reference_library {/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/digital/sc/apollo/smic18/ }	\
		-hier_separator {/}				\
		-bus_naming_style {[%d]}			\
		-open  ./COUNT

set_check_library_options -all

check_library

set tlupmax	"/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/itf_tluplus/smiclog018_6lm_cell_max.tluplus"
set tlupmin	"/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/itf_tluplus/smiclog018_6lm_cell_min.tluplus"
set tech2itf	"/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/tech2itf.map"

set_tlu_plus_files -max_tluplus $tlupmax \
                        -min_tluplus $tlupmin \
			-tech2itf_map $tech2itf


import_designs -format verilog		\
		 -top crossbar		\
		 -cel crossbar {/home/lishang/ckfang/Projects/datapath/dc/results/crossbar_synthesized.v}


		
source  /home/lishang/ckfang/Projects/datapath/dc/results/crossbar_synthesized.sdc 

