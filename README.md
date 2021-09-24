# Eclypse Z7 Zmod ADC 1410 + Zmod DAC 1411 Low Level Demo

Important note: This demo branch is obsolete and has been replaced by lowlevel_lpf/master, which supports more variants of the Zmod Scope.

## Description

This is a branch of the Eclypse Z7 board containing the Vivado project with the Zmod ADC 1410 connected to ZMOD A connector on the board and the Zmod DAC 1411 to ZMOD B. The project is a basic exmple of a signal processing system. An analog input connected to the Zmod ADC 1410 CH1 input is converted to a digital format and passed to a digital low pass filter. The filter's output is converted back to an analog format by the Zmod DAC 1411 and can be measured on CH1. The input signal, after the analog to digital conversion, is also looped back to the Zmod DAC 1411 and connected to CH2 output. The project only uses the Zynq's Programmable Logic (PL). A more elaborate description of the project can be found here [Eclypse Z7 Low Level Zmod ADC DAC Demo](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/low_level_zmod_adc_dac)   
For more information on how our git and project flow is set up please refer to [Eclypse Z7 Git Repositories](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/git)

## First and foremost

* The Vivado projects are version-specific. Source files are not backward compatible and not automatically forward compatible. Release tags specify the targetted Vivado version. There is only one version targetted per year, as chosen by Digilent. Non-tagged commits on the master branch are either at the last tagged version or the next targeted version. This is not ideal and might be changed in the future adopting a better flow.
* Our projects use submodules to bring in libraries. Use --recursive when cloning or `git submodule init` and `git submodule update`, if cloned already non-recursively.

For more information on how this project is version controlled, see the README of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

## Requirements

* **Eclypse Z7**
* **Zmod ADC 1410**
* **Zmod DAC 1411**
* **Analog Discovery 2**
* **Discovery BNC Adapter**
* **Vivado 2019.1 Installation**: To set up Vivado, see the [Installing Vivado and Digilent Board Files Tutorial](https://reference.digilentinc.com/vivado/installing-vivado/start).

## Setup

In order to recreate the Vivado project make sure you follow the instructions provided in the README of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

## Next Steps

This demo can be used as a basis for other projects by modifying the hardware platform in the Vivado project's block design. 

## Additional Notes

For more information on the Eclypse Z7, visit its [Eclypse Z7 Resource Center](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/start) on the Digilent Wiki.

For more information on the Zmod ADC 1410, please visit us here [Zmod ADC Resource Center](https://reference.digilentinc.com/reference/zmod/zmodadc/start) on the Digilent Wiki.

For more information on the Zmod DAC 1411, please visit us here [Zmod DAC Resource Center](https://reference.digilentinc.com/reference/zmod/zmoddac/start) on the Digilent Wiki.

For more information on how our git and project flow is set up please refer to [Eclypse Z7 Git Repositories](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/git).

For more information on how this project is version controlled, refer to the [digilent-vivado-scripts repo](https://github.com/digilent/digilent-vivado-scripts).

For technical support or questions, please post on the [Digilent Forum](forum.digilentinc.com).
