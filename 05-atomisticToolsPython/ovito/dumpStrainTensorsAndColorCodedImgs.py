import os
import shutil
os.environ['OVITO_GUI_MODE'] = '1' # Request a session with OpenGL support This should be before ovito import

# import PySide6.QtWidgets
# app = PySide6.QtWidgets.QApplication() 
import logging
import numpy as np
from ovito.qt_compat import QtCore
from PySide6.QtGui import QFont
from ovito.pipeline import Pipeline
from ovito.data import DataCollection
from ovito.pipeline import ReferenceConfigurationModifier
from ovito.modifiers import AffineTransformationModifier, ColorCodingModifier
from ovito.vis import OpenGLRenderer, Viewport, ColorLegendOverlay, TextLabelOverlay,CoordinateTripodOverlay,TachyonRenderer,OSPRayRenderer
from ovito.modifiers import AtomicStrainModifier
from ovito.io import import_file, export_file
# Request a session with OpenGL support This should be before ovito import
# os.environ['OVITO_GUI_MODE'] = '1'

logging.basicConfig(
    level=logging.DEBUG,          # Set the logging level to DEBUG (or other level)
    format='%(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[
        logging.FileHandler('dumpStrainTensorsAndColorCodedImgs.log',mode="w"),  # Log to a file
        logging.StreamHandler()            # Log to console (stream)
    ]
)

# refDIR = "../12-MD-SW-potential/1-MoTe2/2H/20-stress-strain/calc/epX-30x46x1-Temp-004K-srate-1e8/dump"
refDIR = "../11-MD-SW-potential/1-MoTe2/2H/21-stress-strain-vacancy/calc/uniAxialX-46x70x1-Temp-004K/dump"
fileSeq = "02-strain-*.txt"
outDIR = "./dump/06-11_MD_SW-2H_MoTe2-21StressStrainVac-epX-Temp_004K"
dataSaveDIR=f"{outDIR}/data"
imgSaveDIR=f"{outDIR}/imgs"
scaleFactor=2
step=10 # Save every th frame
maxFrameIdx=800 # Index of maximum frame to save
os.makedirs(dataSaveDIR,exist_ok=True)
os.makedirs(imgSaveDIR,exist_ok=True)
shutil.copy(src=__file__,dst=f"{outDIR}/")
exportIMgs = True
propsForImgs= ["Strain Tensor.XX","Strain Tensor.YY","Strain Tensor.XY"]
columns = ["Particle Identifier", "Particle Type", "Position.X", "Position.Y",
           "Position.Z", "Strain Tensor.XX", "Strain Tensor.YY", "Strain Tensor.XY"]

logging.info(f"""
Input Sequence : {refDIR}/fileSeq
    Output Dir : {outDIR}
Dump Img Props : {propsForImgs}
    Data Props : {columns} 
 Save every th : {step}
Max frame idx  : {maxFrameIdx}
""")
os.makedirs(outDIR, exist_ok=True)
def insert_line(file_path, line_to_insert, line_number):
    with open(file_path, "r") as f:
        lines = f.readlines()
    lines.insert(line_number, line_to_insert)
    with open(file_path, "w") as f:
        f.writelines(lines)


# import file sequence to pipeline
pipeline: Pipeline = import_file(f"{refDIR}/{fileSeq}")
sequence=[i for i in range(0,min(pipeline.source.num_frames,maxFrameIdx),step)]
data = pipeline.compute(0)
a0 = data.cell[0, 0]
b0 = data.cell[1, 1]

# Define list of modifiers
atomicStrainModifier = AtomicStrainModifier(
    cutoff=24,
    affine_mapping=ReferenceConfigurationModifier.AffineMapping.Off,
    minimum_image_convention=True,
    output_strain_tensors=True,
    reference_frame=0,
    select_invalid_particles=False,
)

# Add the modifieres to pipeline
pipeline.modifiers.append(atomicStrainModifier)
# pipeline.modifiers.append(colorCodingModifier)

columnStr = " ".join(col.replace(" ", "_") for col in columns)
# for idx in range(0, pipeline.source.num_frames, 5):
logging.info(f"Num of total data Seq: {pipeline.source.num_frames}")
logging.info("Saving data sequence")

