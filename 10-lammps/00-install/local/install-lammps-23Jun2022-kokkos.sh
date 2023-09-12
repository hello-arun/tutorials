#!/bin/bash -e

wd=${PWD}
srcDIR="${wd}/src"
package="lammps-23Jun2022"
installDIR="${wd}/${package}-kokkos"
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
    rm -rf build
    mkdir build 
    cd build || exit 1
    module purge
    module load kokkos/3.2.00/gcc-7.5.0-dd3pqj3
    module load cuda/11.5.0/gcc-7.5.0-syen6pj
    module unload zlib
    module load cmake/3.18.4/gcc-7.5.0-mbftn7v
    module load openmpi/4.1.1/gcc-7.5.0-fxaxwiu
    cmake --version
    which nvcc_wrapper
    cmake \
    -D CMAKE_CXX_COMPILER="$(which nvcc_wrapper)" \
    -D Kokkos_ARCH_HOSTARCH=yes   \
    -D Kokkos_ARCH_GPUARCH=yes    \
    -D Kokkos_ENABLE_CUDA=yes     \
    -D Kokkos_ENABLE_OPENMP=yes   \
    -D PKG_KOKKOS=yes \
    -D PKG_REAXFF=yes \
    -D PKG_MANYBODY=yes \
    -D PKG_REPLICA=yes ../cmake
    # -D CMAKE_CXX_COMPILER= \
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
