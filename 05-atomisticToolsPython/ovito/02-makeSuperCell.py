import logging
from math import ceil
from ovito.io import import_file,export_file
from ovito.pipeline import Pipeline
from ovito.data import DataCollection,Particles
from ovito.modifiers import AffineTransformationModifier,ExpressionSelectionModifier,ReplicateModifier,ExpandSelectionModifier,DeleteSelectedModifier,InvertSelectionModifier
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
zUnitAu = 5
relShiftODPA = 5

L_MAX=2*(radiusAu+radiusODPA+gapAuODPA)
refODPAFile="./output-topo.lmp"
refAuFile="./input-Au-unitCell.lmp"
outDIR="./supCell"
os.makedirs(outDIR,exist_ok=True)

# First Prepare ODPA 
pipe_ODPA:Pipeline = import_file(refODPAFile,sort_particles=True)
data_ODPA:DataCollection=pipe_ODPA.compute()
sx=ceil(2*radiusODPA/data_ODPA.cell[0,0])
sy=ceil(2*radiusODPA/data_ODPA.cell[1,1])
data_ODPA.apply(ReplicateModifier(num_x=sx,num_y=sy,num_z=1))
cx,cy=data_ODPA.cell[0,0]*0.5+data_ODPA.cell[0,3],data_ODPA.cell[1,1]*0.5+data_ODPA.cell[1,3] # center of cell
expressionSelection = ExpressionSelectionModifier(
    expression=f'(Position.X-{cx})*(Position.X-{cx})+(Position.Y-{cy})*(Position.Y-{cy})>{radiusODPA*radiusODPA}'
)
expandSelection = ExpandSelectionModifier(
    iterations=20, # depth of recursion
    mode=ExpandSelectionModifier.ExpansionMode.Bonded
)
deleteSelction=DeleteSelectedModifier()
data_ODPA.apply(expressionSelection)
data_ODPA.apply(expandSelection)
data_ODPA.apply(deleteSelction)
export_file(data_ODPA, f"{outDIR}/temp-1.lmp", "lammps/data", atom_style="full")

# Now Prepare AU
pipe_Au=import_file(refAuFile,sort_particles=True)
data_Au=pipe_Au.compute()
sx_Au,sy_Au,sz_Au=ceil(L_MAX/data_Au.cell[0,0]),ceil(L_MAX/data_Au.cell[1,1]),zUnitAu
data_Au.apply(ReplicateModifier(num_x=sx_Au,num_y=sy_Au,num_z=sz_Au))
cx,cy=data_Au.cell[0,0]*0.5+data_Au.cell[0,3],data_Au.cell[1,1]*0.5+data_Au.cell[1,3] # center of cell
data_Au.apply(ExpressionSelectionModifier(
    expression=f'(Position.X-{cx})*(Position.X-{cx})+(Position.Y-{cy})*(Position.Y-{cy})<{(radiusODPA+gapAuODPA)**2}'
))
data_Au.apply(DeleteSelectedModifier())
export_file(data_Au, f"{outDIR}/temp-2.lmp", "lammps/data", atom_style="full")

# Now Adjust set the unitCell origin to 0,0 for both Au and ODPA
data_Au.cell_[:,3] = 0
data_Au.cell_[2,2]=100
data_ODPA.cell_=data_Au.cell
cx,cy=data_Au.cell[0,0]*0.5+data_Au.cell[0,3],data_Au.cell[1,1]*0.5+data_Au.cell[1,3] # center of cell

# Shift Atoms to match perfectly
data_Au.particles_.positions_ -= [
    np.min(data_Au.particles_.positions[:,0]),
    np.min(data_Au.particles_.positions[:,1]),
    np.min(data_Au.particles_.positions[:,2])
]
data_ODPA.particles_.positions_ -= [
    np.average(data_ODPA.particles_.positions[:,0])-cx,
    np.average(data_ODPA.particles_.positions[:,1])-cy,
    np.min(data_ODPA.particles_.positions[:,2])-np.max(data_Au.particles_.positions[:,2]+relShiftODPA)
]

export_file(data_ODPA, f"{outDIR}/temp-3.lmp", "lammps/data", atom_style="full")
export_file(data_Au, f"{outDIR}/temp-4.lmp", "lammps/data", atom_style="full")

export_file(data_ODPA, f"{outDIR}/ODPA-RO_{radiusODPA:03d}-RAu_{radiusAu:03d}-Gap_{gapAuODPA:02d}.lmp", "lammps/data", atom_style="full")
export_file(data_Au, f"{outDIR}/Au-RO_{radiusODPA:03d}-RAu_{radiusAu:03d}-Gap_{gapAuODPA:02d}.lmp", "lammps/data", atom_style="full")
