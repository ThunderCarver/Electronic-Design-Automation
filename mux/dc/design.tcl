set mw_logic1_net "VDD"
set mw_logic0_net "VSS"

# read rtl file
read_verilog {../rtl/mux2.v ../rtl/mux4.v}

# set current_design (set top module)
set current_design mux4_to_1   

# check syntax
# analyze -library WORK -format verilog {../rtl/mux4.v  ../rtl/mux2.v}

# check circuit structure
# elaborate mux4_to_1 -architecture verilog -library DEFAULT

# link all hirarchy module
# link



check_design
check_timing
# �Ż�����
# compile_ultra   (��仰Ӱ���ۺϵĽ��)
compile
# ���ɱ����ļ�
report_area
report_constraint
report_timing


# generate synthesized .v file
write -hierarchy -format verilog -output ./reports/mux_synthesized.v
write_sdf -version 2.1 ./reports/calender.sdf
# write_sdc -nosplit ./reports/mux_synthesized.sdc
# write -hierarchy -format ddc -output ./reports/mux_synthesized.ddc