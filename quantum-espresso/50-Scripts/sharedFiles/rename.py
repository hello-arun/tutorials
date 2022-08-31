import numpy as np
import os
for i in np.linspace(0,2,51):
    src = f'GeS.relax0{i:.2f}.out'
    dst = f'GeS.relax.X0{i:.2f}.out'
    os.rename(src,dst)
    #os.rename(f"GeS.relax0{i:.2f}.out","GeS.relax.X0{i:.2f}.out")
