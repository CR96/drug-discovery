#!/bin/bash

# Prepare ligand files for docking with AutoDock Vina.

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

#SBATCH --job-name rowec_convert_ligands
#SBATCH -t 1440 -n 8 --mem=2G

## Adjust this to match the number of directories generated by arrange_ligands.sh
#SBATCH --array=1-8

#SBATCH -q primary
#SBATCH --requeue

### Load Open Babel from WSU Grid
module load python/3.7 # Contains openbabel
source conda.sh
conda activate openbabel_env

cd ../ligands

### If needed, uncompress molecule files.
### For some reason, the ZINC database contains some *.gz files that aren't actually compressed
for f in *.gz; do
	[ -f "$f" ] || break
	b=$(basename $f .gz) ## Preserves filetype, eg. basename of *.mol2.gz is *.mol2
	if [[ $(file $f) == *compressed* ]]; then
		echo Uncompressing ligand $f
		gunzip $f &
		rm $f
	else
		echo Ligand $f is not compressed, removing .gz extension
		mv $f $b &
	fi
done

wait

### If needed, convert sdf files to pdbqt
for f in *.sdf; do
	[ -f "$f" ] || break
	b=$(basename $f .sdf)
	output=$b.pdbqt
	echo Converting ligand $f
	echo Saving as $output
	obabel -i sdf $f -opdbqt -m --gen3d best -p -O $output
	rm $f &
done

wait

### If needed, convert mol2 files to pdbqt
for f in *.mol2; do
	[ -f "$f" ] || break
	b=$(basename $f .mol2)
	output=$b.pdbqt
	echo Converting ligand $f
	echo Saving as $output
	obabel -i mol2 $f -opdbqt -m --gen3d best -p -O $output
	rm $f
done

echo Done.
