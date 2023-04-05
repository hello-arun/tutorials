#!/bin/bash -e

wd=${PWD}
Package="lammps-12Dec2018"
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
	cd ${wd}/lammps-12Dec18/src
	#make yes-REAXFF
	#make yes-MANYBODY
	#make yes-REPLICA
	module purge	
	module load openmpi/4.1.1/gcc-11.2.0-eaoyonl
	make yes-molecule		
	make yes-MANYBODY	
	make yes-KSPACE
	make yes-RIGID
        make mpi
	echo "done!!!"
fi
