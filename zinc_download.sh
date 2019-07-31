# Download ligand files from the ZINC15 database.

# Sterling T, Irwin JJ.
# ZINC 15 — Ligand discovery for everyone.
# J. Chem. Inf. Model. 2015;55:2324-2337.J. Comput. Chem. 2010;31(2):455-461.
# doi:10.1021/acs.jcim.5b00559

#!/bin/bash
#PBS -N rowec_ligand_download
#PBS -l select=1:ncpus=8:mem=8gb
#PBS -q wsuq

cd ligand/

read -p "Enter ZINC15 catalog name as it appears in the catalog URL (e.g. dbfda): " catalog_name

echo Downloading...

### Retrieve all substances in requested catalog
curl https://zinc15.docking.org/catalogs/$catalog_name/substances.txt -F output_fields="zinc_id" -F count=all > zinc.txt

split -l 100 zinc.txt

for i in x??; do
	curl https://zinc15.docking.org/protomers/subsets/usual.mol2.gz -F count=all F zinc_id-in=@$i > $i.mol2.gz
done

echo Download complete.
