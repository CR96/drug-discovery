# Drug Discovery Virtual Screening

This repository contains molecular docking database files and scripting tools for use in virtual screening campaigns conducted with [AutoDock Vina.](https://vina.scripps.edu)

This project supplements research performed as part of the [Research Scholars program at EACPHS](https://cphs.wayne.edu/pharmd/research-scholars.php), a concentration offered through the Doctor of Pharmacy program.

## Getting Started
1. Install AutoDock Vina according to the directions on the developer's website. For Arch Linux users, [an unofficial package is also available in the AUR.](https://aur.archlinux.org/packages/autodock-vina/)

2. Obtain a 3D protein structure in `.PDBQT` format from a database such as [RCSB PDB.](https://www.rcsb.org) This format may not be available for direct download; if this is the case, use a tool such as [Open Babel](https://openbabel.org) to convert from an available format. An uncomplexed structure of the protein N5-CAIR mutase (modified from [PBD ID: 2ATE](https://www.rcsb.org/structure/2ATE)) is included in the `protein` folder as an example.

3. Place the prepared file in the `protein` folder and create a configuration file in the `config` folder which specifies this file as the receptor for docking. See `2ate_config.txt` for an example.

4. Obtain 3D ligand structure files in `.PDBQT` format for screening. Place these in the `ligand` folder. NitroAIR ([CID: 135398647](https://pubchem.ncbi.nlm.nih.gov/compound/135398647)), a ligand which forms a known complex with N5-CAIR mutase, is included in the `ligand` folder as an example.

5. Modify `run.sh` to reference the correct configuration file for your receptor protein. Execute the script. If running on a local system, be aware that screening a large number of compounds will take a long time. See the next section for instructions on setting up parallel processing on a cluster or grid-based setup. A log file containing binding energies for each complex will be generated in `log`.

6. Execute `vina_screen_get_top.py #`, with `#` being the number of top results you want to list. This will print the filenames of the docked structures with the lowest binding energies of those generated. These names can be redirected to a text file if desired; for example, a text file `top_results.txt` with the top 100 results can be generated using the command `vina_screen_get_top.py 100 > top_results.txt`.

    **Note:** This is a Python 2 script. It will not work if run using Python 3.

## Parallel Processing
Documentation will be prepared soon.
