# Run the docking simulation in parallel using a PBS job array.
# Be sure to run arrange_ligands.sh first to properly organize ligands into subdirectories.

# This script was adapted from a script written by the authors of [AutoDock Vina.](https://vina.scripps.edu) i
# The original is available at https://vina.scripps.edu/vina_screen_local.sh.

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

#!/bin/bash
#PBS -N rowec_docking
#PBS -l select=1:ncpus=8:mem=2gb

## Adjust this to match the number of directories generated by arrange_ligands.sh
#PBS -J 1-8

#PBS -q wsuq
#PBS -r y

### Load AutoDock Vina module from WSU Grid
module load autodockvina/1.1.2

# Create results directory if it doesn't exist
mkdir -p ../results/

# Process ligand files by directory
for f in ../ligands/$PBS_ARRAY_INDEX/*.pdbqt; do
    b=$(basename $f .pdbqt)
    echo Processing ligand $b in subdirectory $PBS_ARRAY_INDEX
    vina --config ../config/2ate.conf --ligand $f --out ../results/${b}_out.pdbqt
done