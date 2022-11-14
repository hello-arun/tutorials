import numpy as np
import matplotlib.pyplot as plt

def plotNPR(axis):

    yaxis = 'Y';
    if(axis=='Y')
    yaxis='X';
    fig, ( ax1,ax2) = plt.subplots(1, 2)
    ax1.set_xlabel(f'$\epsilon_{axis}$')
    ax1.set_ylabel(f'$\epsilon$')

    ax1.set_xlabel(f'$\epsilon_{axis}$')
    ax2.set_ylabel('Poisson Ratio')
        data = np.loadtxt(f'Strain_Y_data{m}.txt')
        lx = data[:, 1]
        ly = data[:, 2]
        lz = data[:, 3]
        l = len(lx)
        ground=int((l-1)/2)
        e_lx = (lx-lx[ground])/lx[ground]
        e_ly = (ly-ly[ground])/ly[ground]
        e_lz = (lz-lz[ground])/lz[ground]
        ax1.plot(e_ly, e_lx,'.-',label = f'Strain_X{m}')
        # ax1.plot(e_ly, e_ly,'.-',label = f'strain_y{m}')
        # ax1.plot(e_ly, e_ly,'.-',label = f'strain_y')
        ax1.plot(e_ly, e_lz,'.-',label = f'Strain_Z{m}')

        npr_x = []
        npr_y = []
        npr_z = []
        for i in range(1,l-1):
            npr_x.append(-(e_lx[i+1]-e_lx[i-1])/(e_ly[i+1]-e_ly[i-1]))
            npr_y.append(-(e_ly[i+1]-e_ly[i-1])/(e_ly[i+1]-e_ly[i-1]))
            npr_z.append(-(e_lz[i+1]-e_lz[i-1])/(e_ly[i+1]-e_ly[i-1]))

        ax2.plot(e_ly[1:l-1],npr_x,'.-',label = f'prX{m}')
        ax2.plot(e_ly[1:l-1],npr_z,'.-',label = f'prZ{m}')
        ax2.hlines(y=0,xmin= -0.02,xmax=0.02,linestyle='--',color='k')

    ax1.legend()
    ax2.legend()
    fig.tight_layout()
    ax1.grid()
    plt.show()

mol = sys.argv[1]
axis = sys.argv[2].upper()

if(axis=='X'):
    plotNPR('X')
elif(axis=='Y'):
    plotNPR('Y')
elif(axis=='XY' or axis=='YX'):
    plotNPR('Y')
    plotNPR('X')