# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "kDecimFactor"

}

proc update_PARAM_VALUE.kDecimFactor { PARAM_VALUE.kDecimFactor } {
	# Procedure called to update kDecimFactor when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kDecimFactor { PARAM_VALUE.kDecimFactor } {
	# Procedure called to validate kDecimFactor
	return true
}


proc update_MODELPARAM_VALUE.kDecimFactor { MODELPARAM_VALUE.kDecimFactor PARAM_VALUE.kDecimFactor } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kDecimFactor}] ${MODELPARAM_VALUE.kDecimFactor}
}

