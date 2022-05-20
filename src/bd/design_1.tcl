
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
set scripts_vivado_version 2022.1
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
natinst.com:user:Filter_Top_Level:1.0\
xilinx.com:user:ZmodADC1410_Controller:1.0\
natinst.com:user:ZmodDAC1411_Controller:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
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
  set ADC_DATA_0 [ create_bd_port -dir I -from 13 -to 0 ADC_DATA_0 ]
  set ADC_DCO_0 [ create_bd_port -dir I ADC_DCO_0 ]
  set ADC_SYNC_0 [ create_bd_port -dir O ADC_SYNC_0 ]
  set CLKIN_ADC_N_0 [ create_bd_port -dir O CLKIN_ADC_N_0 ]
  set CLKIN_ADC_P_0 [ create_bd_port -dir O CLKIN_ADC_P_0 ]
  set DAC_CLKIN_0 [ create_bd_port -dir O -type clk DAC_CLKIN_0 ]
  set DAC_CLKIO_0 [ create_bd_port -dir O DAC_CLKIO_0 ]
  set DAC_CS_0 [ create_bd_port -dir O DAC_CS_0 ]
  set DAC_DATA_0 [ create_bd_port -dir O -from 13 -to 0 DAC_DATA_0 ]
  set DAC_EN_0 [ create_bd_port -dir O DAC_EN_0 ]
  set DAC_RESET_0 [ create_bd_port -dir O -type rst DAC_RESET_0 ]
  set DAC_SCLK_0 [ create_bd_port -dir O DAC_SCLK_0 ]
  set DAC_SDIO_0 [ create_bd_port -dir IO DAC_SDIO_0 ]
  set DAC_SET_FS1_0 [ create_bd_port -dir O DAC_SET_FS1_0 ]
  set DAC_SET_FS2_0 [ create_bd_port -dir O DAC_SET_FS2_0 ]
  set SC1_AC_H_0 [ create_bd_port -dir O SC1_AC_H_0 ]
  set SC1_AC_L_0 [ create_bd_port -dir O SC1_AC_L_0 ]
  set SC1_GAIN_H_0 [ create_bd_port -dir O SC1_GAIN_H_0 ]
  set SC1_GAIN_L_0 [ create_bd_port -dir O SC1_GAIN_L_0 ]
  set SC2_AC_H_0 [ create_bd_port -dir O SC2_AC_H_0 ]
  set SC2_AC_L_0 [ create_bd_port -dir O SC2_AC_L_0 ]
  set SC2_GAIN_H_0 [ create_bd_port -dir O SC2_GAIN_H_0 ]
  set SC2_GAIN_L_0 [ create_bd_port -dir O SC2_GAIN_L_0 ]
  set SC_COM_H_0 [ create_bd_port -dir O SC_COM_H_0 ]
  set SC_COM_L_0 [ create_bd_port -dir O SC_COM_L_0 ]
  set clk_in1_0 [ create_bd_port -dir I -type clk -freq_hz 125000000 clk_in1_0 ]
  set cs_sc1_0 [ create_bd_port -dir O cs_sc1_0 ]
  set reset_rtl_0_0 [ create_bd_port -dir I -type rst reset_rtl_0_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0
  set sclk_sc_0 [ create_bd_port -dir O sclk_sc_0 ]
  set sdio_sc_0 [ create_bd_port -dir IO sdio_sc_0 ]

  # Create instance: Filter_Top_Level_0, and set properties
  set Filter_Top_Level_0 [ create_bd_cell -type ip -vlnv natinst.com:user:Filter_Top_Level:1.0 Filter_Top_Level_0 ]

  # Create instance: ZmodADC1410_Controll_0, and set properties
  set ZmodADC1410_Controll_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:ZmodADC1410_Controller:1.0 ZmodADC1410_Controll_0 ]
  set_property -dict [ list \
   CONFIG.kCh1HgMultCoefStatic {"010000000000000000"} \
   CONFIG.kCh1LgMultCoefStatic {"010000000000000000"} \
   CONFIG.kCh2HgMultCoefStatic {"010000000000000000"} \
   CONFIG.kCh2LgMultCoefStatic {"010000000000000000"} \
   CONFIG.kExtCalibEn {false} \
   CONFIG.kExtCmdInterfaceEn {false} \
   CONFIG.kExtRelayConfigEn {true} \
   CONFIG.kExtSyncEn {false} \
 ] $ZmodADC1410_Controll_0

  # Create instance: ZmodDAC1411_Controll_0, and set properties
  set ZmodDAC1411_Controll_0 [ create_bd_cell -type ip -vlnv natinst.com:user:ZmodDAC1411_Controller:1.0 ZmodDAC1411_Controll_0 ]
  set_property -dict [ list \
   CONFIG.kCh1HgMultCoefStatic {"010000000000000000"} \
   CONFIG.kCh1LgMultCoefStatic {"010000000000000000"} \
   CONFIG.kCh2HgMultCoefStatic {"010000000000000000"} \
   CONFIG.kCh2LgMultCoefStatic {"010000000000000000"} \
   CONFIG.kExtScaleConfigEn {true} \
 ] $ZmodDAC1411_Controll_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_JITTER {265.121} \
   CONFIG.CLKOUT1_PHASE_ERROR {265.359} \
   CONFIG.CLKOUT2_JITTER {208.542} \
   CONFIG.CLKOUT2_PHASE_ERROR {265.359} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {400.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {265.121} \
   CONFIG.CLKOUT3_PHASE_ERROR {265.359} \
   CONFIG.CLKOUT3_REQUESTED_PHASE {90} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {32.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {2} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {8} \
   CONFIG.MMCM_CLKOUT2_PHASE {90.000} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {3} \
 ] $clk_wiz_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_3

  # Create port connections
  connect_bd_net -net ADC_DATA_0_1 [get_bd_ports ADC_DATA_0] [get_bd_pins ZmodADC1410_Controll_0/dADC_Data]
  connect_bd_net -net ADC_DCO_0_1 [get_bd_ports ADC_DCO_0] [get_bd_pins ZmodADC1410_Controll_0/DcoClk]
  connect_bd_net -net Filter_Top_Level_0_SysDacCH1 [get_bd_pins Filter_Top_Level_0/sysDacCh1] [get_bd_pins ZmodDAC1411_Controll_0/sCh1In]
  connect_bd_net -net Filter_Top_Level_0_SysDacCH2 [get_bd_pins Filter_Top_Level_0/sysDacCh2] [get_bd_pins ZmodDAC1411_Controll_0/sCh2In]
  connect_bd_net -net Net [get_bd_ports DAC_SDIO_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SDIO]
  connect_bd_net -net Net2 [get_bd_ports sdio_sc_0] [get_bd_pins ZmodADC1410_Controll_0/sADC_SDIO]
  connect_bd_net -net ZmodADC1410_Controll_0_ADC_CH1 [get_bd_pins Filter_Top_Level_0/sysAdcCh1] [get_bd_pins ZmodADC1410_Controll_0/sCh1Out]
  connect_bd_net -net ZmodADC1410_Controll_0_ADC_CH2 [get_bd_pins ZmodADC1410_Controll_0/sCh2Out]
  connect_bd_net -net ZmodADC1410_Controll_0_ADC_SYNC [get_bd_ports ADC_SYNC_0] [get_bd_pins ZmodADC1410_Controll_0/adcSync]
  connect_bd_net -net ZmodADC1410_Controll_0_CALIB_DONE_N [get_bd_pins Filter_Top_Level_0/sysInitAdcDone] [get_bd_pins ZmodADC1410_Controll_0/sInitDone_n]
  connect_bd_net -net ZmodADC1410_Controll_0_CLKIN_ADC_N [get_bd_ports CLKIN_ADC_N_0] [get_bd_pins ZmodADC1410_Controll_0/adcClkIn_n]
  connect_bd_net -net ZmodADC1410_Controll_0_CLKIN_ADC_P [get_bd_ports CLKIN_ADC_P_0] [get_bd_pins ZmodADC1410_Controll_0/adcClkIn_p]
  connect_bd_net -net ZmodADC1410_Controll_0_SC1_AC_H [get_bd_ports SC1_AC_H_0] [get_bd_pins ZmodADC1410_Controll_0/sCh1CouplingH]
  connect_bd_net -net ZmodADC1410_Controll_0_SC1_AC_L [get_bd_ports SC1_AC_L_0] [get_bd_pins ZmodADC1410_Controll_0/sCh1CouplingL]
  connect_bd_net -net ZmodADC1410_Controll_0_SC1_GAIN_H [get_bd_ports SC1_GAIN_H_0] [get_bd_pins ZmodADC1410_Controll_0/sCh1GainH]
  connect_bd_net -net ZmodADC1410_Controll_0_SC1_GAIN_L [get_bd_ports SC1_GAIN_L_0] [get_bd_pins ZmodADC1410_Controll_0/sCh1GainL]
  connect_bd_net -net ZmodADC1410_Controll_0_SC2_AC_H [get_bd_ports SC2_AC_H_0] [get_bd_pins ZmodADC1410_Controll_0/sCh2CouplingH]
  connect_bd_net -net ZmodADC1410_Controll_0_SC2_AC_L [get_bd_ports SC2_AC_L_0] [get_bd_pins ZmodADC1410_Controll_0/sCh2CouplingL]
  connect_bd_net -net ZmodADC1410_Controll_0_SC2_GAIN_H [get_bd_ports SC2_GAIN_H_0] [get_bd_pins ZmodADC1410_Controll_0/sCh2GainH]
  connect_bd_net -net ZmodADC1410_Controll_0_SC2_GAIN_L [get_bd_ports SC2_GAIN_L_0] [get_bd_pins ZmodADC1410_Controll_0/sCh2GainL]
  connect_bd_net -net ZmodADC1410_Controll_0_SC_COM_H [get_bd_ports SC_COM_H_0] [get_bd_pins ZmodADC1410_Controll_0/sRelayComH]
  connect_bd_net -net ZmodADC1410_Controll_0_SC_COM_L [get_bd_ports SC_COM_L_0] [get_bd_pins ZmodADC1410_Controll_0/sRelayComL]
  connect_bd_net -net ZmodADC1410_Controll_0_cs_sc1 [get_bd_ports cs_sc1_0] [get_bd_pins ZmodADC1410_Controll_0/sADC_CS]
  connect_bd_net -net ZmodADC1410_Controll_0_sclk_sc [get_bd_ports sclk_sc_0] [get_bd_pins ZmodADC1410_Controll_0/sADC_Sclk]
  connect_bd_net -net ZmodDAC1411_Controll_0_CALIB_DONE_N [get_bd_pins Filter_Top_Level_0/sysInitDacDone] [get_bd_pins ZmodDAC1411_Controll_0/sInitDone_n]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_CLKIN [get_bd_ports DAC_CLKIN_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_Clkin]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_CLKIO [get_bd_ports DAC_CLKIO_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_ClkIO]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_CS [get_bd_ports DAC_CS_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_CS]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_DATA [get_bd_ports DAC_DATA_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_Data]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_EN [get_bd_ports DAC_EN_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_EnOut]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_RESET [get_bd_ports DAC_RESET_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_Reset]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_SCLK [get_bd_ports DAC_SCLK_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SCLK]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_SET_FS1 [get_bd_ports DAC_SET_FS1_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SetFS1]
  connect_bd_net -net ZmodDAC1411_Controll_0_DAC_SET_FS2 [get_bd_ports DAC_SET_FS2_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SetFS2]
  connect_bd_net -net clk_in1_0_1 [get_bd_ports clk_in1_0] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins ZmodADC1410_Controll_0/ADC_InClk] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins ZmodDAC1411_Controll_0/DacClk] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins Filter_Top_Level_0/sysRst_n] [get_bd_pins ZmodADC1410_Controll_0/sRst_n] [get_bd_pins ZmodDAC1411_Controll_0/sRst_n] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins Filter_Top_Level_0/SysClk] [get_bd_pins ZmodADC1410_Controll_0/SysClk] [get_bd_pins ZmodDAC1411_Controll_0/SysClk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net reset_rtl_0_0_1 [get_bd_ports reset_rtl_0_0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins clk_wiz_0/reset] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins ZmodADC1410_Controll_0/sCh1GainConfig] [get_bd_pins ZmodADC1410_Controll_0/sCh2GainConfig] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_EnIn] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins ZmodADC1410_Controll_0/sCh1CouplingConfig] [get_bd_pins ZmodADC1410_Controll_0/sCh2CouplingConfig] [get_bd_pins ZmodADC1410_Controll_0/sTestMode] [get_bd_pins ZmodDAC1411_Controll_0/sExtCh1Scale] [get_bd_pins ZmodDAC1411_Controll_0/sExtCh2Scale] [get_bd_pins xlconstant_3/dout]

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


