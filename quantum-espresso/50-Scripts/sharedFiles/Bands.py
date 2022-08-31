# This was written by Levi Lentz for the Kolpak Group at MIT
# This is distributed under the MIT license
# Modified by QuantumNerd 13.Apr.2020
# Welcome to check out my tutorials: https://www.youtube.com/channel/UCgQPek4ZSo_yL7wEjIhxvfA
# use function bndplot() to plot the band

import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import matplotlib.gridspec as gs
import sys

#This function extracts the high symmetry points from the output of bandx.out
def Symmetries(fstring): 
    f = open(fstring,'r')
    x = np.zeros(0)
    for i in f:
        if "high-symmetry" in i:
            x = np.append(x,float(i.split()[-1]))
    f.close()
    return x
# This function takes in the datafile, the fermi energy, the symmetry file, a subplot, and the label
# It then extracts the band data, and plots the bands, the fermi energy in red, and the high symmetry points
def bndplot(datafile,fermi,symmetryfile,subplot,**kwargs):
    ## necessary:
    # datafile is the bands.dat.gnu file generated from band.x
    # fermi is the Fermi energy
    # symmetryfile is the standard output file of band.x (bands.pp.out)
    # subplot is the axes that you want to plot the band on

    ## optional:
    # use name_k_points=['L','G','X','U','G'] where G is Gamma point to label the high symmetry points. It must have the same length as the variable 'temp'
    # use shift_fermi=1 to shift the Fermi energy to zero
    # use color='black' to manually set the color of the band structure plot. Useful to plot two band structure together for comparison
    # use linestyle='dashed' to manually set the linestyle of the band structure plot. Useful to plot two band structure together for comparison
    # use range=[-5,5] to set the energy range for plotting the band structure
    # use legend='Si, PBE' to set the legend of the bands
    # use shift_vbm = 1 to shift to vbm
    if 'shift_fermi' in kwargs:
        bool_shift_efermi = kwargs['shift_fermi']
    else:
        bool_shift_efermi = 0
    if 'color' in kwargs:
        color_bnd=kwargs['color']
    else:
        color_bnd='black'
    if 'linestyle' in kwargs:
        line_bnd=kwargs['linestyle']
    else:
        line_bnd='solid'
    
    z = np.loadtxt(datafile) #This loads the bandx.dat.gnu file
    Fermi = float(fermi)
    tempdata= z[:,1]-Fermi
    vbm = np.max(tempdata[tempdata<=0])
    cbm = np.min(tempdata[tempdata>=0])
    eg = cbm-vbm
    vbm_pos = np.where( tempdata == vbm)[0][0]
    cbm_pos = np.where( tempdata == cbm)[0][0]


    x = np.unique(z[:,0]) #This is all the unique x-points
    bands = []
    bndl = len(z[z[:,0]==x[1]]) #This gives the number of bands in the calculation
    if bool_shift_efermi:
        fermi_shift=Fermi
        if 'shift_vbm' in kwargs:
            fermi_shift=z[vbm_pos,1]
    else:
        fermi_shift=0
    axis = [min(x),max(x)]
    for i in range(0,bndl):
        bands.append(np.zeros([len(x),2])) #This is where we storre the bands
    for i in range(0,len(x)):
        sel = z[z[:,0] == x[i]]   #Here is the energies for a given x
        test = []
        for j in range(0,bndl): #This separates it out into a single band
            bands[j][i][0] = x[i]
            #bands[j][i][1] = np.multiply(sel[j][1],13.605698066)
            bands[j][i][1] = sel[j][1]
    for i in bands: #Here we plots the bands
        subplot.plot(i[:,0],i[:,1]-fermi_shift,color=color_bnd,linestyle=line_bnd,lw=0.75)
    if 'legend' in kwargs:
        legend = f"$E_g$ = {eg:0.4f}"
        #empty plot to generate legend
        subplot.plot([None],[None],color=color_bnd,linestyle=line_bnd,label=legend)
    # subplot.plot(z[vbm_pos,0],z[vbm_pos,1]-fermi_shift,'ko',lw=1.25)
    # subplot.plot(z[cbm_pos,0],z[cbm_pos,1]-fermi_shift,'ko',lw=1.25)
    ax.annotate("", xy=(z[cbm_pos,0],z[cbm_pos,1]-fermi_shift), xytext=(z[vbm_pos,0],z[vbm_pos,1]-fermi_shift),arrowprops=dict(arrowstyle="->"))
    temp = Symmetries(symmetryfile)
    for j in temp: #This is the high symmetry lines
        x1 = [j,j]
        #x2 = [fermi-10,fermi+10]
        #subplot.plot(x1,x2,'--',lw=0.55,color='black',alpha=0.75)
        subplot.axvline(x=j,linestyle='dashed',color='black',alpha=0.75)
    subplot.plot([min(x),max(x)],[Fermi-fermi_shift+vbm,Fermi-fermi_shift+vbm],color='red',linestyle='dotted')
    subplot.set_xticks(temp)
    subplot.set_xticklabels([])
    if 'name_k_points' in kwargs:
        if len(kwargs['name_k_points'])==len(temp):
            subplot.set_xticklabels(kwargs['name_k_points'])
    if 'range' in kwargs:
        range_plot=kwargs['range']
        subplot.set_ylim([range_plot[0],range_plot[1]])
    subplot.set_xlim([axis[0],axis[1]])
    subplot.set_xlabel('k')
    subplot.set_ylabel('E-E_$VBM$ $(eV)$')
    if 'legend' in kwargs:
        subplot.legend(loc=1)


fig, ax = plt.subplots()
gnuFile = sys.argv[1]
fermi = sys.argv[2]
outFile = sys.argv[3]
title = sys.argv[4]
baseData = open('../ZScripts/base.sh','r')
k_points=""
for i in baseData:
    if 'k_path' in i:
        k_points = (i.split("\"")[1]).split(",")
plt.grid()
bndplot(gnuFile,fermi,outFile,ax,shift_fermi=1,range=[-4,4],color="b",name_k_points=k_points,shift_vbm=1,legend=1)
plt.title(f'Bands {title}')
plt.savefig(f"{title}.png")
# plt.savefig(f"{title}.svg")
