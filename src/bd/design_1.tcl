
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# test_stream_sink, traffic_generator, inject_tlast_on_trigger

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART digilentinc.com:eclypse-z7:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_clock_converter:1.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
test_stream_sink\
traffic_generator\
inject_tlast_on_trigger\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: TriggerDetector_0
proc create_hier_cell_TriggerDetector_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_TriggerDetector_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 axis_in

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_out


  # Create pins
  create_bd_pin -dir I -type clk axi_clk
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type clk stream_clk

  # Create instance: axi_rst, and set properties
  set axi_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_rst ]

  # Create instance: cfg_0, and set properties
  set cfg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 cfg_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_IS_DUAL {1} \
 ] $cfg_0

  # Create instance: counter_cfg_0, and set properties
  set counter_cfg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 counter_cfg_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $counter_cfg_0

  # Create instance: ctrl_0, and set properties
  set ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 ctrl_0 ]
  set_property -dict [ list \
   CONFIG.C_GPIO_WIDTH {2} \
   CONFIG.C_TRI_DEFAULT {0xFFFFFFFE} \
 ] $ctrl_0

  # Create instance: inject_tlast_on_trig_0, and set properties
  set block_name inject_tlast_on_trigger
  set block_cell_name inject_tlast_on_trig_0
  if { [catch {set inject_tlast_on_trig_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $inject_tlast_on_trig_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] [get_bd_intf_pins /TriggerDetector_0/inject_tlast_on_trig_0/m]

  # Create instance: manual_trigger_0, and set properties
  set manual_trigger_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 manual_trigger_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
 ] $manual_trigger_0

  # Create instance: stream_rst, and set properties
  set stream_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 stream_rst ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlslice_0_downto_0, and set properties
  set xlslice_0_downto_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0_downto_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {2} \
 ] $xlslice_0_downto_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axis_in] [get_bd_intf_pins inject_tlast_on_trig_0/s]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axis_out] [get_bd_intf_pins inject_tlast_on_trig_0/m]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI] [get_bd_intf_pins cfg_0/S_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI1] [get_bd_intf_pins counter_cfg_0/S_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI2] [get_bd_intf_pins ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins S_AXI3] [get_bd_intf_pins manual_trigger_0/S_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins ctrl_0/gpio_io_o] [get_bd_pins xlslice_0_downto_0/Din]
  connect_bd_net -net clk1_1 [get_bd_pins stream_clk] [get_bd_pins inject_tlast_on_trig_0/stream_clk] [get_bd_pins stream_rst/slowest_sync_clk]
  connect_bd_net -net clk_1 [get_bd_pins axi_clk] [get_bd_pins axi_rst/slowest_sync_clk] [get_bd_pins cfg_0/s_axi_aclk] [get_bd_pins counter_cfg_0/s_axi_aclk] [get_bd_pins ctrl_0/s_axi_aclk] [get_bd_pins manual_trigger_0/s_axi_aclk]
  connect_bd_net -net counter_cfg_0_gpio2_io_o [get_bd_pins counter_cfg_0/gpio2_io_o] [get_bd_pins inject_tlast_on_trig_0/prebuffer_beats_i]
  connect_bd_net -net counter_cfg_0_gpio_io_o [get_bd_pins counter_cfg_0/gpio_io_o] [get_bd_pins inject_tlast_on_trig_0/trigger_to_last_beats_i]
  connect_bd_net -net ctrl_0_gpio_io_o [get_bd_pins cfg_0/gpio_io_o] [get_bd_pins inject_tlast_on_trig_0/trigger_enable_i]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ext_reset_in] [get_bd_pins axi_rst/ext_reset_in] [get_bd_pins stream_rst/ext_reset_in]
  connect_bd_net -net fclk1_rst2_peripheral_aresetn [get_bd_pins inject_tlast_on_trig_0/stream_resetn] [get_bd_pins stream_rst/peripheral_aresetn]
  connect_bd_net -net inject_tlast_on_trig_0_idle [get_bd_pins inject_tlast_on_trig_0/idle_o] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net inject_tlast_on_trig_0_trigger_detected [get_bd_pins cfg_0/gpio2_io_i] [get_bd_pins inject_tlast_on_trig_0/trigger_detected_o]
  connect_bd_net -net manual_trigger_0_gpio_io_o [get_bd_pins inject_tlast_on_trig_0/trigger] [get_bd_pins manual_trigger_0/gpio_io_o]
  connect_bd_net -net resetn_1 [get_bd_pins axi_rst/peripheral_aresetn] [get_bd_pins cfg_0/s_axi_aresetn] [get_bd_pins counter_cfg_0/s_axi_aresetn] [get_bd_pins ctrl_0/s_axi_aresetn] [get_bd_pins manual_trigger_0/s_axi_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins ctrl_0/gpio_io_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_downto_0_Dout [get_bd_pins inject_tlast_on_trig_0/start_i] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_0_downto_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TestAxiStreamSource_0
proc create_hier_cell_TestAxiStreamSource_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_TestAxiStreamSource_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis


  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type clk stream_clk

  # Create instance: axi_reset, and set properties
  set axi_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_reset ]

  # Create instance: ctrl_0, and set properties
  set ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 ctrl_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {32} \
 ] $ctrl_0

  # Create instance: stream_reset, and set properties
  set stream_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 stream_reset ]

  # Create instance: traffic_generator_0, and set properties
  set block_name traffic_generator
  set block_cell_name traffic_generator_0
  if { [catch {set traffic_generator_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $traffic_generator_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlslice_0_downto_0, and set properties
  set xlslice_0_downto_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0_downto_0 ]

  # Create instance: xlslice_1_downto_1, and set properties
  set xlslice_1_downto_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1_downto_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_1_downto_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net traffic_generator_0_a_axis [get_bd_intf_pins axis] [get_bd_intf_pins traffic_generator_0/a_axis]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins ext_reset_in] [get_bd_pins axi_reset/ext_reset_in] [get_bd_pins stream_reset/ext_reset_in]
  connect_bd_net -net a_clk_1 [get_bd_pins stream_clk] [get_bd_pins stream_reset/slowest_sync_clk] [get_bd_pins traffic_generator_0/a_clk]
  connect_bd_net -net axi_reset_peripheral_aresetn [get_bd_pins axi_reset/peripheral_aresetn] [get_bd_pins ctrl_0/s_axi_aresetn]
  connect_bd_net -net ctrl_0_gpio_io_o [get_bd_pins ctrl_0/gpio_io_o] [get_bd_pins xlslice_0_downto_0/Din] [get_bd_pins xlslice_1_downto_1/Din]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins axi_reset/slowest_sync_clk] [get_bd_pins ctrl_0/s_axi_aclk] [get_bd_pins traffic_generator_0/b_clk]
  connect_bd_net -net stream_reset_peripheral_aresetn [get_bd_pins stream_reset/peripheral_aresetn] [get_bd_pins traffic_generator_0/a_resetn]
  connect_bd_net -net xlslice_0_downto_0_Dout [get_bd_pins traffic_generator_0/b_enable] [get_bd_pins xlslice_0_downto_0/Dout]
  connect_bd_net -net xlslice_1_downto_1_Dout [get_bd_pins traffic_generator_0/b_freerun] [get_bd_pins xlslice_1_downto_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TestAxiStreamSink_0
proc create_hier_cell_TestAxiStreamSink_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_TestAxiStreamSink_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GPIO0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GPIO1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 axis


  # Create pins
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type clk slowest_sync_clk

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {0} \
   CONFIG.C_GPIO_WIDTH {2} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.C_TRI_DEFAULT {0xFFFFFFFE} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_1

  # Create instance: axi_lite_rst, and set properties
  set axi_lite_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_lite_rst ]

  # Create instance: stream_rst, and set properties
  set stream_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 stream_rst ]

  # Create instance: test_stream_sink_0, and set properties
  set block_name test_stream_sink
  set block_cell_name test_stream_sink_0
  if { [catch {set test_stream_sink_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $test_stream_sink_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlslice_0_downto_0, and set properties
  set xlslice_0_downto_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0_downto_0 ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {2} \
 ] $xlslice_0_downto_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_GPIO0] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_GPIO1] [get_bd_intf_pins axi_gpio_1/S_AXI]
  connect_bd_intf_net -intf_net Mm2sDmaTransfer_0_M_AXIS [get_bd_intf_pins axis] [get_bd_intf_pins test_stream_sink_0/axis]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins slowest_sync_clk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_lite_rst/slowest_sync_clk]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_0_downto_0/Din]
  connect_bd_net -net axi_lite_rst_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_lite_rst/peripheral_aresetn]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ext_reset_in] [get_bd_pins axi_lite_rst/ext_reset_in] [get_bd_pins stream_rst/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins clk] [get_bd_pins stream_rst/slowest_sync_clk] [get_bd_pins test_stream_sink_0/clk]
  connect_bd_net -net stream_rst_peripheral_aresetn [get_bd_pins stream_rst/peripheral_aresetn] [get_bd_pins test_stream_sink_0/resetn]
  connect_bd_net -net test_stream_sink_0_beat_count [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins test_stream_sink_0/beat_count]
  connect_bd_net -net test_stream_sink_0_error_count [get_bd_pins axi_gpio_1/gpio2_io_i] [get_bd_pins test_stream_sink_0/error_count]
  connect_bd_net -net test_stream_sink_0_idle [get_bd_pins test_stream_sink_0/idle] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net test_stream_sink_0_miss_count [get_bd_pins axi_gpio_1/gpio_io_i] [get_bd_pins test_stream_sink_0/miss_count]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlslice_0_downto_0_Dout [get_bd_pins test_stream_sink_0/start] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_0_downto_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: S2mmDmaTransfer_0
