
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
set scripts_vivado_version 2023.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
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
natinst.com:user:Filter_Top_Level:*\
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:clk_wiz:*\
xilinx.com:ip:xlconstant:*\
digilent.com:user:ZmodScopeController:*\
digilent.com:user:ZmodAWGController:*\
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

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



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

  # Create ports
  set ZmodAdcClkIn_n_0 [ create_bd_port -dir O ZmodAdcClkIn_n_0 ]
  set ZmodAdcClkIn_p_0 [ create_bd_port -dir O ZmodAdcClkIn_p_0 ]
  set ZmodDAC_ClkIO_0 [ create_bd_port -dir O ZmodDAC_ClkIO_0 ]
  set ZmodDAC_Clkin_0 [ create_bd_port -dir O -type clk ZmodDAC_Clkin_0 ]
  set ZmodDcoClk_0 [ create_bd_port -dir I -type clk ZmodDcoClk_0 ]
  set clk_in1_0 [ create_bd_port -dir I -type clk -freq_hz 125000000 clk_in1_0 ]
  set dZmodADC_Data_0 [ create_bd_port -dir I -from 13 -to 0 dZmodADC_Data_0 ]
  set dZmodDAC_Data_0 [ create_bd_port -dir O -from 13 -to 0 dZmodDAC_Data_0 ]
  set iZmodSync_0 [ create_bd_port -dir O iZmodSync_0 ]
  set reset_rtl_0_0 [ create_bd_port -dir I -type rst reset_rtl_0_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0
  set sZmodADC_CS_0 [ create_bd_port -dir O sZmodADC_CS_0 ]
  set sZmodADC_SDIO_0 [ create_bd_port -dir IO sZmodADC_SDIO_0 ]
  set sZmodADC_Sclk_0 [ create_bd_port -dir O sZmodADC_Sclk_0 ]
  set sZmodCh1CouplingH_0 [ create_bd_port -dir O sZmodCh1CouplingH_0 ]
  set sZmodCh1CouplingL_0 [ create_bd_port -dir O sZmodCh1CouplingL_0 ]
  set sZmodCh1GainH_0 [ create_bd_port -dir O sZmodCh1GainH_0 ]
  set sZmodCh1GainL_0 [ create_bd_port -dir O sZmodCh1GainL_0 ]
  set sZmodCh2CouplingH_0 [ create_bd_port -dir O sZmodCh2CouplingH_0 ]
  set sZmodCh2CouplingL_0 [ create_bd_port -dir O sZmodCh2CouplingL_0 ]
  set sZmodCh2GainH_0 [ create_bd_port -dir O sZmodCh2GainH_0 ]
  set sZmodCh2GainL_0 [ create_bd_port -dir O sZmodCh2GainL_0 ]
  set sZmodDAC_CS_0 [ create_bd_port -dir O sZmodDAC_CS_0 ]
  set sZmodDAC_EnOut_0 [ create_bd_port -dir O sZmodDAC_EnOut_0 ]
  set sZmodDAC_Reset_0 [ create_bd_port -dir O -type rst sZmodDAC_Reset_0 ]
  set sZmodDAC_SCLK_0 [ create_bd_port -dir O sZmodDAC_SCLK_0 ]
  set sZmodDAC_SDIO_0 [ create_bd_port -dir IO sZmodDAC_SDIO_0 ]
  set sZmodDAC_SetFS1_0 [ create_bd_port -dir O sZmodDAC_SetFS1_0 ]
  set sZmodDAC_SetFS2_0 [ create_bd_port -dir O sZmodDAC_SetFS2_0 ]
  set sZmodRelayComH_0 [ create_bd_port -dir O sZmodRelayComH_0 ]
  set sZmodRelayComL_0 [ create_bd_port -dir O sZmodRelayComL_0 ]

  # Create instance: Filter_Top_Level_0, and set properties
  set Filter_Top_Level_0 [ create_bd_cell -type ip -vlnv natinst.com:user:Filter_Top_Level Filter_Top_Level_0 ]
  set_property CONFIG.kDecimFactor {39} $Filter_Top_Level_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {80.0} \
    CONFIG.CLKOUT1_JITTER {321.613} \
    CONFIG.CLKOUT1_PHASE_ERROR {265.359} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {40} \
    CONFIG.CLKOUT1_REQUESTED_PHASE {0} \
    CONFIG.CLKOUT2_JITTER {321.613} \
    CONFIG.CLKOUT2_PHASE_ERROR {265.359} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {40} \
    CONFIG.CLKOUT2_REQUESTED_PHASE {90} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_JITTER {242.716} \
    CONFIG.CLKOUT3_PHASE_ERROR {265.359} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {160} \
    CONFIG.CLKOUT3_REQUESTED_PHASE {90} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {32.000} \
    CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
    CONFIG.MMCM_CLKOUT0_PHASE {0.000} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {20} \
    CONFIG.MMCM_CLKOUT1_PHASE {90.000} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {5} \
    CONFIG.MMCM_CLKOUT2_PHASE {90.000} \
    CONFIG.MMCM_DIVCLK_DIVIDE {5} \
    CONFIG.NUM_OUT_CLKS {3} \
  ] $clk_wiz_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_1 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_1


  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_2 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_2


  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_3 ]
  set_property CONFIG.CONST_VAL {1} $xlconstant_3


  # Create instance: ZmodADC_Controller_0, and set properties
  set ZmodADC_Controller_0 [ create_bd_cell -type ip -vlnv digilent.com:user:ZmodScopeController ZmodADC_Controller_0 ]
  set_property -dict [list \
    CONFIG.kCh1GainStatic {"1"} \
    CONFIG.kCh1HgAddCoefStatic {"00000000000000000000"} \
    CONFIG.kCh1HgMultCoefStatic {"00010000000000000000"} \
    CONFIG.kCh1LgAddCoefStatic {"00000000000000000000"} \
    CONFIG.kCh1LgMultCoefStatic {"00010000000000000000"} \
    CONFIG.kCh2GainStatic {"1"} \
    CONFIG.kCh2HgAddCoefStatic {"00000000000000000000"} \
    CONFIG.kCh2HgMultCoefStatic {"00010000000000000000"} \
    CONFIG.kCh2LgAddCoefStatic {"00000000000000000000"} \
    CONFIG.kCh2LgMultCoefStatic {"00010000000000000000"} \
    CONFIG.kExtCalibEn {false} \
    CONFIG.kExtRelayConfigEn {false} \
    CONFIG.kSamplingPeriod {25000} \
  ] $ZmodADC_Controller_0


  # Create instance: ZmodDAC1411_Controll_0, and set properties
  set ZmodDAC1411_Controll_0 [ create_bd_cell -type ip -vlnv digilent.com:user:ZmodAWGController ZmodDAC1411_Controll_0 ]
  set_property -dict [list \
    CONFIG.kExtCalibEn {false} \
    CONFIG.kExtCmdInterfaceEn {false} \
    CONFIG.kExtScaleConfigEn {false} \
  ] $ZmodDAC1411_Controll_0


  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_4 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Filter_Top_Level_0_OutDataStream [get_bd_intf_pins Filter_Top_Level_0/OutDataStream] [get_bd_intf_pins ZmodDAC1411_Controll_0/InputDataStream]
  connect_bd_intf_net -intf_net ZmodADC_Controller_0_DataStream [get_bd_intf_pins Filter_Top_Level_0/InDataStream] [get_bd_intf_pins ZmodADC_Controller_0/DataStream]

  # Create port connections
  connect_bd_net -net Net [get_bd_ports sZmodDAC_SDIO_0] [get_bd_pins ZmodDAC1411_Controll_0/sZmodDAC_SDIO]
  connect_bd_net -net Net1 [get_bd_ports sZmodADC_SDIO_0] [get_bd_pins ZmodADC_Controller_0/sZmodADC_SDIO]
  connect_bd_net -net ZmodADC_Controller_0_ZmodAdcClkIn_n [get_bd_pins ZmodADC_Controller_0/ZmodAdcClkIn_n] [get_bd_ports ZmodAdcClkIn_n_0]
  connect_bd_net -net ZmodADC_Controller_0_ZmodAdcClkIn_p [get_bd_pins ZmodADC_Controller_0/ZmodAdcClkIn_p] [get_bd_ports ZmodAdcClkIn_p_0]
  connect_bd_net -net ZmodADC_Controller_0_iZmodSync [get_bd_pins ZmodADC_Controller_0/iZmodSync] [get_bd_ports iZmodSync_0]
  connect_bd_net -net ZmodADC_Controller_0_sInitDoneADC [get_bd_pins ZmodADC_Controller_0/sInitDoneADC] [get_bd_pins Filter_Top_Level_0/sInitDoneADC]
  connect_bd_net -net ZmodADC_Controller_0_sInitDoneRelay [get_bd_pins ZmodADC_Controller_0/sInitDoneRelay] [get_bd_pins Filter_Top_Level_0/sInitDoneRelay]
  connect_bd_net -net ZmodADC_Controller_0_sZmodADC_CS [get_bd_pins ZmodADC_Controller_0/sZmodADC_CS] [get_bd_ports sZmodADC_CS_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodADC_Sclk [get_bd_pins ZmodADC_Controller_0/sZmodADC_Sclk] [get_bd_ports sZmodADC_Sclk_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1CouplingH [get_bd_pins ZmodADC_Controller_0/sZmodCh1CouplingH] [get_bd_ports sZmodCh1CouplingH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1CouplingL [get_bd_pins ZmodADC_Controller_0/sZmodCh1CouplingL] [get_bd_ports sZmodCh1CouplingL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1GainH [get_bd_pins ZmodADC_Controller_0/sZmodCh1GainH] [get_bd_ports sZmodCh1GainH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh1GainL [get_bd_pins ZmodADC_Controller_0/sZmodCh1GainL] [get_bd_ports sZmodCh1GainL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2CouplingH [get_bd_pins ZmodADC_Controller_0/sZmodCh2CouplingH] [get_bd_ports sZmodCh2CouplingH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2CouplingL [get_bd_pins ZmodADC_Controller_0/sZmodCh2CouplingL] [get_bd_ports sZmodCh2CouplingL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2GainH [get_bd_pins ZmodADC_Controller_0/sZmodCh2GainH] [get_bd_ports sZmodCh2GainH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodCh2GainL [get_bd_pins ZmodADC_Controller_0/sZmodCh2GainL] [get_bd_ports sZmodCh2GainL_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodRelayComH [get_bd_pins ZmodADC_Controller_0/sZmodRelayComH] [get_bd_ports sZmodRelayComH_0]
  connect_bd_net -net ZmodADC_Controller_0_sZmodRelayComL [get_bd_pins ZmodADC_Controller_0/sZmodRelayComL] [get_bd_ports sZmodRelayComL_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sInitDoneDAC [get_bd_pins ZmodDAC1411_Controll_0/sInitDoneDAC] [get_bd_pins Filter_Top_Level_0/sInitDoneDAC]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_CS [get_bd_pins ZmodDAC1411_Controll_0/sZmodDAC_CS] [get_bd_ports sZmodDAC_CS_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_ClkIO [get_bd_pins ZmodDAC1411_Controll_0/ZmodDAC_ClkIO] [get_bd_ports ZmodDAC_ClkIO_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_Clkin [get_bd_pins ZmodDAC1411_Controll_0/ZmodDAC_ClkIn] [get_bd_ports ZmodDAC_Clkin_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_Data [get_bd_pins ZmodDAC1411_Controll_0/dZmodDAC_Data] [get_bd_ports dZmodDAC_Data_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_EnOut [get_bd_pins ZmodDAC1411_Controll_0/sZmodDAC_EnOut] [get_bd_ports sZmodDAC_EnOut_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_Reset [get_bd_pins ZmodDAC1411_Controll_0/sZmodDAC_Reset] [get_bd_ports sZmodDAC_Reset_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_SCLK [get_bd_pins ZmodDAC1411_Controll_0/sZmodDAC_SCLK] [get_bd_ports sZmodDAC_SCLK_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_SetFS1 [get_bd_pins ZmodDAC1411_Controll_0/sZmodDAC_SetFS1] [get_bd_ports sZmodDAC_SetFS1_0]
  connect_bd_net -net ZmodDAC1411_Controll_0_sZmodDAC_SetFS2 [get_bd_pins ZmodDAC1411_Controll_0/sZmodDAC_SetFS2] [get_bd_ports sZmodDAC_SetFS2_0]
  connect_bd_net -net ZmodDcoClk_0_1 [get_bd_ports ZmodDcoClk_0] [get_bd_pins ZmodADC_Controller_0/ZmodDcoClk]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports clk_in1_0] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins ZmodDAC1411_Controll_0/DAC_Clk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins ZmodADC_Controller_0/ADC_InClk]
  connect_bd_net -net dZmodADC_Data_0_1 [get_bd_ports dZmodADC_Data_0] [get_bd_pins ZmodADC_Controller_0/dZmodADC_Data]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins Filter_Top_Level_0/aRst_n] [get_bd_pins ZmodADC_Controller_0/aRst_n] [get_bd_pins ZmodDAC1411_Controll_0/aRst_n]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins Filter_Top_Level_0/SamplingClk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins ZmodADC_Controller_0/SysClk100] [get_bd_pins ZmodADC_Controller_0/ADC_SamplingClk] [get_bd_pins ZmodDAC1411_Controll_0/SysClk100] [get_bd_pins ZmodDAC1411_Controll_0/DAC_InIO_Clk]
  connect_bd_net -net reset_rtl_0_0_1 [get_bd_ports reset_rtl_0_0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins proc_sys_reset_0/dcm_locked]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins xlconstant_2/dout] [get_bd_pins ZmodADC_Controller_0/sTestMode] [get_bd_pins ZmodDAC1411_Controll_0/sTestMode]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins xlconstant_3/dout] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_EnIn]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins xlconstant_4/dout] [get_bd_pins ZmodADC_Controller_0/sEnableAcquisition]

  # Create address segments


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


