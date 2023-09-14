"""
There are two files in data folder input-topo.lmp and input-dump.lmp.
Topo file includes the initial input geometry relaxed at 0K whereas 
the dump file is dump output of lammps which only contains the particle 
position and type but no topology information. 

Task is to add the topology information to this dump file from topology file.
"""

from ovito.io import import_file,export_file
from ovito.pipeline import Pipeline

topoFile = "./data/input-topo.lmp"
dumpFile = "./data/input-dump.lmp"
outFile = "ex1-out.lmp"
topoPipelineL:Pipeline = import_file(topoFile, sort_particles = True)
dumpPipeline:Pipeline = import_file(dumpFile, sort_particles = True)
topoData=topoPipelineL.compute()
dumpData=dumpPipeline.compute()

# Change Atomic Position in the topoData and also atomic cell
topoData.cell_[:]=dumpData.cell[:]
for pId in topoData.particles.identifiers:
    idx=pId-1
    # Assert that particle types are matching
    assert topoData.particles.particle_types[idx] == dumpData.particles.particle_types[idx]
    topoData.particles_.positions_[idx]=dumpData.particles.positions[idx]

export_file(topoData,outFile, "lammps/data", atom_style="full")