for idx in sequence:
    data: DataCollection = pipeline.compute(idx)
    frameNo = data.attributes['SourceFrame']
    # print(data.attributes)
    # print(data.particles)
    outFile = f"{dataSaveDIR}/fr-{frameNo}.txt"
    export_file(data, outFile, "xyz", columns=columns)
    insert_line(outFile, f"{columnStr}\n", 2)
    logging.info(f"exported frame {idx:05d}/{sequence[-1]}")

if exportIMgs:
    # Modifier
    colorCodingModifier = ColorCodingModifier(
        property="Strain Tensor.XX",
        start_value=-0.050,
        end_value=0.150,
        gradient=ColorCodingModifier.Rainbow())
    pipeline.modifiers.append(colorCodingModifier)
    pipeline.add_to_scene()

    vp = Viewport(
        # type=Viewport.Type.Top,
        #   camera_pos=(a0/2, b0/2-15, 0)
    )
    qFont = QFont("Serif")
    print(qFont)

    # List of overlays to add
    colorLegendOverlay = ColorLegendOverlay(
        modifier=colorCodingModifier,
        # alignment = QtCore.Qt.AlignmentFlag.AlignLeft | QtCore.Qt.AlignmentFlag.AlignBaseline,
        orientation=QtCore.Qt.Orientation.Horizontal,
        # offset_y = -0.04,
        # ticks_enabled=True,
        # title = 'Strain',
        # text_color=(1,0,0),
        font=qFont.toString(),
        font_size=0.06,
        outline_enabled=True,
        legend_size=0.6,
        # format_string = '%.2f'
    )
    textLabelOverlay = TextLabelOverlay(
        text="Hello",
        font=qFont.toString(),
        font_size=0.035,
        alignment=QtCore.Qt.AlignmentFlag.AlignRight | QtCore.Qt.AlignmentFlag.AlignBottom,

    )
    coordinateTripodOverlay=CoordinateTripodOverlay()

    vp.overlays.append(colorLegendOverlay)
    vp.overlays.append(coordinateTripodOverlay)
    vp.overlays.append(textLabelOverlay)

    for property in ["Strain Tensor.XX","Strain Tensor.YY","Strain Tensor.XY"]:
        logging.info(f"Saving Color Coded Imgs for prop {property}")
        colorCodingModifier.property=property
        saveDIR=f"{imgSaveDIR}/{property.replace(' ','_')}"
        os.makedirs(saveDIR,exist_ok=True)

        # Top View Render
        vp.type=Viewport.Type.Top;
        vp.zoom_all((1080*scaleFactor,720*scaleFactor))
        vp.fov*=1.28
        for idx in sequence:
            data = pipeline.compute(idx)
            a_  = data.cell[0,0]
            b_  = data.cell[1,1]
            epX = (a_-a0)/a0
            epY = (b_-b0)/b0
            textLabelOverlay.text=f"epX={epX:0.2f}<br>epY={epY:0.2f}"
            logging.info(f"Exported Top View prop {property} {idx:05d}/{sequence[-1]}")
            vp.render_image(filename=f'{saveDIR}/top-fr-{idx:04d}.png', 
                        size=(1080*scaleFactor,720*scaleFactor),
                        frame=idx,
                        # background=(0.1,0.1,0), 
                        renderer= OpenGLRenderer(),
                        # renderer= OSPRayRenderer(),
                        # renderer= TachyonRenderer()
                        )
            
        # Front View Render
        vp.type=Viewport.Type.Front;
        vp.zoom_all((1080*scaleFactor,720*scaleFactor))
        for idx in sequence:
            data = pipeline.compute(idx)
            a_  = data.cell[0,0]
            b_  = data.cell[1,1]
            epX = (a_-a0)/a0
            epY = (b_-b0)/b0
            textLabelOverlay.text=f"epX={epX:0.2f}<br>epY={epY:0.2f}"
            logging.info(f"Exported Front View prop {property} {idx:05d}/{sequence[-1]}")
            vp.render_image(filename=f'{saveDIR}/front-fr-{idx:04d}.png', 
                        size=(1080*scaleFactor,720*scaleFactor),
                        frame=idx,
                        # background=(0.1,0.1,0), 
                        renderer= OpenGLRenderer(),
                        # renderer= OSPRayRenderer(),
                        # renderer= TachyonRenderer()
                        )