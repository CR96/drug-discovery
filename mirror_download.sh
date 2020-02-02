# Download ligand files from the static ZINC15 mirror at https://files.docking.org

# Sterling T, Irwin JJ.
# ZINC 15 — Ligand discovery for everyone.
# J. Chem. Inf. Model. 2015;55:2324-2337.J. Comput. Chem. 2010;31(2):455-461.
# doi:10.1021/acs.jcim.5b00559

#!/bin/bash

# Note: This is an interactive script. It is not designed to be run unattended.

cd ligands/

echo "30, 40, 50: In stock for immediate delivery"
echo "20: Make on demand"
echo "10: Boutique"
echo "7: One-Step"
echo "3: May be available plated in libraries"
echo "1: Not for sale"
read -p "Select a catalog directory by number: " catalog_directory

echo "Entering command-line web browser."
echo "Note the directory name of the catalog you wish to download, then press Q twice to exit the browser."
read -p "Press Enter to continue "

lynx https://files.docking.org/catalogs/$catalog_directory/

read -p "Enter the name of the catalog to download: " catalog_name

## MOL2 files are downloaded as some ZINC15 catalogs are not fully available in PDBQT format.
## Run convert_ligands.sh to convert files.
echo "Downloading MOL2 tranche lists..."
echo "=============="
wget https://files.docking.org/catalogs/$catalog_directory/$catalog_name/sdi-mol2-frags
wget https://files.docking.org/catalogs/$catalog_directory/$catalog_name/sdi-mol2-leads
wget https://files.docking.org/catalogs/$catalog_directory/$catalog_name/sdi-mol2-lugs

sed -i '1s/^/# MOL2 Fragments\n/' sdi-mol2-frags
sed -i '1s/^/# MOL2 Leads\n/' sdi-mol2-leads
sed -i '1s/^/# MOL2 Lugs\n/' sdi-mol2-lugs

cat sdi-mol2-frags sdi-mol2-leads sdi-mol2-lugs > download
rm sdi-mol2-frags
rm sdi-mol2-leads
rm sdi-mol2-lugs

echo "Done. Now review the list and remove any tranches you do not wish to download."
read -p "Press Enter to continue "
vim download

echo "Generating download script..."

# The resulting downloaded file is a list of file URLs.
# Add 'wget' to each line and make the file executable.
sed -i -e 's/^/wget /' download
chmod a+x download

echo "Done."
read -p "Press Enter to begin the download. This may take a long time. "
echo "Downloading..."
echo "=============="
./download
rm ./download
echo "Download complete."
