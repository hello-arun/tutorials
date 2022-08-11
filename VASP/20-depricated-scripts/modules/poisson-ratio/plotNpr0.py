#!/home/jangira/.conda/envs/py3/bin/python
import numpy as np
import numpy.polynomial as polynomial
import matplotlib.pyplot as plt
from matplotlib.ticker import (MultipleLocator, AutoMinorLocator)

import sys

mm=1/25.4
fig, ( ax1) = plt.subplots(1,1)
plt.style.use('plot_style.txt')
fig.set_size_inches(89*mm,89*mm)

ax1.set_xlabel(f'Electric field\n(V/nm)')
ax1.set_ylabel(f'Poisson\' ratio')

# ax1.xaxis.set_minor_locator(MultipleLocator(.5))
# ax1.xaxis.set_major_locator(MultipleLocator(2))
# ax1.yaxis.set_major_locator(MultipleLocator(0.02))
# ax1.yaxis.set_minor_locator(MultipleLocator(0.005))

# ax1.set_xlim([-1.0,12.0])
# ax1.set_ylim([-0.30,-0.20])

poly  = polynomial.Polynomial

try:
    quantity = sys.argv[1]  # Quantity to plot eamp or tot_charge etc
    ppFolder = sys.argv[2]  # postProcessing Folder
    axis     = sys.argv[3]   # YZ or ZY or Y or Z
    x        = int(sys.argv[4])   # 0 or 1 for x or y axis
except:
    print("Not enough argument proveided.")
    print("1 : Quantity\n2 : Folder(postProcessing)\n3 : YZ or Y or Z\n4 : 0 or 1 (i.e. X or Y)")
    print("Exiting")
    exit()
print("################################")
print("Program Started")
print("################################")
y=1-x # 1 and 2 means it will be on y axis 
z=2  
axis=axis.upper()
ax=['X','Y','Z']

try:
    values = np.loadtxt(f'{ppFolder}/{quantity}/list.sh',dtype=str,ndmin=1)
    print(f'FileNames are...')
    print(values)
except OSError as er:
    print(er)
    exit()
dataY=[]
dataZ=[]
for value in values:
    print(f"Trying for {value}")
    try:
        data = np.loadtxt(f'{ppFolder}/{quantity}/{value}/strain_{ax[x]}_data.txt')
        lx = data[:, 1+x]
        l = len(lx)
        ground=np.where(data[:,0]==0.0)[0][0]
        e_lx = (lx-lx[ground])/lx[ground]
        if "Z" in axis:
            lz = data[:, 1+z]
            e_lz = (lz-lz[ground])/lz[ground]
            pfitz, stats = poly.fit(e_lx, e_lz, 2, full=True)
            # p = ax1.plot(e_lx, pfitz(e_lx),'-',label = f'$\epsilon_{ax[z]}$ {name}')
            # ax1.plot(e_lx, e_lz,'.',color=p[0].get_color())
            e_lz = pfitz(e_lx)
            npr_z=-np.gradient(e_lz,e_lx)
            dataZ.append([float(value.split("_")[-1]),npr_z[np.where(e_lx==0.0)][0]])
            # ax2.plot(e_lx,npr_z,'.-',label = f'$\\nu_z$ {name}')
        if 'Y' in axis:
            ly = data[:, 1+y]
            e_ly = (ly-ly[ground])/ly[ground]
            pfity, stats = poly.fit(e_lx, e_ly, 2, full=True)
            # p = ax1.plot(e_lx, pfity(e_lx),'-',label = f'$\epsilon_{ax[y]}$ {name}')
            # ax1.plot(e_lx, e_ly,'.',color=p[0].get_color())

            e_ly = pfity(e_lx)
            npr_y=-np.gradient(e_ly,e_lx)
            # ax2.plot(e_lx,npr_y,'.-',label = f'$\\nu_{ax[y]}$ {name}')
            dataY.append([float(value.split("_")[-1]),npr_y[np.where(e_lx==0.0)][0]])
        # ax2.plot(e_lx, e_lx*0, linestyle='--', color='k',lw=0.75)
        print(f"{value} plotted..\n")
    except OSError as er:
        print(er)
    except:
        print(f'Error on line {sys.exc_info()[-1].tb_lineno}')

if 'Y' in axis:
    dataY = np.array(dataY)
    # pfity, stats = poly.fit(dataY[:,0], dataY[:,1], 2, full=True)
    # ax1.plot(dataY[:,0]*514.220,pfity(dataY[:,0]),label=f"$\\nu_{ax[y]}$")
    ax1.plot(dataY[:,0]*514.220,dataY[:,1],".-")


if 'Z' in axis:
    dataZ = np.array(dataZ)
    print(dataZ)
    # pfitz, stats = poly.fit(dataZ[:,0], dataZ[:,1], 2, full=True)

    # ax1.plot(dataZ[:,0]*514.220,pfitz(dataZ[:,0]),label=f"$\\nu_{ax[z]}$")
    ax1.plot(dataZ[:,0]*514.220,dataZ[:,1],'.-')


plt.tight_layout()
# ax1.grid()
plt.savefig("test.svg")
# plt.show()
print("################################")
print("Program Ended..")
print("################################")