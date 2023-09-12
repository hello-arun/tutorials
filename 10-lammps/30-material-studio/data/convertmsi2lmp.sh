#~/bin/bash
# msi2lmp="/home/jangira/Downloads/interface_ff_1_5/INTERFACE_FF_1_5/UTILITY_PROGRAMS/msi2lmp_gcc32.exe"
msi2lmp="${HOME}/Documents/applications/lammps/lammps-5Jun2019-kim/build/msi2lmp"
refFile="/home/jangira/Downloads/interface_ff_1_5/INTERFACE_FF_1_5/UTILITY_PROGRAMS/pcff_interface.frc"
${msi2lmp} alkane-4x4 -class II -frc ${refFile} -i