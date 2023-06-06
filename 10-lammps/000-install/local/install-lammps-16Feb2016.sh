#!/bin/bash

wd=${PWD}
Package="lammps-16Feb2016"

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
	mv ./lammps-16Feb16 ./$Package
	
	# Build reax library before installing reax package
	cd ${wd}/${Package}/lib/reax
	make -f Makefile.gfortran 

	# Make build with reax package
	cd ${wd}/${Package}/src
	make yes-REAX
	make yes-USER-REAXC
	make mpi
	echo "done!!!"
fi
