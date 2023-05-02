tempDIR=$(mktemp -d --tmpdir="./") 
svn export --force  https://github.com/hello-arun/Tutorial-for-kids/trunk/boiler-plate/01-scf-dos-bands/ $tempDIR
rsync -av $tempDIR/* ./
echo -e "\nDelete tempDIR"
echo "rm -r ${tempDIR}"