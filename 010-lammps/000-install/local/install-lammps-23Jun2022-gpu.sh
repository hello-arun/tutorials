#!/bin/bash -e

wd=${PWD}
srcDIR="${wd}/src"
package="lammps-23Jun2022"
installDIR="${wd}/${package}-gpu"
mkdir -p ${srcDIR} ${installDIR}
# check if file is not already downloaded then download
if [ ! -f ${srcDIR}/${package}.tar.gz ];
then
	echo "Downloading source tarball"
    cd $srcDIR
	wget https://download.lammps.org/tars/${package}.tar.gz
else
	echo "File already downloaded..Now installing..."
fi	

if [ -f ${srcDIR}/${package}.tar.gz ];
then
	cd ${installDIR} || exit 1
    tar -xzvf ${srcDIR}/${package}.tar.gz

    cd ${installDIR}/${package} || exit 1
    mkdir build 
    cd build || exit 1
    module purge
    module load cuda/11.5.0/gcc-7.5.0-syen6pj
    module load openmpi/4.1.1/gcc-7.5.0-fxaxwiu
    cmake \
    -D PKG_REAXFF=yes \
    -D PKG_MANYBODY=yes \
    -D PKG_REPLICA=yes \
    -D PKG_GPU=yes \
    -D GPU_API=cuda \
    -D GPU_ARCH=sm_52 ../cmake
    make -j 24

    echo -e "\n\n\n#################################\nInstalled...\n$(readlink -f ./lmp)\n#################################"
	# # Make build with reax package
	# cd ${wd}/${package}/src
	# make yes-REAXFF
	# make yes-MANYBODY
	# make yes-REPLICA
	# make mpi
	# echo "done!!!"
fi
