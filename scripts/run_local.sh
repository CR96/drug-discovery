#! /bin/bash
# Run the docking simulation on a local machine.

# This script was adapted from a script written by the authors of [AutoDock Vina.](https://vina.scripps.edu)
# The original is available at https://vina.scripps.edu/vina_screen_local.sh.

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

# Create output and log directories if they don't exist
mkdir -p ../log/
mkdir -p ../results/

# Copy stdout and stderr into a single log file
exec > >(tee -i ../log/2ate_log.txt)
exec 2>&1

for f in ../ligands/*.pdbqt; do
	[ -f "$f" ] || break
	b=$(basename $f .pdbqt)
	echo Processing ligand $b
	vina --config ../config/2ate.conf --ligand $f --out ../results/${b}_out.pdbqt
done
