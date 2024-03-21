dirs=$(\ls 0* -d)
mkdir -p "contcars"
for dir in $dirs; do
    if [ -f ${dir}/CONTCAR ]; then
    cp ${dir}/CONTCAR ./contcars/${dir}.vasp
    else
    cp ${dir}/POSCAR ./contcars/${dir}.vasp
    fi
done




# dirs=$(\ls 0* -d)
# for dir in $dirs; do
#     if [ -f ${dir}/CONTCAR ]; then
#     cp ${dir}/CONTCAR ${dir}/POSCAR 
#     fi
# done