folders="00  02  04  06  08  10  12  14  01  03  05  07  09  11  13  15"
for folder in $folders; do
    cp $folder/POSCAR POSCARS/POSCAR-$folder
done