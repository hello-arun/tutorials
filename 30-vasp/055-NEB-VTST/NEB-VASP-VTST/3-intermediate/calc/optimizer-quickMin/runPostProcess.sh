module load perl
VTST_SCRIPTS_HOME="/home/jangira/application/vtst/vtstscripts-1033"
${VTST_SCRIPTS_HOME}/nebbarrier.pl
${VTST_SCRIPTS_HOME}/nebspline.pl

echo "image rxnCord energy force image" > temp
cat neb.dat>> temp
column -t temp | tee neb.dat
python plotMEP.py