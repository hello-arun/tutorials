#!/bin/bash -e

wd=${PWD}
Package="lammps-29Sep2021"
srcDIR="${wd}/src"
mkdir -p ${srcDIR}
# check if file is not already downloaded then download
if [ ! -f ${srcDIR}/${Package}.tar.gz ];
then
	echo "Downloading source tarball"
    cd $srcDIR
	wget https://download.lammps.org/tars/${Package}.tar.gz
else
	echo "File already downloaded..Now installing..."
fi	

if [ -f ${srcDIR}/${Package}.tar.gz ];
then
	cd $wd
	tar -xzvf ${srcDIR}/${Package}.tar.gz
	# Make build with reax package
	cd ${wd}/${Package}/src
	make yes-REAXFF
	make yes-MANYBODY
	make yes-REPLICA
	make mpi
	echo "done!!!"
fi
