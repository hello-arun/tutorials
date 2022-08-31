#!/bin/bash
module load quantumespresso

# Step :1 Caclculate Band decomposed charge density
# for the given range of K-Points
cat > pp.chden_band_decomposed.in << EOF
&INPUTPP
outdir='./out',
plot_num = 7
kpoint(1) = START_KPOINT_NUMBER    
kpoint(2) = END_KPOINT_NUMBER
kband(1) = BAND_NO  
filplot = "chden_band_decomposed.out"
/
EOF
pp.x <pp.chden_band_decomposed.in> pp.chden_band_decomposed.out


# Step 2:
    # Calculate xy-plane average of charge 
    # density obtained from the first step
    # For example this script will consider 150 
    # planes along the z-axis(3rd axis) and calulate
    # averaged of charge density in each plane and
    # store it in a file avg.dat
cat > avg_chden.in<<EOF
1
chden_band_decomposed.out
1.D0
150
3
1.000000
EOF
average.x <avg_chden.in > avg_chden.out

# Step 3:
    # Now we can check for this perticular band 
    # if the peak of averaged charge density lies
    # inside our 2D-system or far outside from 
    # python script

cat > plotBand.py <<EOF
import numpy as np
import matplotlib.pyplot as plt
data = np.loadtxt("avg.dat")
location = np.where(data[:,1] == numpy.amax(data[:,1]))

if location<9 or location>11 :
    # this band should not be plotted
else:
    # plot this band.
EOF


python plotBand.py
module purge quantumespresso