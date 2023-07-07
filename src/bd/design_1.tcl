
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
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

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
   set_property BOARD_PART digilentinc.com:eclypse-z7:part0:1.0 [current_project]
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
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

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

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
natinst.com:user:AXI_ZmodADC1410:1.0\
xilinx.com:user:ZmodADC1410_Controller:1.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:xlslice:1.0\
natinst.com:user:AXI_ZmodDAC1411_v1_0:1.0\
natinst.com:user:ZmodDAC1411_Controller:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: ZmodDAC_0
proc create_hier_cell_ZmodDAC_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ZmodDAC_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AxiLite

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir O -type clk DAC_CLKIN_0
  create_bd_pin -dir O -type clk DAC_CLKIO_0
  create_bd_pin -dir O DAC_CS_0
  create_bd_pin -dir O -from 13 -to 0 DAC_DATA_0
  create_bd_pin -dir O DAC_EN_0
  create_bd_pin -dir O -type rst DAC_RESET_0
  create_bd_pin -dir O DAC_SCLK_0
  create_bd_pin -dir IO DAC_SDIO_0
  create_bd_pin -dir O DAC_SET_FS1_0
  create_bd_pin -dir O DAC_SET_FS2_0
  create_bd_pin -dir I DacClk
  create_bd_pin -dir I SysClk
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk m_axi_mm2s_aclk
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: AXI_ZmodDAC1411_v1_0_0, and set properties
  set AXI_ZmodDAC1411_v1_0_0 [ create_bd_cell -type ip -vlnv natinst.com:user:AXI_ZmodDAC1411_v1_0:1.0 AXI_ZmodDAC1411_v1_0_0 ]

  # Create instance: ZmodDAC1411_Controll_0, and set properties
  set ZmodDAC1411_Controll_0 [ create_bd_cell -type ip -vlnv natinst.com:user:ZmodDAC1411_Controller:1.0 ZmodDAC1411_Controll_0 ]
  set_property -dict [ list \
   CONFIG.kExtCalibEn {true} \
   CONFIG.kExtCmdInterfaceEn {true} \
   CONFIG.kExtScaleConfigEn {true} \
 ] $ZmodDAC1411_Controll_0

  # Create instance: axi_dma_1, and set properties
  set axi_dma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_1 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {16} \
 ] $axi_dma_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_ZmodDAC1411_v1_0_0_mCalibCh1 [get_bd_intf_pins AXI_ZmodDAC1411_v1_0_0/mCalibCh1] [get_bd_intf_pins ZmodDAC1411_Controll_0/sCalibCh1]
  connect_bd_intf_net -intf_net AXI_ZmodDAC1411_v1_0_0_mCalibCh2 [get_bd_intf_pins AXI_ZmodDAC1411_v1_0_0/mCalibCh2] [get_bd_intf_pins ZmodDAC1411_Controll_0/sCalibCh2]
  connect_bd_intf_net -intf_net AXI_ZmodDAC1411_v1_0_0_mSPI_IAP [get_bd_intf_pins AXI_ZmodDAC1411_v1_0_0/mSPI_IAP] [get_bd_intf_pins ZmodDAC1411_Controll_0/sSPI_IAP]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins AXI_ZmodDAC1411_v1_0_0/s_axis_mm2s] [get_bd_intf_pins axi_dma_1/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_dma_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins AxiLite] [get_bd_intf_pins AXI_ZmodDAC1411_v1_0_0/AxiLite]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_1/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net AXI_ZmodDAC1411_v1_0_0_sCh1Out [get_bd_pins AXI_ZmodDAC1411_v1_0_0/sCh1Out] [get_bd_pins ZmodDAC1411_Controll_0/sCh1In]
  connect_bd_net -net AXI_ZmodDAC1411_v1_0_0_sCh1ScaleSelect [get_bd_pins AXI_ZmodDAC1411_v1_0_0/sCh1ScaleSelect] [get_bd_pins ZmodDAC1411_Controll_0/sExtCh1Scale]
  connect_bd_net -net AXI_ZmodDAC1411_v1_0_0_sCh2Out [get_bd_pins AXI_ZmodDAC1411_v1_0_0/sCh2Out] [get_bd_pins ZmodDAC1411_Controll_0/sCh2In]
  connect_bd_net -net AXI_ZmodDAC1411_v1_0_0_sCh2ScaleSelect [get_bd_pins AXI_ZmodDAC1411_v1_0_0/sCh2ScaleSelect] [get_bd_pins ZmodDAC1411_Controll_0/sExtCh2Scale]
  connect_bd_net -net AXI_ZmodDAC1411_v1_0_0_sDacEnOut [get_bd_pins AXI_ZmodDAC1411_v1_0_0/sDacEnOut] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_EnIn]
  connect_bd_net -net AXI_ZmodDAC1411_v1_0_0_sZmodControllerRst_n [get_bd_pins AXI_ZmodDAC1411_v1_0_0/sZmodControllerRst_n] [get_bd_pins ZmodDAC1411_Controll_0/sRst_n]
  connect_bd_net -net Net1 [get_bd_pins DAC_SDIO_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SDIO]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins axi_resetn] [get_bd_pins AXI_ZmodDAC1411_v1_0_0/lRst_n] [get_bd_pins axi_dma_1/axi_resetn]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_CS [get_bd_pins DAC_CS_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_CS]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_ClkIO [get_bd_pins DAC_CLKIO_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_ClkIO]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_Clkin [get_bd_pins DAC_CLKIN_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_Clkin]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_Data [get_bd_pins DAC_DATA_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_Data]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_EnOut [get_bd_pins DAC_EN_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_EnOut]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_Reset [get_bd_pins DAC_RESET_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_Reset]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_SCLK [get_bd_pins DAC_SCLK_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SCLK]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_SetFS1 [get_bd_pins DAC_SET_FS1_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SetFS1]
  connect_bd_net -net ZmodDAC1411_Controll_0_sDAC_SetFS2 [get_bd_pins DAC_SET_FS2_0] [get_bd_pins ZmodDAC1411_Controll_0/sDAC_SetFS2]
  connect_bd_net -net ZmodDAC1411_Controll_0_sInitDone_n [get_bd_pins AXI_ZmodDAC1411_v1_0_0/sInitDone_n] [get_bd_pins ZmodDAC1411_Controll_0/sInitDone_n]
  connect_bd_net -net axi_dma_1_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_dma_1/mm2s_introut]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins m_axi_mm2s_aclk] [get_bd_pins AXI_ZmodDAC1411_v1_0_0/AxiStreamClk] [get_bd_pins axi_dma_1/m_axi_mm2s_aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins s_axi_lite_aclk] [get_bd_pins AXI_ZmodDAC1411_v1_0_0/s00_axi_aclk] [get_bd_pins axi_dma_1/s_axi_lite_aclk]
  connect_bd_net -net clk_wiz_0_clk_out5 [get_bd_pins DacClk] [get_bd_pins ZmodDAC1411_Controll_0/DacClk]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins SysClk] [get_bd_pins AXI_ZmodDAC1411_v1_0_0/SysClk] [get_bd_pins ZmodDAC1411_Controll_0/SysClk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ZmodADC_0
proc create_hier_cell_ZmodADC_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ZmodADC_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -from 13 -to 0 ADC_DATA_0
  create_bd_pin -dir I ADC_DCO_0
  create_bd_pin -dir I -type clk ADC_InClk
  create_bd_pin -dir O ADC_SYNC_0
  create_bd_pin -dir I -type clk AxiStreamClk
  create_bd_pin -dir O CLKIN_ADC_N_0
  create_bd_pin -dir O CLKIN_ADC_P_0
  create_bd_pin -dir O SC1_AC_H_0
  create_bd_pin -dir O SC1_AC_L_0
  create_bd_pin -dir O SC1_GAIN_H_0
  create_bd_pin -dir O SC1_GAIN_L_0
  create_bd_pin -dir O SC2_AC_H_0
  create_bd_pin -dir O SC2_AC_L_0
  create_bd_pin -dir O SC2_GAIN_H_0
  create_bd_pin -dir O SC2_GAIN_L_0
  create_bd_pin -dir O SC_COM_H_0
  create_bd_pin -dir O SC_COM_L_0
  create_bd_pin -dir I -type clk SysClk
  create_bd_pin -dir O cs_sc1_0
  create_bd_pin -dir O -type intr lIrqOut
  create_bd_pin -dir I -type rst lRst_n
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir O sclk_sc_0
  create_bd_pin -dir IO sdio_sc_0

  # Create instance: AXI_ZmodADC1410_1, and set properties
  set AXI_ZmodADC1410_1 [ create_bd_cell -type ip -vlnv natinst.com:user:AXI_ZmodADC1410:1.0 AXI_ZmodADC1410_1 ]
  set_property -dict [ list \
   CONFIG.kCrossRegCnt {13} \
 ] $AXI_ZmodADC1410_1

  # Create instance: ZmodADC1410_Controll_1, and set properties
  set ZmodADC1410_Controll_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:ZmodADC1410_Controller:1.0 ZmodADC1410_Controll_1 ]
  set_property -dict [ list \
   CONFIG.kCh1HgMultCoefStatic {"000000000000000000"} \
   CONFIG.kCh1LgMultCoefStatic {"000000000000000000"} \
   CONFIG.kCh2HgMultCoefStatic {"000000000000000000"} \
   CONFIG.kCh2LgMultCoefStatic {"000000000000000000"} \
   CONFIG.kExtCmdInterfaceEn {true} \
   CONFIG.kExtRelayConfigEn {true} \
 ] $ZmodADC1410_Controll_1

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {16} \
 ] $axi_dma_0

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {8} \
 ] $ila_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_AXI_S2MM [get_bd_intf_pins AXI_ZmodADC1410_1/AXI_S2MM] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_mCalibCh1 [get_bd_intf_pins AXI_ZmodADC1410_1/mCalibCh1] [get_bd_intf_pins ZmodADC1410_Controll_1/sCalibCh1]
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_mCalibCh2 [get_bd_intf_pins AXI_ZmodADC1410_1/mCalibCh2] [get_bd_intf_pins ZmodADC1410_Controll_1/sCalibCh2]
  connect_bd_intf_net -intf_net AXI_ZmodADC1410_1_mSPI [get_bd_intf_pins AXI_ZmodADC1410_1/mSPI_IAP] [get_bd_intf_pins ZmodADC1410_Controll_1/sSPI_IAP]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_dma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI_ZmodADC1410_1/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net ADC_DATA_0_1 [get_bd_pins ADC_DATA_0] [get_bd_pins ZmodADC1410_Controll_1/dADC_Data]
  connect_bd_net -net ADC_DCO_0_1 [get_bd_pins ADC_DCO_0] [get_bd_pins ZmodADC1410_Controll_1/DcoClk]
  connect_bd_net -net AXI_ZmodADC1410_1_lIrqOut [get_bd_pins lIrqOut] [get_bd_pins AXI_ZmodADC1410_1/lIrqOut]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh1CouplingSelect [get_bd_pins AXI_ZmodADC1410_1/sCh1CouplingSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh1CouplingConfig]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh1GainSelect [get_bd_pins AXI_ZmodADC1410_1/sCh1GainSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh1GainConfig] [get_bd_pins ila_0/probe5]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh2CouplingSelect [get_bd_pins AXI_ZmodADC1410_1/sCh2CouplingSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh2CouplingConfig]
  connect_bd_net -net AXI_ZmodADC1410_1_sCh2GainSelect [get_bd_pins AXI_ZmodADC1410_1/sCh2GainSelect] [get_bd_pins ZmodADC1410_Controll_1/sCh2GainConfig] [get_bd_pins ila_0/probe6]
  connect_bd_net -net AXI_ZmodADC1410_1_sTestMode [get_bd_pins AXI_ZmodADC1410_1/sTestMode] [get_bd_pins ZmodADC1410_Controll_1/sTestMode] [get_bd_pins ila_0/probe7]
  connect_bd_net -net AXI_ZmodADC1410_1_sZmodControllerRst_n [get_bd_pins AXI_ZmodADC1410_1/sZmodControllerRst_n] [get_bd_pins ZmodADC1410_Controll_1/sRst_n]
  connect_bd_net -net Net [get_bd_pins sdio_sc_0] [get_bd_pins ZmodADC1410_Controll_1/sADC_SDIO]
  connect_bd_net -net ZmodADC1410_Controll_0_CALIB_DONE_N [get_bd_pins AXI_ZmodADC1410_1/sInitDone_n] [get_bd_pins ZmodADC1410_Controll_1/sInitDone_n] [get_bd_pins ila_0/probe4]
  connect_bd_net -net ZmodADC1410_Controll_1_FIFO_EMPTY_CHA [get_bd_pins ZmodADC1410_Controll_1/FIFO_EMPTY_CHA] [get_bd_pins ila_0/probe0]
  connect_bd_net -net ZmodADC1410_Controll_1_FIFO_EMPTY_CHB [get_bd_pins ZmodADC1410_Controll_1/FIFO_EMPTY_CHB] [get_bd_pins ila_0/probe1]
  connect_bd_net -net ZmodADC1410_Controll_1_adcClkIn_n [get_bd_pins CLKIN_ADC_N_0] [get_bd_pins ZmodADC1410_Controll_1/adcClkIn_n]
  connect_bd_net -net ZmodADC1410_Controll_1_adcClkIn_p [get_bd_pins CLKIN_ADC_P_0] [get_bd_pins ZmodADC1410_Controll_1/adcClkIn_p]
  connect_bd_net -net ZmodADC1410_Controll_1_adcSync [get_bd_pins ADC_SYNC_0] [get_bd_pins ZmodADC1410_Controll_1/adcSync]
  connect_bd_net -net ZmodADC1410_Controll_1_sADC_CS [get_bd_pins cs_sc1_0] [get_bd_pins ZmodADC1410_Controll_1/sADC_CS]
  connect_bd_net -net ZmodADC1410_Controll_1_sADC_Sclk [get_bd_pins sclk_sc_0] [get_bd_pins ZmodADC1410_Controll_1/sADC_Sclk]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1CouplingH [get_bd_pins SC1_AC_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1CouplingH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1CouplingL [get_bd_pins SC1_AC_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1CouplingL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1GainH [get_bd_pins SC1_GAIN_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1GainH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1GainL [get_bd_pins SC1_GAIN_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh1GainL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh1Out [get_bd_pins ZmodADC1410_Controll_1/sCh1Out] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2CouplingH [get_bd_pins SC2_AC_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2CouplingH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2CouplingL [get_bd_pins SC2_AC_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2CouplingL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2GainH [get_bd_pins SC2_GAIN_H_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2GainH]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2GainL [get_bd_pins SC2_GAIN_L_0] [get_bd_pins ZmodADC1410_Controll_1/sCh2GainL]
  connect_bd_net -net ZmodADC1410_Controll_1_sCh2Out [get_bd_pins ZmodADC1410_Controll_1/sCh2Out] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net ZmodADC1410_Controll_1_sRelayComH [get_bd_pins SC_COM_H_0] [get_bd_pins ZmodADC1410_Controll_1/sRelayComH]
  connect_bd_net -net ZmodADC1410_Controll_1_sRelayComL [get_bd_pins SC_COM_L_0] [get_bd_pins ZmodADC1410_Controll_1/sRelayComL]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_0/s2mm_introut]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins AxiStreamClk] [get_bd_pins AXI_ZmodADC1410_1/AxiStreamClk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins s00_axi_aclk] [get_bd_pins AXI_ZmodADC1410_1/s00_axi_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins ADC_InClk] [get_bd_pins ZmodADC1410_Controll_1/ADC_InClk]
  connect_bd_net -net lRst_n_1 [get_bd_pins lRst_n] [get_bd_pins AXI_ZmodADC1410_1/lRst_n] [get_bd_pins axi_dma_0/axi_resetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins SysClk] [get_bd_pins AXI_ZmodADC1410_1/SysClk] [get_bd_pins ZmodADC1410_Controll_1/SysClk] [get_bd_pins ila_0/clk]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins AXI_ZmodADC1410_1/sCh1In] [get_bd_pins ila_0/probe2] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins AXI_ZmodADC1410_1/sCh2In] [get_bd_pins ila_0/probe3] [get_bd_pins xlslice_1/Dout]

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
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  set ZmodADC_0_ADC_DATA_0 [ create_bd_port -dir I -from 13 -to 0 ZmodADC_0_ADC_DATA_0 ]
  set ZmodADC_0_ADC_DCO_0 [ create_bd_port -dir I ZmodADC_0_ADC_DCO_0 ]
  set ZmodADC_0_ADC_SYNC_0 [ create_bd_port -dir O ZmodADC_0_ADC_SYNC_0 ]
  set ZmodADC_0_CLKIN_ADC_N_0 [ create_bd_port -dir O ZmodADC_0_CLKIN_ADC_N_0 ]
  set ZmodADC_0_CLKIN_ADC_P_0 [ create_bd_port -dir O ZmodADC_0_CLKIN_ADC_P_0 ]
  set ZmodADC_0_SC1_AC_H_0 [ create_bd_port -dir O ZmodADC_0_SC1_AC_H_0 ]
  set ZmodADC_0_SC1_AC_L_0 [ create_bd_port -dir O ZmodADC_0_SC1_AC_L_0 ]
  set ZmodADC_0_SC1_GAIN_H_0 [ create_bd_port -dir O ZmodADC_0_SC1_GAIN_H_0 ]
  set ZmodADC_0_SC1_GAIN_L_0 [ create_bd_port -dir O ZmodADC_0_SC1_GAIN_L_0 ]
  set ZmodADC_0_SC2_AC_H_0 [ create_bd_port -dir O ZmodADC_0_SC2_AC_H_0 ]
  set ZmodADC_0_SC2_AC_L_0 [ create_bd_port -dir O ZmodADC_0_SC2_AC_L_0 ]
  set ZmodADC_0_SC2_GAIN_H_0 [ create_bd_port -dir O ZmodADC_0_SC2_GAIN_H_0 ]
  set ZmodADC_0_SC2_GAIN_L_0 [ create_bd_port -dir O ZmodADC_0_SC2_GAIN_L_0 ]
  set ZmodADC_0_SC_COM_H_0 [ create_bd_port -dir O ZmodADC_0_SC_COM_H_0 ]
  set ZmodADC_0_SC_COM_L_0 [ create_bd_port -dir O ZmodADC_0_SC_COM_L_0 ]
  set ZmodADC_0_cs_sc1_0 [ create_bd_port -dir O ZmodADC_0_cs_sc1_0 ]
  set ZmodADC_0_sclk_sc_0 [ create_bd_port -dir O ZmodADC_0_sclk_sc_0 ]
  set ZmodADC_0_sdio_sc_0 [ create_bd_port -dir IO ZmodADC_0_sdio_sc_0 ]
  set ZmodDAC_0_DAC_CLKIN_0 [ create_bd_port -dir O -type clk ZmodDAC_0_DAC_CLKIN_0 ]
  set ZmodDAC_0_DAC_CLKIO_0 [ create_bd_port -dir O -type clk ZmodDAC_0_DAC_CLKIO_0 ]
  set ZmodDAC_0_DAC_CS_0 [ create_bd_port -dir O ZmodDAC_0_DAC_CS_0 ]
  set ZmodDAC_0_DAC_DATA_0 [ create_bd_port -dir O -from 13 -to 0 ZmodDAC_0_DAC_DATA_0 ]
  set ZmodDAC_0_DAC_EN_0 [ create_bd_port -dir O ZmodDAC_0_DAC_EN_0 ]
  set ZmodDAC_0_DAC_RESET_0 [ create_bd_port -dir O -type rst ZmodDAC_0_DAC_RESET_0 ]
  set ZmodDAC_0_DAC_SCLK_0 [ create_bd_port -dir O ZmodDAC_0_DAC_SCLK_0 ]
  set ZmodDAC_0_DAC_SDIO_0 [ create_bd_port -dir IO ZmodDAC_0_DAC_SDIO_0 ]
  set ZmodDAC_0_DAC_SET_FS1_0 [ create_bd_port -dir O ZmodDAC_0_DAC_SET_FS1_0 ]
  set ZmodDAC_0_DAC_SET_FS2_0 [ create_bd_port -dir O ZmodDAC_0_DAC_SET_FS2_0 ]
  set reset_rtl_0_0 [ create_bd_port -dir I -type rst reset_rtl_0_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl_0_0

  # Create instance: ZmodADC_0
  create_hier_cell_ZmodADC_0 [current_bd_instance .] ZmodADC_0

  # Create instance: ZmodDAC_0
  create_hier_cell_ZmodDAC_0 [current_bd_instance .] ZmodDAC_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {144.719} \
   CONFIG.CLKOUT1_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_JITTER {167.017} \
   CONFIG.CLKOUT2_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {144.719} \
   CONFIG.CLKOUT3_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_JITTER {111.164} \
   CONFIG.CLKOUT4_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {400.000} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLKOUT5_JITTER {144.719} \
   CONFIG.CLKOUT5_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT5_REQUESTED_PHASE {90.000} \
   CONFIG.CLKOUT5_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {16} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {8} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {2} \
   CONFIG.MMCM_CLKOUT4_DIVIDE {8} \
   CONFIG.MMCM_CLKOUT4_PHASE {90.000} \
   CONFIG.NUM_OUT_CLKS {5} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wiz_0

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
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
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {10000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
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
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
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
   CONFIG.PCW_IRQ_F2P_INTR {1} \
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
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#Quad SPI Flash#ENET Reset#GPIO#GPIO#I2C 1#I2C 1#UART 0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#USB Reset#SD 0#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#gpio[7]#qspi_fbclk#reset#gpio[10]#gpio[11]#scl#sda#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#reset#cd#gpio[48]#gpio[49]#gpio[50]#gpio[51]#mdc#mdio} \
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
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $ps7_0_axi_periph

  # Create instance: rst_clk_wiz_0_50M, and set properties
  set rst_clk_wiz_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_50M ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $smartconnect_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net ZmodADC_0_M_AXI_S2MM [get_bd_intf_pins ZmodADC_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net ZmodDAC_0_M_AXI_MM2S [get_bd_intf_pins ZmodDAC_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins ZmodADC_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins ZmodADC_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins ZmodDAC_0/AxiLite] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins ZmodDAC_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins smartconnect_0/M00_AXI]

  # Create port connections
  connect_bd_net -net ADC_InClk_1 [get_bd_pins ZmodADC_0/ADC_InClk] [get_bd_pins clk_wiz_0/clk_out4]
  connect_bd_net -net DacClk_1 [get_bd_pins ZmodDAC_0/DacClk] [get_bd_pins clk_wiz_0/clk_out5]
  connect_bd_net -net Net [get_bd_ports ZmodADC_0_sdio_sc_0] [get_bd_pins ZmodADC_0/sdio_sc_0]
  connect_bd_net -net Net1 [get_bd_ports ZmodDAC_0_DAC_SDIO_0] [get_bd_pins ZmodDAC_0/DAC_SDIO_0]
  connect_bd_net -net SysClk_1 [get_bd_pins ZmodADC_0/SysClk] [get_bd_pins ZmodDAC_0/SysClk] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net ZmodADC_0_ADC_DATA_0_1 [get_bd_ports ZmodADC_0_ADC_DATA_0] [get_bd_pins ZmodADC_0/ADC_DATA_0]
  connect_bd_net -net ZmodADC_0_ADC_DCO_0_1 [get_bd_ports ZmodADC_0_ADC_DCO_0] [get_bd_pins ZmodADC_0/ADC_DCO_0]
  connect_bd_net -net ZmodADC_0_ADC_SYNC_1 [get_bd_ports ZmodADC_0_ADC_SYNC_0] [get_bd_pins ZmodADC_0/ADC_SYNC_0]
  connect_bd_net -net ZmodADC_0_CLKIN_ADC_N_1 [get_bd_ports ZmodADC_0_CLKIN_ADC_N_0] [get_bd_pins ZmodADC_0/CLKIN_ADC_N_0]
  connect_bd_net -net ZmodADC_0_CLKIN_ADC_P_1 [get_bd_ports ZmodADC_0_CLKIN_ADC_P_0] [get_bd_pins ZmodADC_0/CLKIN_ADC_P_0]
  connect_bd_net -net ZmodADC_0_SC1_AC_H_1 [get_bd_ports ZmodADC_0_SC1_AC_H_0] [get_bd_pins ZmodADC_0/SC1_AC_H_0]
  connect_bd_net -net ZmodADC_0_SC1_AC_L_1 [get_bd_ports ZmodADC_0_SC1_AC_L_0] [get_bd_pins ZmodADC_0/SC1_AC_L_0]
  connect_bd_net -net ZmodADC_0_SC1_GAIN_H_1 [get_bd_ports ZmodADC_0_SC1_GAIN_H_0] [get_bd_pins ZmodADC_0/SC1_GAIN_H_0]
  connect_bd_net -net ZmodADC_0_SC1_GAIN_L_1 [get_bd_ports ZmodADC_0_SC1_GAIN_L_0] [get_bd_pins ZmodADC_0/SC1_GAIN_L_0]
  connect_bd_net -net ZmodADC_0_SC2_AC_H_1 [get_bd_ports ZmodADC_0_SC2_AC_H_0] [get_bd_pins ZmodADC_0/SC2_AC_H_0]
  connect_bd_net -net ZmodADC_0_SC2_AC_L_1 [get_bd_ports ZmodADC_0_SC2_AC_L_0] [get_bd_pins ZmodADC_0/SC2_AC_L_0]
  connect_bd_net -net ZmodADC_0_SC2_GAIN_H_1 [get_bd_ports ZmodADC_0_SC2_GAIN_H_0] [get_bd_pins ZmodADC_0/SC2_GAIN_H_0]
  connect_bd_net -net ZmodADC_0_SC2_GAIN_L_1 [get_bd_ports ZmodADC_0_SC2_GAIN_L_0] [get_bd_pins ZmodADC_0/SC2_GAIN_L_0]
  connect_bd_net -net ZmodADC_0_SC_COM_H_1 [get_bd_ports ZmodADC_0_SC_COM_H_0] [get_bd_pins ZmodADC_0/SC_COM_H_0]
  connect_bd_net -net ZmodADC_0_SC_COM_L_1 [get_bd_ports ZmodADC_0_SC_COM_L_0] [get_bd_pins ZmodADC_0/SC_COM_L_0]
  connect_bd_net -net ZmodADC_0_cs_sc1_1 [get_bd_ports ZmodADC_0_cs_sc1_0] [get_bd_pins ZmodADC_0/cs_sc1_0]
  connect_bd_net -net ZmodADC_0_lIrqOut [get_bd_pins ZmodADC_0/lIrqOut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net ZmodADC_0_s2mm_introut [get_bd_pins ZmodADC_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net ZmodADC_0_sclk_sc_1 [get_bd_ports ZmodADC_0_sclk_sc_0] [get_bd_pins ZmodADC_0/sclk_sc_0]
  connect_bd_net -net ZmodDAC_0_DAC_CLKIN_1 [get_bd_ports ZmodDAC_0_DAC_CLKIN_0] [get_bd_pins ZmodDAC_0/DAC_CLKIN_0]
  connect_bd_net -net ZmodDAC_0_DAC_CLKIO_1 [get_bd_ports ZmodDAC_0_DAC_CLKIO_0] [get_bd_pins ZmodDAC_0/DAC_CLKIO_0]
  connect_bd_net -net ZmodDAC_0_DAC_CS_1 [get_bd_ports ZmodDAC_0_DAC_CS_0] [get_bd_pins ZmodDAC_0/DAC_CS_0]
  connect_bd_net -net ZmodDAC_0_DAC_DATA_1 [get_bd_ports ZmodDAC_0_DAC_DATA_0] [get_bd_pins ZmodDAC_0/DAC_DATA_0]
  connect_bd_net -net ZmodDAC_0_DAC_EN_1 [get_bd_ports ZmodDAC_0_DAC_EN_0] [get_bd_pins ZmodDAC_0/DAC_EN_0]
  connect_bd_net -net ZmodDAC_0_DAC_RESET_1 [get_bd_ports ZmodDAC_0_DAC_RESET_0] [get_bd_pins ZmodDAC_0/DAC_RESET_0]
  connect_bd_net -net ZmodDAC_0_DAC_SCLK_1 [get_bd_ports ZmodDAC_0_DAC_SCLK_0] [get_bd_pins ZmodDAC_0/DAC_SCLK_0]
  connect_bd_net -net ZmodDAC_0_DAC_SET_FS1_1 [get_bd_ports ZmodDAC_0_DAC_SET_FS1_0] [get_bd_pins ZmodDAC_0/DAC_SET_FS1_0]
  connect_bd_net -net ZmodDAC_0_DAC_SET_FS2_1 [get_bd_ports ZmodDAC_0_DAC_SET_FS2_0] [get_bd_pins ZmodDAC_0/DAC_SET_FS2_0]
  connect_bd_net -net ZmodDAC_0_mm2s_introut [get_bd_pins ZmodDAC_0/mm2s_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins ZmodADC_0/AxiStreamClk] [get_bd_pins ZmodDAC_0/m_axi_mm2s_aclk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins ZmodADC_0/s00_axi_aclk] [get_bd_pins ZmodDAC_0/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_0_50M/slowest_sync_clk]
  connect_bd_net -net ext_reset_in_0_1 [get_bd_ports reset_rtl_0_0] [get_bd_pins rst_clk_wiz_0_50M/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0]
  connect_bd_net -net rst_clk_wiz_0_50M_interconnect_aresetn [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_0_50M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_0_50M_peripheral_aresetn [get_bd_pins ZmodADC_0/lRst_n] [get_bd_pins ZmodDAC_0/axi_resetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_0_50M/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins clk_wiz_0/resetn] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins rst_clk_wiz_0_50M/dcm_locked] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ZmodADC_0/AXI_ZmodADC1410_1/S00_AXI/S00_AXI_reg] SEG_AXI_ZmodADC1410_1_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ZmodDAC_0/AXI_ZmodDAC1411_v1_0_0/AxiLite/reg0] SEG_AXI_ZmodDAC1411_v1_0_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ZmodADC_0/axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40410000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ZmodDAC_0/axi_dma_1/S_AXI_LITE/Reg] SEG_axi_dma_1_Reg
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces ZmodADC_0/axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x00000000 [get_bd_addr_spaces ZmodDAC_0/axi_dma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM


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


