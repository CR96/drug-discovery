#!/bin/bash
# Create a list of the chemical structure of each ligand docked.

# Copy stdout and stderr into a single log ile
exec > >(tee -i ../log/docked_structure_list.txt)
exec 2>&1
for f in ../results/*.pdbqt; do
	[ -f "$f" ] || break
	echo "Ligand name: $f"
	grep 'REMARK  Name = ' $f | sed -i -e 's/"REMARK  Name = "//g'
done
