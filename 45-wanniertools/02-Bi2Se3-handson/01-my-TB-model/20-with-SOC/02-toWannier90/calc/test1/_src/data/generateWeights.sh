#!/bin/bash
# This script is used to extract the projectability from
# the output of projwfc.x (OUTCAR-projwfc.projwfc).

# Remove temporary files if exist
rm -f e.dat
rm -f p.dat
rm -f tmp.dat
rm -f p_vs_e.dat

# Check OUTCAR-projwfc.projwfc exists
[[ -f "OUTCAR-projwfc.projwfc" ]] || { echo "OUTCAR-projwfc.projwfc!"; echo "Aborting!"; exit 1; }

# Get energies and projectability in the correct order
cat OUTCAR-projwfc.projwfc |grep '=='|awk '{print $5}' > e.dat
cat OUTCAR-projwfc.projwfc |grep '|psi|^2'|awk '{print $3}' > p.dat
paste e.dat p.dat > tmp.dat

sort -k1n tmp.dat > p_vs_e.dat 

# Clean workspace
rm e.dat p.dat tmp.dat