proc create_hier_cell_S2mmDmaTransfer_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_S2mmDmaTransfer_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir I -type clk m_axi_sg_aclk
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type clk stream_aclk

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_mm2s_burst_size {16} \
   CONFIG.c_s2mm_burst_size {256} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_0

  # Create instance: axi_lite_rst, and set properties
  set axi_lite_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_lite_rst ]

  # Create instance: axi_s2mm_rst, and set properties
  set axi_s2mm_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_s2mm_rst ]

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: stream_rst, and set properties
  set stream_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 stream_rst ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_dma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_clock_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net ACLK_1 [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_s2mm_rst/slowest_sync_clk] [get_bd_pins axis_clock_converter_0/m_axis_aclk]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ext_reset_in] [get_bd_pins axi_lite_rst/ext_reset_in] [get_bd_pins axi_s2mm_rst/ext_reset_in] [get_bd_pins stream_rst/ext_reset_in]
  connect_bd_net -net fclk0_rst_peripheral_aresetn [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins stream_rst/peripheral_aresetn]
  connect_bd_net -net fclk1_rst1_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_lite_rst/peripheral_aresetn]
  connect_bd_net -net fclk2_rst1_peripheral_aresetn [get_bd_pins axi_s2mm_rst/peripheral_aresetn] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net m_axi_sg_aclk_1 [get_bd_pins m_axi_sg_aclk] [get_bd_pins axi_dma_0/m_axi_sg_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins stream_aclk] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins stream_rst/slowest_sync_clk]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_lite_rst/slowest_sync_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Mm2sDmaTransfer_0
