import logging
from math import ceil
from ovito.io import import_file,export_file
from ovito.pipeline import Pipeline
from ovito.data import DataCollection,Particles
from ovito.modifiers import CombineDatasetsModifier,AffineTransformationModifier,ExpressionSelectionModifier,ReplicateModifier,ExpandSelectionModifier,DeleteSelectedModifier,InvertSelectionModifier
import numpy as np
import os
logging.basicConfig(
    level=logging.INFO,          # Set the logging level to DEBUG (or other level)
    format='%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.FileHandler('03-mergeAuODPA.log',mode="w"),  # Log to a file
        logging.StreamHandler()            # Log to console (stream)
    ]
)

radiusODPA = 100 # Radius of ODPA region  
radiusAu = 45 
gapAuODPA = 10 
shiftzODPA=5
outDIR="./supCell"
refODPAFile=f"{outDIR}/ODPA-R{radiusODPA:03d}.lmp"
refAuFile="./input-Au-unitCell.lmp"
os.makedirs(outDIR,exist_ok=True)
pipe_ODPA:Pipeline = import_file(refODPAFile,sort_particles=True)
pipe_Au=import_file(refAuFile,sort_particles=True)
data_ODPA:DataCollection=pipe_ODPA.compute()
data_Au=pipe_Au.compute()
lf,lx_Au,ly_Au=2*(radiusAu+radiusODPA+gapAuODPA),data_Au.cell[0,0],data_Au.cell[1,1]
sx_Au,sy_Au,sz_Au=ceil(lf/lx_Au),ceil(lf/ly_Au),5
replicate=ReplicateModifier(num_x=sx_Au,num_y=sy_Au,num_z=sz_Au)
data_Au.apply(modifier=replicate) # Change the data inplace
data_Au.cell_[:,3]  =  0   # setOriginToZero
data_Au.cell_[2,2]  = 100  # change the c vector to 100 Angstrom
data_ODPA.cell_[:,3] = 0   # We set the origin to 0 so that we not have to worry about 
Lx,Ly=data_Au.cell[0,0],data_Au.cell[1,1]
cx,cy=Lx*0.5,Ly*0.5
data_ODPA.cell_=data_Au.cell
data_Au.particles_.positions_ -= [np.min(data_Au.particles_.positions[:,0]),np.min(data_Au.particles_.positions[:,1]),np.min(data_Au.particles_.positions[:,2])]
data_ODPA.particles_.positions_ -= [
    np.average(data_ODPA.particles_.positions[:,0])-cx,
    np.average(data_ODPA.particles_.positions[:,1])-cy,
    np.min(data_ODPA.particles_.positions[:,2])-shiftzODPA]

expressionSelection = ExpressionSelectionModifier(
    expression=f'(Position.X-{cx})*(Position.X-{cx})+(Position.Y-{cy})*(Position.Y-{cy})<{(radiusODPA+gapAuODPA)**2}'
)
deleteSelection=DeleteSelectedModifier()
data_Au.apply(modifier=expressionSelection)
data_Au.apply(modifier=deleteSelection)

export_file(data_Au,"./temp1.lmp", "lammps/data", atom_style="full")
export_file(data_ODPA,"./temp2.lmp", "lammps/data", atom_style="full")

pipeline = import_file('temp2.lmp')
# Insert the particles from a second file into the dataset. 
modifier = CombineDatasetsModifier()
modifier.source.load("./temp1.lmp")
pipeline.modifiers.append(modifier)
export_file(pipeline,f"{outDIR}/merged.lmp", "lammps/data", atom_style="full")
export_file(pipeline,f"{outDIR}/temp3.lmp", "lammps/data", atom_style="full")
