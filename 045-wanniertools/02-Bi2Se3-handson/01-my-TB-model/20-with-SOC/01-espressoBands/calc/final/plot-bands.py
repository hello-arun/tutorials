# This was written by Levi Lentz for the Kolpak Group at MIT
# This is distributed under the MIT license
# Modified by Arun

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gs
import sys
import argparse

params = {'mathtext.default': 'regular' }
plt.rcParams.update(params)

#This function extracts the high symmetry points from the output of bandx.out
def Symmetries(fstring): 
    f = open(fstring,'r')
    x = np.zeros(0)
    for i in f:
        if "high-symmetry" in i:
            x = np.append(x,float(i.split()[-1]))
    f.close()
    return x
# This function takes in the datafile, the fermi energy, the symmetry file, a ax, and the label
# It then extracts the band data, and plots the bands, the fermi energy in red, and the high symmetry points


parser = argparse.ArgumentParser(description='This will plot band structure')
parser.add_argument('--gnuFile',help="gnu data file",   default=argparse.SUPPRESS)
parser.add_argument('--fermi',  help="fermi energy",    default=0.0, type=float)
parser.add_argument('--fermiFromFile', dest='fermiFromFile',action='store_true',default=False ,help="wether to extract fermi energy extract from the file.\nDo not pass any args")
parser.add_argument('--outFile',help="file containing symmetry info could be anything" , default=argparse.SUPPRESS)

parser.add_argument('--title',  help="Title of the plot",default="Bands plot")
parser.add_argument('--kPath',metavar="\"a,b,c\"",help="Pass K Path as a string separated by commas(,)",default=argparse.SUPPRESS)
parser.add_argument('--shiftFermi', dest='shiftFermi', action='store_true', default=False,
                    help="to shift the fermi level to zero just pass this parameter")
parser.add_argument('--shiftVBM', dest='shiftVBM', action='store_true', default=False,
                    help="to shift the fermi level to zero just pass this parameter")
parser.add_argument('--noLegend', dest='noLegend', action='store_true', default=False,
                    help="to shift the fermi level to zero just pass this parameter")
parser.add_argument('--color', help="color of the plot default is blue", default='b')
parser.add_argument('--ls',metavar="linestyle", help="lineStyle of the plot..check matplotlib linestyle \n for more option. Default is solid", default='solid')
parser.add_argument('--lw',metavar="lineWidth", help="lineWidth of the plot..check matplotlib lineWidth \n for more option. Default is solid", type=float,default=0.75)
parser.add_argument('--range',metavar="a b", help="range of plot on y axis. two float numbers", nargs = '+', type=float,default=argparse.SUPPRESS)
parser.add_argument('--thr',  help="threshold for correction default 0.05",    default=0.05, type=float)


args = parser.parse_args()



fig, ax = plt.subplots()
if args.fermiFromFile:
    file = open(args.gnuFile,'r')
    args.fermi=float(file.readline().split()[1])
    print(args.fermi)
    file.close()
z = np.loadtxt(args.gnuFile) #This loads the bandx.dat.gnu file
tempdata= z[:,1]-args.fermi-args.thr #Thr
vbm = np.max(z[z[:,1]-args.fermi-args.thr<=0][:,1])
cbm = np.min(z[z[:,1]-args.fermi-args.thr>=0][:,1])
print(f"VBM : {vbm}")
print(f"CBM : {cbm}")

eg = cbm-vbm
if eg < args.thr:
    eg=0
vbm_pos = np.where( z[:,1] == vbm)[0][0]
cbm_pos = np.where( z[:,1] == cbm)[0][0]


x = np.unique(z[:,0]) #This is all the unique x-points
bands = []
bndl = len(z[z[:,0]==x[1]]) #This gives the number of bands in the calculation
fermi_shift=0.0
if args.shiftFermi:
    fermi_shift=args.fermi
if args.shiftVBM:
    fermi_shift=vbm

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
    ax.plot(i[:,0],i[:,1]-fermi_shift,linestyle=args.ls,lw=args.lw,color="k")
if not args.noLegend:
    legend = f"$E_g$ = {eg:0.4f}"
    #empty plot to generate legend
    ax.plot([None],[None],color=args.color,linestyle=args.ls,label=legend)
if eg>0.0001:
    ax.annotate("", xy=(z[cbm_pos,0],z[cbm_pos,1]-fermi_shift), xytext=(z[vbm_pos,0],z[vbm_pos,1]-fermi_shift),arrowprops=dict(arrowstyle="->"))
temp = Symmetries(args.outFile)
for j in temp: #This is the high symmetry lines
    x1 = [j,j]
    #x2 = [fermi-10,fermi+10]
    #ax.plot(x1,x2,'--',lw=0.55,color='black',alpha=0.75)
    ax.axvline(x=j,linestyle='dashed',color='black',alpha=0.75)
ax.plot([min(x),max(x)],[vbm-fermi_shift,vbm-fermi_shift],color='red',linestyle='dotted')
ax.set_xticks(temp)
ax.set_xticklabels([])
if 'kPath' in args:
    print(args.kPath)
    kPath=args.kPath.split(",")
    if len(kPath)==len(temp):
        ax.set_xticklabels(kPath)
if 'range' in args:
    ax.set_ylim(args.range)
ax.set_xlim([axis[0],axis[1]])
ax.set_xlabel('K Path')
ax.set_ylabel('E-E$_{VBM}$ (eV)')
if not args.noLegend:
    ax.legend(loc=1)
plt.grid()
plt.title(f'Bands {args.title}')
plt.savefig(f"{args.title}.png")
# plt.savefig(f"{title}.svg")