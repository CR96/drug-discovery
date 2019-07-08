#! /bin/bash
# Run the docking simulation.
# TODO: Set up a parallel processing batch script that screens all compounds in ligand/ against a specified enzyme in protein/

# Create output and log directories if they don't exist
mkdir -p log/
mkdir -p output/

# Copy stdout and stderr into a single log file
exec > >(tee -i log/2ate_log.txt)
exec 2>&1

for f in ligand/*.pdbqt; do
	b=`basename $f .pdbqt`
	echo Processing ligand $b
	vina --config config/2ate_conf.txt --ligand $f --out output/${b}.pdbqt
done
