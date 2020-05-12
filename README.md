# Eclypse Z7 ZmodADC1410 and ZmodDAC1411 Vivado Projects

## Description

This is a branch of the Eclypse Z7 board containing the Vivado projects with the ZmodADC1410 set in Zmod connector A and the ZmodDAC1411 set in to connector B. The project is configured to work with the PS (processing system) and to transmit the acquired data over the Axi-Stream interface using the AXI DMAs. The exported handoff from this project is used in the OS projects with the same branch name of the Eclypse Z7.
For more information on how our git and project flow is set up please refer to [Eclypse Z7 Git Repositoies](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/git)

## First and foremost

* The Vivado projects are version-specific. Source files are not backward compatible and not automatically forward compatible. Release tags specify the targetted Vivado version. There is only one version targetted per year, as chosen by Digilent. Non-tagged commits on the master branch are either at the last tagged version or the next targeted version. This is not ideal and might be changed in the future adopting a better flow.
* Our projects use submodules to bring in libraries. Use --recursive when cloning or `git submodule init` and `git submodule update`, if cloned already non-recursively.

For more information on how this project is version controlled, see the README.md file of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

## Requirements

* **Eclypse Z7**
* **ZmodADC1410**
* **ZmodDAC1411**
* **Vivado 2019.1 Installation with Xilinx SDK**: To set up Vivado, see the [Installing Vivado and Digilent Board Files Tutorial](https://reference.digilentinc.com/vivado/installing-vivado/start).

## Setup

In order to recreate the Vivado project make sure you follow the instructions provided in the README file of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

## Next Steps

This demo can be used as a basis for other projects by modifying the hardware platform in the Vivado project's block design. This is strongly linked to the **the OS projects** on the same branch name. Changing the Vivado project requires a hardware export in the hw_handoff folder from where it should be imported into the [[OS repository](https://github.com/Digilent/Eclypse-Z7-OS/tree/zmod_adc_dac/master).

## Additional Notes

For more information on the Eclypse Z7, visit its [Eclypse Z7 Resource Center](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/start) on the Digilent Wiki.

For more information on the ZmodADC1410, please visit us here [Zmod ADC Resource Center](https://reference.digilentinc.com/reference/zmod/zmodadc/start) on the Digilent Wiki.

For more information on the ZmodDAC1411, please visit us here [Zmod DAC Resource Center](https://reference.digilentinc.com/reference/zmod/zmoddac/start) on the Digilent Wiki.

For more information on how our git and porject flow is set up please refer to [Eclypse Z7 Git Repositoies](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/git).

For more information on how this project is version controlled, refer to the [digilent-vivado-scripts repo](https://github.com/digilent/digilent-vivado-scripts).

For technical support or questions, please post on the [Digilent Forum](forum.digilentinc.com).
