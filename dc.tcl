echo "RUN STARTED AT [date]"

set TOP_DESIGN          $::env(DESIGN_NAME)
set FILE_LIST           $::env(FILE_LIST)
set SDC_FILE            $::env(SDC_FILE)
set SETUP_TCL           $::env(SETUP_TCL)

set RESULTS_DIR         $::env(RESULTS_DIR)
set TARGET_LIBS         $::env(TARGET_LIBS)
set LOG_DIR             $RESULTS_DIR/log
set REPORT_DIR          $RESULTS_DIR/rpt
set OUTPUT_DIR          $RESULTS_DIR/output
set ANALYZED_DIR        $RESULTS_DIR/analyzed
set ALIB_DIR            $RESULTS_DIR/alib
set SVF_PATH            $RESULTS_DIR/default.svf

# Make directory
file mkdir $RESULTS_DIR $LOG_DIR $REPORT_DIR $OUTPUT_DIR $ANALYZED_DIR $ALIB_DIR

# Tool settings
set_app_var sh_new_variable_message                false
set_app_var report_default_significant_digits      3
set_app_var hdlin_infer_multbit                    default_all
set_app_var compile_clock_gating_through_hierarchy true
set_app_var hdlin_enable_upf_compatible_naming     true
set_app_var hdlin_enable_hier_map                  true

set_host_options -max_cores 8

### Logical Library
echo "###### Specify libraries ######"
echo "To set include dirs: use `set_app_var search_path` in filelist" 
# set_app_var search_path 	"$INCLUDE_DIRS" ;#Set libraries searching path                                            
#Set libraries searching path                                            
set_app_var target_library     [split [regexp -all -inline {\S+} $TARGET_LIBS]];#Target techonology logical libraries
set_app_var link_library       [list * $target_library ]
set_app_var alib_library_analysis_path $ALIB_DIR
#set_app_var synthetic_library  "dw_foundation.sldb"
#check_library > ./rpt/$TOP_DESIGN.check_library.rpt

# Setup verification for Formality
set_svf $SVF_PATH

### Read in the design
echo	"###### Read design ######" 
define_design_lib work -path $ANALYZED_DIR

#analyze -format verilog using the below source
source $SETUP_TCL
source $FILE_LIST
elaborate -library work $TOP_DESIGN > $LOG_DIR/elaborate.log
current_design  $TOP_DESIGN

##### TODO: dont touch
##### TODO: disable const prop
##### TODO: load upf

link
set_verification_top
uniquify
write_file -hierarchy -format verilog -output $OUTPUT_DIR/$TOP_DESIGN.synth.elaborate.v

### Constraints: TODO put into a single SDC file
echo	"###### Set design constraints ######"

################### Define Constraints Parameters #####################

source $SDC_FILE
################################# Defining The Operation Conditions ####################################

#set_min_library HDSCL1NMV1_SS.db -min_version  HDSCL1NMV1_FF.db
#set_operating_conditions -max_lib HDSCL1NMV1_SS -max SS_5V -min_lib HDSCL1NMV1_FF -min FF_5V 
set_wire_load_mode enclosed

#####################################################################
############### Set design rule constraints #########################
#####################################################################

set ALL_EX_OUT    [remove_from_collection [current_design] [all_outputs]]
set ALL_EX_OUT_IN [remove_from_collection $ALL_EX_OUT [all_inputs]]

set_max_area 0
#set_max_transition      $MAX_TRAN    $ALL_EX_OUT_IN
#set_max_fanout          $MAX_FANOUT  $ALL_EX_OUT_IN
#set_max_capacitance     $MAX_CAP     $ALL_EX_OUT_IN

write_sdc $OUTPUT_DIR/$TOP_DESIGN.synth.elaborate.sdc
report_clock_tree -structure > $REPORT_DIR/clock_tree_structure.rpt

### Compile
echo	"###### Synthesize and optimize ######"
check_design > $REPORT_DIR/check_design.precompile.rpt

#set verilogout_no_tri  true # ???
#
#foreach_in_collection design [ get_designs "*" ] {
#      current_design $design
#      set_fix_multiple_port_nets -all -buffer_constants
#      set verilogout_no_tri  true
#   }
#current_design $TOP_DESIGN

set_dynamic_optimization true
compile_ultra -area_high_effort_script -no_autoungroup -gate_clock -no_seq_output_inversion -no_boundary_optimization > $LOG_DIR/${TOP_DESIGN}_ultra.compile 
analyze_datapath > $REPORT_DIR/datapath.compile.rpt
report_resources > $REPORT_DIR/resources.compile.rpt
write_file -hierarchy -format verilog -output $OUTPUT_DIR/$TOP_DESIGN.synth.compile.v
write_sdc $OUTPUT_DIR/$TOP_DESIGN.synth.compile.sdc

update_timing
report_timing -nosplit > $REPORT_DIR/timing.compile.rpt
report_area -nosplit -hier > $REPORT_DIR/area.hier.compile.rpt

### Optimize
check_design > $REPORT_DIR/check_design.preopt.rpt
#optimize_netlist -area -no_boundary_optimization
optimize_netlist -area
check_design > $REPORT_DIR/check_design.postopt.rpt

change_name -rules verilog -hier
set hdlout_internal_busses TRUE
set bus_inference_style {%s[%d]}

write -format verilog -hierarchy -output $OUTPUT_DIR/$TOP_DESIGN.synth.final.v
write -format ddc -hierarchy -output $OUTPUT_DIR/$TOP_DESIGN.synth.final.ddc
write_sdc -nosplit $OUTPUT_DIR/$TOP_DESIGN.synth.final.sdc

### Report
echo	"###### Analyze and resolve ######"
report_clock_gating         > $REPORT_DIR/clock_gating.rpt
report_timing -max_paths 500 -significant_digits 3 -nosplit > $REPORT_DIR/synth.timing.rpt
report_timing -delay max -max_paths 500 -input_pins -nets -transition_time -capacitance -significant_digits 3 > $REPORT_DIR/synth.max_delay.rpt
report_timing -delay min -max_paths 500 -input_pins -nets -transition_time -capacitance -significant_digits 3 > $REPORT_DIR/synth.min_delay.rpt
report_constraint -all_violators -significant_digits 3 > $REPORT_DIR/synth.all_viol_constraints.rpt
report_area -nosplit -hier > $REPORT_DIR/synth.area.hier.rpt
report_resources -nosplit -hier > $REPORT_DIR/synth.resources.rpt

report_compile_options -nosplit > $REPORT_DIR/synth.compile_options.rpt

echo "RUN ENDED AT [date]"
exit
