#!/bin/bash
srcDIR=$(pwd)
disps=$(ls -d disp*)
vaspxmls=""
for disp in $disps; do
    vaspxmls="$vaspxmls $disp/vasprun.xml"
done

echo "Force will be read from \n$vaspxmls"

## Make force set
phonopy -f $vaspxmls

## Thermal properties
    ## remove -p to turn off  plotting
phonopy -t -p -s conf-mesh.conf > thermal.csv # -s to save it as pdf

## Phonon Bands
phonopy -p -s conf-band.conf  # -s saves it as pdf 
