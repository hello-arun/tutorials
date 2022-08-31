#!/home/jangira/.conda/envs/py3/bin/python
import numpy as np
import numpy.polynomial as polynomial
import matplotlib.pyplot as plt
import sys
params = {'mathtext.default': 'regular' }
plt.rcParams.update(params)

poly  = polynomial.Polynomial
fig, ( ax1,ax2) = plt.subplots(1, 2)

try:
    quantity = sys.argv[1]  # Quantity to plot eamp or tot_charge etc
    ppFolder   = sys.argv[2]  # postProcessing Folder
    axis     = sys.argv[3]   # YZ or ZY or Y or Z
    x        = int(sys.argv[4])   # 0 or 1 for x or y axis
    if(len(sys.argv)>5):
        order = int(sys.argv[5])
    else:
        order = 2
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
label_size=20
ax=['X','Y','Z']
axis=axis.upper()

ax1.set_xlabel(f'$\epsilon_{ax[x]}$')
ax1.set_ylabel(f'$\epsilon$')

ax2.set_xlabel(f'$\epsilon_{ax[x]}$')
ax2.set_ylabel('Poisson ratio')

ax1.xaxis.label.set_size(label_size)
ax1.yaxis.label.set_size(label_size)
ax2.xaxis.label.set_size(label_size)

try:
    values = np.loadtxt(f'{ppFolder}/{quantity}/list.sh',dtype=str,ndmin=1)
    values.sort()
    print(f'Values are...')
    print(values)
except OSError as er:
    print(er)
    exit()
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
            pfitz, stats = poly.fit(e_lx, e_lz, order, full=True)
            p = ax1.plot(e_lx, pfitz(e_lx),'-',label = f'$\epsilon_{ax[z]}$ {value}')
            ax1.plot(e_lx, e_lz,'.',color=p[0].get_color())
            
            e_lz = pfitz(e_lx)
            npr_z=-np.gradient(e_lz,e_lx)
            ax2.plot(e_lx,npr_z,'.-',label = f'$\\nu_z$ {value}')
        
        if 'Y' in axis:
            ly = data[:, 1+y]
            e_ly = (ly-ly[ground])/ly[ground]
            pfity, stats = poly.fit(e_lx, e_ly, order, full=True)
            p = ax1.plot(e_lx, pfity(e_lx),'-',label = f'$\epsilon_{ax[y]}$ {value}')
            ax1.plot(e_lx, e_ly,'.',color=p[0].get_color())

            e_ly = pfity(e_lx)
            npr_y=-np.gradient(e_ly,e_lx)
            ax2.plot(e_lx,npr_y,'.-',label = f'$\\nu_{ax[y]}$ {value}')
        
        
        ax2.plot(e_lx, e_lx*0, linestyle='--', color='k',lw=0.75)
        print(f"{value} plotted..\n")
    except OSError as er:
        print(er)
    except:
        print(f'Error on line {sys.exc_info()[-1].tb_lineno}')



ax1.legend(loc=0, prop={'size': 10})
ax2.legend(loc=0, prop={'size': 10})

fig.tight_layout()
ax1.grid()
ax2.grid()
plt.show()
print("################################")
print("Program Ended..")
print("################################")