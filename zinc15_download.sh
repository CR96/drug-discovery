# Download ligand files from ZINC15 or the static ZINC15 mirror at https://files.docking.org

# Sterling T, Irwin JJ.
# ZINC 15 — Ligand discovery for everyone.
# J. Chem. Inf. Model. 2015;55:2324-2337.J. Comput. Chem. 2010;31(2):455-461.
# doi:10.1021/acs.jcim.5b00559

#!/bin/bash

cd ligands/

read -p "Enter the name of the catalog to download: " catalog_name

curl  https://zinc15.docking.org/catalogs/$catalog_name/substances.txt -F output_fields="zinc_id" -F count=all > zinc.txt

## Sort ZINC ID entries numerically and remove any duplicates
sort zinc.txt | uniq > zinc_sorted.txt
split -l 100 --additional-suffix=.txt zinc_sorted.txt

for f in x??.txt; do
	b=$(basename $f .txt)
	output=${catalog_name}_${b}
	curl https://zinc15.docking.org/protomers/subsets/usual.mol2.gz -F count=all -F zinc_id-in=@$f > $output.mol2
done

rm x*.txt

