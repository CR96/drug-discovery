# Arrange ligand files for parallel docking with AutoDock Vina.
# Argument: The number of ligands per directory
# Example: "arrange_ligands.sh 100" will organize ligands into directories of 100 each

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

#!/bin/bash
#PBS -N rowec_arrange_ligands
#PBS -q wsuq

cd ../ligands/

### If needed, split sdf files
for f in *.sdf; do
  [ -f "$f" ] || break
	b=$(basename $f .sdf)
	python ../scripts/split_sdf.py $b 1
	rm $f
done

wait

### If needed, split pdbqt files
for f in *.pdbqt; do
  [ -f "$f" ] || break
	firstline=$(head -n 1 $f)
	if [[ $firstline == *MODEL* ]]; then
		echo Splitting ligand $f
		vina_split --input $f
		rm $f
	fi
done

wait

### Arrange ligands into directories containing no more than specified number of files
n=0
echo Arranging ligand subdirectories...
for f in *; do
  [ -f "$f" ] || break
	d=$(printf %01d $((i/$1+1)))
	mkdir -p $d
	mv "$f" $d
	let i++
done

echo Done.
