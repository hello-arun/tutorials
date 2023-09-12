wd=${PWD}
outFile="${wd}/bench_reax.tar.gz"
dataDIR="${wd}/data"

mkdir -p ${dataDIR}
wget -O ${outFile} https://www.lammps.org/bench/bench_reax.tar.gz

cd ${dataDIR} && tar -xvzf ${outFile} --strip-components=1