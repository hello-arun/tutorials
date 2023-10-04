from pymatgen.core import Structure
from pymatgen.symmetry.kpath import KPathLatimerMunro,KPathSetyawanCurtarolo
from pymatgen.symmetry.bandstructure import HighSymmKpath
import matplotlib.pyplot as plt
from pymatgen.electronic_structure import plotter
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer

struct:Structure = Structure.from_file("../1-MoTe2/1Tp/13-bands/data/POSCAR")
# struct:Structure = Structure.from_file("./2H-ortho/13-bands/data/POSCAR")

sym=SpacegroupAnalyzer(struct)
struct=sym.get_primitive_standard_structure(international_monoclinic=False)
recLattice = struct.lattice.reciprocal_lattice
brillZoneOrtho = struct.lattice.get_brillouin_zone()
print(f"Volume dirct: {struct.lattice.volume}")
print(f"Volume  reci: {struct.lattice.reciprocal_lattice.volume}")
print(f"Volume  prod: {struct.lattice.reciprocal_lattice.volume*struct.lattice.volume}")

# highSymKPath=HighSymmKpath(struct)
highSymKPath=KPathLatimerMunro(struct)  # Weird Notatio
# highSymKPath=KPathSetyawanCurtarolo(struct)  # Should be used for primitve structures
# recLattice.

fig = plt.figure(figsize=(10,10))
ax = fig.add_subplot(projection='3d')

kpoints = highSymKPath.kpath["kpoints"]
for key in kpoints:
    reducedPoint=kpoints[key]
    point=recLattice.get_cartesian_coords(reducedPoint)
    ax.scatter(*point,color="r")
    ax.text(*point,key,fontsize=12)


def drawLine(ax,lineSegment=([0,0,0],[1,1,1]),color="g"):
    x=[lineSegment[0][0],lineSegment[1][0]]
    y=[lineSegment[0][1],lineSegment[1][1]]
    z=[lineSegment[0][2],lineSegment[1][2]]
    ax.plot(x,y,z,color=color)


b1 = recLattice.matrix[0]
b2 = recLattice.matrix[1]
b3 = recLattice.matrix[2]
drawLine(ax,lineSegment=([0,0,0],b1),color="blue")
drawLine(ax,lineSegment=([0,0,0],b2),color="blue")
drawLine(ax,lineSegment=([0,0,0],b3),color="blue")

ax.text(*b1,r"$b_1$",fontsize=16)
ax.text(*b2,r"$b_2$",fontsize=16)
ax.text(*b3,r"$b_3$",fontsize=16)

# Draw Brillouin Zone
for facet in brillZoneOrtho:
    for i in range(len(facet)-1):
        drawLine(ax,lineSegment=(facet[i],facet[i+1]),color="green")

ax.set_aspect("equal")
plt.grid(False)
plt.axis('off')


plt.show()
