# Eclypse Z7 Out-of-Box Vivado Project

## Description

This is a branch of the Eclypse Z7 board containing the Vivado project that is programmed into the Eclypse Z7's SPI flash during manufacturing. The project is configured to work with the PS (processing system) and several GPIO peripherals in order to cycle the RGB LEDs and to report button states to the user over a serial connection. The exported handoff from this project is used in the Eclypse Z7's Software repository's project within the branch of the same name.
For more information on how our git and project flow is set up please refer to [Eclypse Z7 Git Repositoies](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/git)

**Note**: *The Out-of-Box Project does not *

## First and Foremost

* The Vivado projects are version-specific. Source files are not backward compatible and not automatically forward compatible. Release tags specify the targeted Vivado version. There is only one version targeted per year, as chosen by Digilent. Non-tagged commits on the master branch are either at the last tagged version or the next targeted version. This is not ideal and might be changed in the future adopting a better flow.
* Our projects use submodules to bring in libraries. Use --recursive when cloning or `git submodule init` and `git submodule update`, if cloned already non-recursively.

For more information on how this project is version controlled, see the README of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

## Requirements

* **Eclypse Z7**
* **Vivado 2019.1 Installation with Xilinx SDK**: To set up Vivado, see the [Installing Vivado and Digilent Board Files Tutorial](https://reference.digilentinc.com/vivado/installing-vivado/start).

## Setup

In order to recreate the Vivado project make sure you follow the instructions provided in the README of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

## Next Steps

This demo can be used as a basis for other projects by modifying the hardware platform in the Vivado project's block design. This is strongly linked to the **Software projects** on the same branch name. Changing the Vivado project requires an hardware export in the hw_handoff folder from where it should be imported in to the [Software repository](https://github.com/Digilent/Eclypse-Z7-SW/tree/zmod_adc/master).

## Additional Notes

This repository contains Vivado projects for each demo for the Eclypse Z7, version controlled on their own branches. Non-Vivado sources for Eclypse Z7 demos can be found through this repo's parent repository, [Eclypse Z7](https://github.com/Digilent/Eclypse-Z7).

Since this repository uses submodules, when cloning the repo or switching between branches, make sure to call `git submodule init` and `git submodule update` to ensure that they are properly initialized.

For more information on how this project is version controlled, see the README of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

For more information on the Eclypse Z7, visit it's [Resource Center](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/start) on the Digilent Wiki.