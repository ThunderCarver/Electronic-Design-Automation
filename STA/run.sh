#!/bin/bash

export DESIGN_NAME=top
export FILE_LIST=./flist
export SDC_FILE=./sdc
export SETUP_TCL=./setup.tcl
export TARGET_LIBS=/YOUR/PATH/TO/DB/tcbn65lp_220a/FE/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn65lp_200a/tcbn65lpwc_ccs.db

export LOG_DIR=./log
export RESULTS_DIR=./results

mkdir -p ${LOG_DIR} ${RESULTS_DIR}
dc_shell -f ./dc.tcl 2>&1 | tee ${LOG_DIR}/synth.log
