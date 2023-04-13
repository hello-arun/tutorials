# Req Files

    CHGCAR : from converged scf
    INCAR  : Calculation Param file
    POSCAR : Relaxed CONTCAR
    POTCAR : Pseudopotential
    run.sbatch : Launch script
    KPOINTS: The path for bands plotting (use vaspkit)

# Cleanup File 

Files that need to be delete while cleanup

```
rm CHG CONTCAR DOSCAR EIGENVAL OSZICAR OUTCAR PCDAT PRIMCELL.vasp REPORT vasprun.xml std.err std.out WAVECAR XDATCAR
```