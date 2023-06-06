This example is taken as it is from manual of wannier90-v3.0. To copy and modify the files accordingly you can use the script `data/prep-data.sh`. 

`data/run.sbatch` script is job submission script which will carry out calculation is defined order.

`./run.sh` script just submit the job in calculation directory.

*Note that, unless you specify wf_collect=.true. in your pw.x input
file, you must run pw2wannier90 with the same number of processors as pw.x*