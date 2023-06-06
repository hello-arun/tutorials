#!/bin/bash

# Settings
prefix="GeS"
nproc=24



SCRIPT_DIR=$PWD
cd ..
cat > ph.in << EOF
title_line = 'Phonon of $prefix'
&inputph
  recover = .true.
  outdir = './out',
  tr2_ph = 1.0d-16,
  ldisp = .true.,
  nq1 = 8, nq2 = 8, nq3 = 1
  fildyn='dyn',
 /
EOF

cat > q2r.in <<EOF
&input
  fildyn='dyn',
  zasr='simple', 
  flfrc='fc'
 /
EOF

cat > matdyn.in << EOF
&input
  asr = 'simple'  
  flfrc = 'fc'
  flfrq = 'freq' 
  q_in_band_form = .true.,
  q_in_cryst_coord = .true.
 /
5
   0.0000000000     0.0000000000     0.0000000000  30  ! Gamma
   0.5000000000     0.0000000000     0.0000000000  30  ! X
   0.5000000000     0.5000000000     0.0000000000  30  ! M
   0.0000000000     0.5000000000     0.0000000000  30  ! Y
   0.0000000000     0.0000000000     0.0000000000  1   ! Gamma
 / 
EOF

cat > runPhonon.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$nproc
#SBATCH --partition=batch
#SBATCH -J Phonon
#SBATCH -o Job1.%J.out
#SBATCH -e Job1.%J.err
#SBATCH --time=18:00:00
#SBATCH --constraint=[cascadelake|skylake]

#run the application:
module load quantumespresso/6.6

mpirun -np \$(nproc) pw.x <scf.in> scf.out
mpirun -np \$(nproc) ph.x -inp ph.in > ph.out
q2r.x -inp q2r.in > q2r.out
matdyn.x -inp matdyn.in> matdyn.out
EOF


sbatch runPhonon.sh >> ./ZScripts/jobs.log
