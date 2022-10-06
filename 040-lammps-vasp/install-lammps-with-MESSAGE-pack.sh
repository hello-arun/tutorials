#!/bin/bash 

### Activate Python2 environment first ###
# This will install lammps-29Sep2021 with MESSAGE package
# to interlink lammps and vasp

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
    installDIR=$wd/lammps-with-MESSAGE-temp
    mkdir -p $installDIR
    tar -xzvf ${srcDIR}/${Package}.tar.gz -C $installDIR


    # build CSlib with MPI and ZMQ support
    cd ${installDIR}/${Package}/lib/message
    python Install.py -m
    cd ${installDIR}/${Package}/lib/message/cslib/src
    make shlib zmq=no

    cd ${installDIR}/${Package}/src
    make yes-message
    make yes-REAXFF
    make yes-MANYBODY
    make yes-REPLICA
    make mpi
    echo "done!!!"
fi
