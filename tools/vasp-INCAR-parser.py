import re

class IncarProps:
    def __init__(self,text:str):
        self.lines = text.splitlines(keepends=True)
    
    def set(self,key:str,value:str,comment:str=None):
        """
        Change the value of the key provided.
        If key does not exist it adds in the end
        """
        pattern=r"\b"+key+r"\b\s*=\s*([^#\n]+?)(?:\s*#\s*(.*))?$"
        for i,line in enumerate(self.lines):
            match = re.search(pattern, line)
            if match:
                comment = match.group(2)
                self.lines[i] = f"    {key:<10} = {value:<10} # {comment} \n"
                return
        print(f"Key {key} not found, adding now...")
        self.lines.append(f"    {key:<10} = {value:<10} # {comment} \n")
    
    def comment(self,key):
        """
        Comment out the key prop
        """
        pattern=r"\b"+key+r"\b\s*=\s*([^#\n]+?)(?:\s*#\s*(.*))?$"
        for i,line in enumerate(self.lines):
            match = re.search(pattern, line)
            if match:
                value = match.group(1)
                comment = match.group(2)
                self.lines[i] = f"    # {key:<10} = {value:<10} # {comment} \n"
                return
        print(f"Key {key} not found in INCAR lines.")


    def write_file(self,fileName:str):
        """
        Write this object in the INCAR file
        """
        with open(fileName,"w+") as file:
            file.writelines(self.lines)


incarProps = IncarProps("""
# System Setting
    SYSTEM     = SysName    # 
    PREC       = Accurate   # Accurate works best
    GGA        = PE         # PE=PBE, 91=Perdew-Wang-91
    ENCUT      = 600        

# Type of Calculation
    NSW        = 0          # Maximum Number of ionic relaxation steps to perform For SCF set it to 0
    ISIF       = 2          # Which type of run to perform 0=MD, 2=Atomic Relax, 3=Atomic and Unit cell relax
    IBRION     = -1         # Determines how ions are moved -1=for scf only no update,0=MD, 2=conjugate gradientg algorithm
    ISPIN      = 1          # 1=spin unpol, 2=spin pol
    NBANDS     = 120        # Checked by dry run it was 123
    IVDW       = 12         # D3 vdw correction
    ISYM       = 0          # 0: Sym switched off

# Continue or Fresh
    ISTART     = 0          # 0=Scratch, 1=Continuation Job only read wavecar file 
    ICHARG     = 2          # 2=ch den from sup pos of atoms , 0=ch den from wave function 1=read CHGCAR file

# Stopping Criteria
    EDIFF      = 1.0E-6     # Energy Convergence in electronic steps
    EDIFFG     = -1.0E-3    # Force conv in ionic steps, -ve for force +ve for energy diffrence

# Smearing
    ISMEAR     = 0          # 0=Gaussina Smearing
    SIGMA      = 0.05       # Smearing width

# Paralalization
    NCORE      = 32         # No of Cores that will work on each orbital
    KPAR       = 1          # KPoint Parallelization
    NBAND      = xx         # No of Bands

# Dos Setting
    EMIN       = -20        # 
    EMAX       = 20         #
    NEDOS      = 1000       # No of grid points for DOS
    LORBIT     = 11         # Ideal for projected-DOS

# Dipole Correction
    LDIPOL = .TRUE.
    IDIPOL = 3
    DIPOL  = 0.5 0.5 0.5

# Output Settings
    LVTOT      = False      # Total pot with    Vxc will be written to LOCPOT file for .TRUE.
    LVHAR      = True       # Total pot without Vxc will be written to LOCPOT file for .TRUE.
    LAECHG     = True       # Useful for bader charge analysis
    LWAVE      = True       # Wavecar File
    LCHARG     = True       # Charge Density File
    LELF       = True       # Electron Localization Function

# Extras
""")

incarProps.set("ENCUT","100")
incarProps.set("ENCUT","50")
incarProps.set("ISIF","2")
incarProps.set("DIPOL",True)
incarProps.set("LDIPOL","0.5 0.5 0.5")
incarProps.set("Name","Arun","Addition prop define later")
incarProps.comment("NSW")
incarProps.comment("IBRION")
incarProps.write_file("./INCAR")
# import re

# input_file = "/ibex/scratch/jangira/current-projects/polarisation/group4-metal-chalcogenides/GeS/10-v3x3/20-polarization/data/INCAR"
# pattern = r"^([^#\n]+?)\s*=\s*([^#\n]+?)(?:\s*#\s*(.*))?$"

# with open(input_file, "r") as file:
#     for line in file:
#         match = re.match(pattern, line)
#         if match:
#             key = match.group(1).strip()
#             value = match.group(2).strip()
#             comment = match.group(3)
#             print(f"Key: {key}, Value: {value}, Comment: {comment}")
