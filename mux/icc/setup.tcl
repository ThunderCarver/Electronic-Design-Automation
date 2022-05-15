#set stdcells_home /home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180

#set_app_var search_path "$stdcells_home"

#set_app_var target_library "$stdcells_home/digital/sc/synopsys/typical.db"

#set_app_var symbol_library "$stdcells_home/digital/sc/synopsys/smic18.sdb"

#set_app_var link_library "* $target_library"

set link_library "/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/digital/sc/synopsys/typical.db"

set target_library "/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/digital/sc/synopsys/typical.db"

set symbol_library "/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/digital/sc/synopsys/smic18.sdb"

set synthetic_library "/home/lishang/ckfang/Projects/crossbar_tcl/pdk/smic180/dw_foundation.sldb"

set link_library [concat $link_library $synthetic_library]

alias h history
alias rc "report_constraint -all_violators"
