This is an example for VASP scalability tests. The goal of 
the scalability tests is to find proper settings for the 
parallelization parameters like KPAR, NCORE/NPAR, and the 
number of nodes.

## step 0: Create a working folder in your /scratch/$USER directory
```bash
cd /scratch/$USER
mkdir vasp_training
cd vasp_training
```
## step 1: Preparation
### step 1.1: Preparation for the VASP input files and Slurm jobscript template
```bash
mkdir input_template
 cd input_template
  copy the VASP input files (INCAR, POSCAR, POTCAR, KPOINTS)
  make sure no such parameters in INCAR: LWAVE, LCHARG, NELM, ISIF, KPAR, NPAR, NCORE
  cp KPOINTS KPOINTS_1kpt
  modify KPOINTS_1kpt to have only 1 k-point
  copy a working Slurm jobscript
  modify the Slurm jobscript: "#SBATCH --nodes=__nodes__" and "srun --ntasks=__ntasks__"
 cd ..
```
### step 1.2: Preparation for the scripts
```bash
mkdir scripts
cd scripts
copy the scripts
cd ..
```

## step 2: Run the scalability tests
```
mkdir test
```
### step 2.1: NCORE tests

```bash
cp ../scripts/run_ncore_tests.sh ./
     cp ../scripts/plot_ncore_data.sh ./
     modify ncores_per_node, ncore_list, and nodes_list in both script
     ./run_ncore_tests.sh
     After all jobs finish, ./plot_ncore_data.sh. Two files will be generated: ncore_data.dat, ncore_data.pdf
     From ncore_data.pdf, determine ncore_opt and nodes_1kpt, which will be needed for the next KPAR tests
```

### step 2.2: KPAR tests
```bash
cp ../scripts/run_to_get_outcar.sh ./
cp ../scripts/run_kpar_tests.sh ./
cp ../scripts/plot_kpar_data.sh ./
./run_to_get_outcar.sh
After the job finishes, modify ncores_per_node, ncore_opt, nodes_1kpt, and nkpoints in both script
./run_kpar_tests.sh
After all jobs finish, ./plot_kpar_data.sh. Two files will be generated: kpar_data.dat, kpar_data.pdf
From kpar_data.pdf, determin KPAR and nodes
cd ..
For the following production runs: set KPAR, NCORE=ncore_opt in INCAR, set --nodes=nodes, --ntasks=nodes*32 in the Slurm jobscript
```
