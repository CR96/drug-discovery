# Prepare ligand files for docking with AutoDock Vina.

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

#!/bin/bash
#PBS -N rowec_ligand_prep
#PBS -l select=1:ncpus=8:mem=8gb
#PBS -q wsuq

### Load software modules from WSU Grid
module load autodockvina/1.1.2
module load python/3.7 # Contains openbabel
source conda.sh
conda activate openbabel_env

cd ~/drug-discovery/

# Create results directory if it doesn't exist
mkdir -p results/

cd ligands/

### If needed, uncompress molecule files.
### For some reason, the ZINC database contains some *.gz files that aren't actually compressed
for f in *.gz; do
	b=$(basename $f .gz) ## Preserves filetype, eg. basename of *.mol2.gz is *.mol2
	if [[ $(file $f) == *compressed* ]]; then
		echo Uncompressing ligand $f
		gunzip $f &
	else
		echo Ligand $f is not compressed, removing .gz extension
		mv $f $b &
	fi
done

wait

### If needed, convert SDF files to pdbqt
for f in *.sdf; do
	b=$(basename $f .sdf)
	output=$b.pdbqt
	echo Converting ligand $f
	echo Saving as $output
	obabel -i sdf $f -opdbqt -m --gen3d best -p -O $output
	rm $f &
done

### If needed, convert mol2 files to pdbqt
for f in *.mol2; do
	b=$(basename $f .mol2)
	output=$b.pdbqt
	echo Converting ligand $f
	echo Saving as $output
	obabel -i mol2 $f -opdbqt -m --gen3d best -p -O $output
	rm $f &
done

wait

### If needed, split pdbqt files
for f in *.pdbqt; do
	firstline=$(head -n 1 $f)
	if [[ $firstline == *MODEL* ]]; then
		echo Splitting ligand $f
		vina_split --input $f
		rm $f &
	fi
done

wait

### Arrange ligands into directories containing no more than 290 files each
n=0
echo Arranging ligand subdirectories...
for f in *.pdbqt; do
	d=$(printf %01d $((i/290+1)))
	mkdir -p $d
	mv "$f" $d
	let i++
done

echo Done.
