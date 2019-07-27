# Run the docking simulation in parallel using a PBS job array.
# Be sure to run prepare_ligands.sh first to properly organize ligands into subdirectories.

# This script was adapted from a script written by the authors of [AutoDock Vina.](https://vina.scripps.edu) i
# The original is available at https://vina.scripps.edu/vina_screen_local.sh.

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

#!/bin/bash
#PBS -N rowec_docking
#PBS -l select=1:ncpus=8:mem=8gb
#PBS -J 1-290
#PBS -q wsuq
#PBS -r y

cd ligand/

# Process ligand files by directory
for f in $($PBS_ARRAY_INDEX + 1); do
    b=$(basename $f .pdbqt)
    echo Processing ligand $b in subdirectory $($PBS_ARRAY_INDEX + 1)
    vina --config config/2ate.conf.txt --ligand $f --out output/${b}_docked.pdbqt
done
