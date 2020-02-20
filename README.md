# Eclypse Z7 Base Vivado Project

This branch contains a Vivado project with the master XDC and a block diagram containing only a configured Zynq block. The vivado-library repository is included as a submodule.

This repository contains Vivado projects for each demo for the Eclypse Z7, version controlled on their own branches. Non-Vivado sources for Eclypse Z7 demos can be found through this repo's parent repository, [Eclypse Z7](https://github.com/Digilent/Eclypse-Z7).

# Navigating the Repository

Each /master branch of this repository contains the Vivado Project corresponding to a different demo. Many of these demos cannot be used without without the other submodules of the Eclypse-Z7 repository, linked above.
| Demo Branch            | Description                                                                              | Requires SW Repo |
|------------------------|------------------------------------------------------------------------------------------|------------------|
| master                 | Base Vivado Project containing a master XDC and preconfigured Zynq Block                 | Yes              |
| zmod_adc_dac/master    | Demo supporting the Zmod ADC on Zmod Port A and the Zmod DAC on Zmod Port B              | Yes              |
| zmod_adc/master        | Demo supporting only the Zmod ADC on Zmod Port A                                         | Yes              |
| zmod_dac/master        | Demo supporting only the Zmod DAC on Zmod Port B                                         | Yes              |
| low_level_zmod_adc_dac | Demo implementing an FIR filter with the Zmod ADC and DAC that uses only the PL          | No               |
| oob/master             | Out-of-Box Demo sources. Programmed into the Eclypse Z7's Flash at time of manufacturing | Yes              |

## Useful Commands

Demo sources can be obtained by cloning the Eclypse Z7 root repository, specifying a demo branch. For example:
- `git clone --recursive https://github.com/Digilent/Eclypse-Z7 -b <demo branch>`

**Note:** *Cloning only the -HW repo is not recommended, as it does not include the software and linux components necessary for most of the demos.*

All further commands described in this section assume that the user has first changed the working directory to the cloned hardware repository:
- `cd <path>/Eclypse-Z7-HW`

After cloning, the sources can be replaced by those of another demo, like so:
- `git checkout <demo branch>`

Since this repository uses submodules, when cloning the repo (without the `-b` flag) or switching between branches, make sure to initialize and update the submodules like so:
- `git submodule init`
- `git submodule update`

In order to obtain a usable Vivado project from the demo sources, Python 3 or the Vivado TCL Console should be used:
- Python: `python3 ./digilent-vivado-scripts/git_vivado.py checkout`
- TCL: `set argv ""; source ./digilent-vivado-scripts/digilent_vivado_checkout.tcl`

Regardless of which method was used, checking out the project results in the creation of a Vivado Project file (XPR) in the repo's `proj` directory. Running the TCL script automatically opens the project. Running the Python script requires the user to open the project in Vivado.

Once the project has been opened, changes can be made to the design, and the bitstream and hardware handoff file (HDF) can be regenerated as normal through the use of the *Generate Bitstream* button and the *File > Export > Export Hardware* option in the menu at the top of the window. The HDF can then be used to apply the changes to the OS and SW components of the demo.

# Additional Information

For more information on how this project is version controlled, see the README of the [Digilent Vivado Scripts](https://github.com/Digilent/digilent-vivado-scripts) repository.

For more information on the Eclypse Z7, visit it's [Resource Center](https://reference.digilentinc.com/reference/programmable-logic/eclypse-z7/start) on the Digilent Wiki.