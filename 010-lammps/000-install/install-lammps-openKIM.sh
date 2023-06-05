#!/bin/bash -e

# We install lammps 28Mar2023 with open KIM model
# So that we can use huge library of potentials in lammps  with ease

wd=${PWD}
srcDIR="${wd}/src"
package="lammps-28Mar2023"
installDIR="${wd}/${package}-kim"
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
    tar -xzvf ${srcDIR}/${package}.tar.gz --strip-components=1

    rm -rf build
    mkdir build 
    cd build || exit 1
    module purge
    module load openmpi/4.1.1/gcc-7.5.0-fxaxwiu
    cmake --version
    cmake \
    -D PKG_REAXFF=yes \
    -D PKG_MANYBODY=yes \
    -D PKG_REPLICA=yes \
    -D PKG_KIM=yes \
    -D DOWNLOAD_KIM=yes  \
    -D LMP_DEBUG_CURL=off \
    -D LMP_NO_SSL_CHECK=no \
    -D KIM_EXTRA_UNITTESTS=no ../cmake
    make -j 24
    echo -e "\n\n\n#################################\nInstalled...\n$(readlink -f ./lmp)\n#################################"
fi