proc create_hier_cell_Mm2sDmaTransfer_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_Mm2sDmaTransfer_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type clk m_axi_mm2s_aclk
  create_bd_pin -dir I -type clk m_axi_sg_aclk
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type clk stream_aclk

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axi_s2mm_data_width {64} \
   CONFIG.c_mm2s_burst_size {256} \
   CONFIG.c_s2mm_burst_size {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $axi_dma_0

  # Create instance: axi_lite_rst, and set properties
  set axi_lite_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_lite_rst ]

  # Create instance: axi_s2mm_rst, and set properties
  set axi_s2mm_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 axi_s2mm_rst ]

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]

  # Create instance: stream_rst, and set properties
  set stream_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 stream_rst ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_dma_0/M_AXI_SG]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_dma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_clock_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ext_reset_in] [get_bd_pins axi_lite_rst/ext_reset_in] [get_bd_pins axi_s2mm_rst/ext_reset_in] [get_bd_pins stream_rst/ext_reset_in]
  connect_bd_net -net fclk0_rst_peripheral_aresetn [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins stream_rst/peripheral_aresetn]
  connect_bd_net -net fclk1_rst1_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_lite_rst/peripheral_aresetn]
  connect_bd_net -net fclk2_rst1_peripheral_aresetn [get_bd_pins axi_s2mm_rst/peripheral_aresetn] [get_bd_pins axis_clock_converter_0/m_axis_aresetn]
  connect_bd_net -net m_axi_mm2s_aclk_1 [get_bd_pins m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins stream_rst/slowest_sync_clk]
  connect_bd_net -net m_axi_sg_aclk_1 [get_bd_pins m_axi_sg_aclk] [get_bd_pins axi_dma_0/m_axi_sg_aclk]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_lite_rst/slowest_sync_clk]
  connect_bd_net -net stream_aclk_1 [get_bd_pins stream_aclk] [get_bd_pins axi_s2mm_rst/slowest_sync_clk] [get_bd_pins axis_clock_converter_0/m_axis_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports

  # Create instance: Mm2sDmaTransfer_0
  create_hier_cell_Mm2sDmaTransfer_0 [current_bd_instance .] Mm2sDmaTransfer_0

  # Create instance: S2mmDmaTransfer_0
  create_hier_cell_S2mmDmaTransfer_0 [current_bd_instance .] S2mmDmaTransfer_0

  # Create instance: TestAxiStreamSink_0
  create_hier_cell_TestAxiStreamSink_0 [current_bd_instance .] TestAxiStreamSink_0

  # Create instance: TestAxiStreamSource_0
  create_hier_cell_TestAxiStreamSource_0 [current_bd_instance .] TestAxiStreamSource_0

  # Create instance: TriggerDetector_0
  create_hier_cell_TriggerDetector_0 [current_bd_instance .] TriggerDetector_0

  # Create instance: fclk1_rst, and set properties
  set fclk1_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 fclk1_rst ]

  # Create instance: fclk2_rst, and set properties
  set fclk2_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 fclk2_rst ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {50000000} \
   CONFIG.PCW_CLK1_FREQ {100000000} \
   CONFIG.PCW_CLK2_FREQ {133333344} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {1} \
   CONFIG.PCW_ENET0_RESET_IO {MIO 9} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C1 {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {4} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {133} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_I2C1_IO {MIO 12 .. 13} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {fast} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {fast} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {fast} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {fast} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {fast} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {fast} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {fast} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {fast} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {fast} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {fast} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {fast} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {fast} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {fast} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {fast} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {fast} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {fast} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {fast} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {fast} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {fast} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {fast} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {fast} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {fast} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {fast} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {fast} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {out} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {inout} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {inout} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {out} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI\
Flash#Quad SPI Flash#GPIO#Quad SPI Flash#ENET Reset#GPIO#GPIO#I2C 1#I2C 1#UART\
0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet\
0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB\
0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#USB Reset#SD 0#GPIO#GPIO#GPIO#GPIO#Enet\
0#Enet 0}\
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#reset#gpio[10]#gpio[11]#scl#sda#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#reset#cd#gpio[48]#gpio[49]#gpio[50]#gpio[51]#mdc#mdio}\
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.311} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.311} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.304} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.304} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {0.202} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.202} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {0.029} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {0.031} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.311} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.311} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.304} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.304} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {63.2909} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {63.2909} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {49.1639} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {49.1639} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {32.2611} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {32.2666} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {44.6376} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {44.3743} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.202} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.202} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.029} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.031} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {32.5236} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {32.3526} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {44.4929} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {44.4683} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {165.1} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
   CONFIG.PCW_USB0_RESET_IO {MIO 46} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {9} \
 ] $ps7_0_axi_periph

  # Create instance: sg_rst, and set properties
  set sg_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 sg_rst ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {2} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: smartconnect_2, and set properties
  set smartconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_2

  # Create interface connections
  connect_bd_intf_net -intf_net Mm2sDmaTransfer_0_M_AXIS [get_bd_intf_pins Mm2sDmaTransfer_0/M_AXIS] [get_bd_intf_pins TestAxiStreamSink_0/axis]
  connect_bd_intf_net -intf_net Mm2sDmaTransfer_0_M_AXI_MM2S [get_bd_intf_pins Mm2sDmaTransfer_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net Mm2sDmaTransfer_0_M_AXI_SG [get_bd_intf_pins Mm2sDmaTransfer_0/M_AXI_SG] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net S2mmDmaTransfer_0_M_AXI_S2MM [get_bd_intf_pins S2mmDmaTransfer_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net S2mmDmaTransfer_0_M_AXI_SG [get_bd_intf_pins S2mmDmaTransfer_0/M_AXI_SG] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net TriggerDetector_0_axis_out [get_bd_intf_pins S2mmDmaTransfer_0/S_AXIS] [get_bd_intf_pins TriggerDetector_0/axis_out]
  connect_bd_intf_net -intf_net axis_in_1 [get_bd_intf_pins TestAxiStreamSource_0/axis] [get_bd_intf_pins TriggerDetector_0/axis_in]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins TriggerDetector_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins TriggerDetector_0/S_AXI1] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins TriggerDetector_0/S_AXI2] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins TriggerDetector_0/S_AXI3] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins S2mmDmaTransfer_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins TestAxiStreamSource_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins Mm2sDmaTransfer_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins TestAxiStreamSink_0/S_AXI_GPIO0] [get_bd_intf_pins ps7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins TestAxiStreamSink_0/S_AXI_GPIO1] [get_bd_intf_pins ps7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP1] [get_bd_intf_pins smartconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_2_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP2] [get_bd_intf_pins smartconnect_2/M00_AXI]

  # Create port connections
  connect_bd_net -net axi_lite_rst_peripheral_aresetn [get_bd_pins sg_rst/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net dma_aclk_1 [get_bd_pins Mm2sDmaTransfer_0/m_axi_mm2s_aclk] [get_bd_pins Mm2sDmaTransfer_0/m_axi_sg_aclk] [get_bd_pins S2mmDmaTransfer_0/m_axi_s2mm_aclk] [get_bd_pins S2mmDmaTransfer_0/m_axi_sg_aclk] [get_bd_pins fclk2_rst/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK2] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins sg_rst/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk] [get_bd_pins smartconnect_2/aclk]
  connect_bd_net -net dma_resetn_1 [get_bd_pins fclk2_rst/peripheral_aresetn] [get_bd_pins smartconnect_1/aresetn] [get_bd_pins smartconnect_2/aresetn]
  connect_bd_net -net fclk1_rst_peripheral_aresetn [get_bd_pins fclk1_rst/peripheral_aresetn] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/M06_ARESETN] [get_bd_pins ps7_0_axi_periph/M07_ARESETN] [get_bd_pins ps7_0_axi_periph/M08_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins Mm2sDmaTransfer_0/stream_aclk] [get_bd_pins S2mmDmaTransfer_0/stream_aclk] [get_bd_pins TestAxiStreamSink_0/clk] [get_bd_pins TestAxiStreamSource_0/stream_clk] [get_bd_pins TriggerDetector_0/stream_clk] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins Mm2sDmaTransfer_0/s_axi_lite_aclk] [get_bd_pins S2mmDmaTransfer_0/s_axi_lite_aclk] [get_bd_pins TestAxiStreamSink_0/slowest_sync_clk] [get_bd_pins TestAxiStreamSource_0/s_axi_aclk] [get_bd_pins TriggerDetector_0/axi_clk] [get_bd_pins fclk1_rst/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/M06_ACLK] [get_bd_pins ps7_0_axi_periph/M07_ACLK] [get_bd_pins ps7_0_axi_periph/M08_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins Mm2sDmaTransfer_0/ext_reset_in] [get_bd_pins S2mmDmaTransfer_0/ext_reset_in] [get_bd_pins TestAxiStreamSink_0/ext_reset_in] [get_bd_pins TestAxiStreamSource_0/ext_reset_in] [get_bd_pins TriggerDetector_0/ext_reset_in] [get_bd_pins fclk1_rst/ext_reset_in] [get_bd_pins fclk2_rst/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins sg_rst/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0x40410000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs Mm2sDmaTransfer_0/axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x40400000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs S2mmDmaTransfer_0/axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TestAxiStreamSink_0/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TestAxiStreamSink_0/axi_gpio_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41210000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TriggerDetector_0/cfg_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41220000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TriggerDetector_0/counter_cfg_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TestAxiStreamSource_0/ctrl_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41230000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TriggerDetector_0/ctrl_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TriggerDetector_0/manual_trigger_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces Mm2sDmaTransfer_0/axi_dma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces Mm2sDmaTransfer_0/axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces S2mmDmaTransfer_0/axi_dma_0/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces S2mmDmaTransfer_0/axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


