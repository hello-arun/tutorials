#!/bin/bash
# This script is used to extract the projectability from
# the output of projwfc.x (05-projwfc.out).

# Remove temporary files if exist
rm -f e.dat
rm -f p.dat
rm -f tmp.dat
rm -f p_vs_e.dat

# Check 05-projwfc.out exists
[[ -f "05-projwfc.out" ]] || { echo "05-projwfc.out!"; echo "Aborting!"; exit 1; }

# Get energies and projectability in the correct order
cat 05-projwfc.out |grep '=='|awk '{print $5}' > e.dat
cat 05-projwfc.out |grep '|psi|^2'|awk '{print $3}' > p.dat
paste e.dat p.dat > tmp.dat

sort -k1n tmp.dat > p_vs_e.dat 

# Clean workspace
rm e.dat p.dat tmp.dat