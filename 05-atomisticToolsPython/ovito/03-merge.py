from math import ceil
from ovito.io import import_file,export_file
from ovito.modifiers import CombineDatasetsModifier

rODPA = 100 # Radius of ODPA region  
rAu = 45 
gapAuODPA = 10 
outDIR="./supCell"

pipeline = import_file(f'{outDIR}/ODPA-RO_{rODPA:03d}-RAu_{rAu:03d}-Gap_{gapAuODPA:02d}.lmp')
# Insert the particles from a second file into the dataset. 
modifier = CombineDatasetsModifier()
modifier.source.load(f'{outDIR}/Au-RO_{rODPA:03d}-RAu_{rAu:03d}-Gap_{gapAuODPA:02d}.lmp')
pipeline.modifiers.append(modifier)
export_file(pipeline,f'{outDIR}/merged-RO_{rODPA:03d}-RAu_{rAu:03d}-Gap_{gapAuODPA:02d}.lmp', "lammps/data", atom_style="full")
export_file(pipeline,f"{outDIR}/temp-5.lmp", "lammps/data", atom_style="full")
