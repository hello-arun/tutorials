import logging
from math import ceil
from ovito.io import import_file,export_file
from ovito.pipeline import Pipeline
from ovito.data import DataCollection,Particles
from ovito.modifiers import ExpressionSelectionModifier,ReplicateModifier,ExpandSelectionModifier,DeleteSelectedModifier,InvertSelectionModifier
import numpy as np
import os
logging.basicConfig(
    level=logging.INFO,          # Set the logging level to DEBUG (or other level)
    format='%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.FileHandler('02-makeSuperCell.log',mode="w"),  # Log to a file
        logging.StreamHandler()            # Log to console (stream)
    ]
)

radiusODPA = 100 # Radius of ODPA region  
radiusAu = 45 
gapAuODPA = 10 
refFile="./output-topo.lmp"
outDIR="./supCell"
os.makedirs(outDIR,exist_ok=True)

pipeline:Pipeline = import_file(refFile,sort_particles=True)
data:DataCollection=pipeline.compute()
Lx,Ly,Lz=data.cell_[0,0],data.cell_[1,1],data.cell_[2,2]
sx=ceil(2*radiusODPA/Lx)
sy=ceil(2*radiusODPA/Ly)
replicate=ReplicateModifier(num_x=sx,num_y=sy,num_z=1)
pipeline.modifiers.append(replicate)
data=pipeline.compute()
Lx,Ly,Lz=data.cell[0,0],data.cell[1,1],data.cell[2,2]
cx,cy=Lx*0.5+data.cell[0,3],Ly*0.5+data.cell[1,3]
expressionSelection = ExpressionSelectionModifier(
    expression=f'(Position.X-{cx})*(Position.X-{cx})+(Position.Y-{cy})*(Position.Y-{cy})<{radiusODPA*radiusODPA}'
)
expandSelection = ExpandSelectionModifier(
    iterations=20, # depth of recursion
    mode=ExpandSelectionModifier.ExpansionMode.Bonded
)
invertSelection=InvertSelectionModifier()
deleteSelction=DeleteSelectedModifier()
pipeline.modifiers.append(expressionSelection)
pipeline.modifiers.append(expandSelection)
pipeline.modifiers.append(invertSelection)
pipeline.modifiers.append(deleteSelction)
data=pipeline.compute()
export_file(data, f"{outDIR}/ODPA-R{radiusODPA:03d}.lmp", "lammps/data", atom_style="full")