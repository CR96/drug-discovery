#!/bin/bash

# Download ligand files from ZINC20 or the static ZINC mirror at https://files.docking.org

# Irwin JJ, Tang KG, Young J, et al.
# ZINC20 — A free ultralarge-scale chemical database for ligand discovery.
# J. Chem. Inf. Model. 2020, 60, 6065-6073.
# doi:10.1021/acs.jcim.0c00675

cd ../ligands/

read -p "Enter the name of the catalog to download: " catalog_name

curl  https://zinc20.docking.org/catalogs/$catalog_name/substances.txt -F output_fields="zinc_id" -F count=all > zinc.txt

## Sort ZINC ID entries numerically and remove any duplicates
sort zinc.txt | uniq > zinc_sorted.txt
split -l 100 --additional-suffix=.txt zinc_sorted.txt

for f in x??.txt; do
	[ -f "$f" ] || break
	b=$(basename $f .txt)
	output=${catalog_name}_${b}
	curl https://zinc20.docking.org/protomers/subsets/usual.mol2.gz -F count=all -F zinc_id-in=@$f > $output.mol2
done

rm x*.txt

