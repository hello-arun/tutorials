# ulimit -s unlimited
export OMP_STACKSIZE=512m
ulimit -s unlimited
export OMP_NUM_THREADS=1
VASP_CMD="/opt/intel/oneapi/mpi/2021.18/bin/mpirun -np 24 /home/migamma/Softwares/vasp.6.4.2_optcell/bin/vasp_std"
$VASP_CMD