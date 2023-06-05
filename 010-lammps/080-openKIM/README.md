# Open Knowledgebase of Interatomic Models

is a curated repository of interatomic potentials and analytics for making classical molecular simulations of materials reliable, reproducible, and accessible.

## How to start from scratch

### Step1: Build Lammps

First of all build lammps with support of openKIM. You do not need to download OpenKIM separately lammps can automatically download and configure it when you provide appropriate instrcution in cmake. An example script to build lammps with OpenKIM is available [here](./install-lammps-openKIM.sh).

Keep in mind that the OpenKIM will also be build inside build directory of lammps. Some necessary executables for OpenKIM e.g. can be found in `${LMP_BUILD_DIR}/kim_build-prefix/bin`. In step 2 it will become more clear.

### Step2: Install Force Field Model

Suppose we want to use `SW_StillingerWeber_1985_Si__MO_405512056662_006` force field model in our calculation. First we need to activate the kim-api and then install this model. the steps are as follows
```bash
# LMP_BUILD_DIR is the directory where you have build lammps with cmake
cd ${LMP_BUILD_DIR}/kim_build-prefix/bin
# Here you will find three files
#   kim-api-activate  
#   kim-api-collections-management  
#   kim-api-deactivate

# Activate the kim-api
source ./kim-api-activate
./kim-api-collections-management install user SW_StillingerWeber_1985_Si__MO_405512056662_006
```

### Step3: Actual Simulation
Now you can directly use this force field in your simulation. You just need to e.g. use these tags inside lammps input script

```bash
units metal
kim init SW_StillingerWeber_1985_Si__MO_405512056662_006 metal
# Define atom-type-to-species-mapping
kim_interactions Si
```