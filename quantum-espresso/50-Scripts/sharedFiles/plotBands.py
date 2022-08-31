from Bands import *

fig, ax = plt.subplots()
plt.grid()
bndplot('Inse.bands.ef_0.0010.gnu',-0.1981,'Inse.bands.ef_0.0010.out',ax,shift_fermi=1,range=[-5,5],color="Green",name_k_points=['$\Gamma$','K','M','$\Gamma$'])
