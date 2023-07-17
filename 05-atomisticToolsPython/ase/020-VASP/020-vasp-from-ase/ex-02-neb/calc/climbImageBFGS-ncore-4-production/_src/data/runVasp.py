from ase.io import vasp
from ase.neb import NEB
from ase.calculators.vasp import Vasp as VaspCalc
from ase.optimize import BFGS
# Read initial and final states:
initial = vasp.read_vasp('POSCAR-i.vasp')
final = vasp.read_vasp('POSCAR-f.vasp')
# Make a band consisting of 5 images:
numIntImgs=3
images = [initial]

images += [initial.copy() for i in range(numIntImgs)]
images += [final]
neb = NEB(images,climb=True,parallel=False)
# Interpolate linearly the potisions of the three middle images:
neb.interpolate()
# Set calculators:
images[0].calc=VaspCalc(prec='Accurate',directory=f"./00/",xc='PBE',lreal=False,kpts=[5,8,1],isym=0,ncore=4)
images[numIntImgs+1].calc=VaspCalc(prec='Accurate',directory=f"./{(numIntImgs+1):02d}/",xc='PBE',lreal=False,kpts=[5,8,1],isym=0,ncore=4)
print(images[0].get_total_energy())
print(images[numIntImgs+1].get_total_energy())

for i,image in enumerate(images[1:numIntImgs+1]):
    image.calc = VaspCalc(prec='Accurate',directory=f"./{(i+1):02d}/",xc='PBE',lreal=False,kpts=[5,8,1],isym=0,ncore=4)
# Optimize:
optimizer = BFGS(neb, trajectory='MoS2-2H-1Tp.traj')
optimizer.run(fmax=0.04)