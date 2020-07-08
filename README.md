# Drug Discovery Virtual Screening

This repository contains molecular docking database files and scripting tools for use in virtual screening campaigns conducted with [AutoDock Vina.](http://vina.scripps.edu)

This project supplements research performed as part of the [Research Scholars program at EACPHS](https://cphs.wayne.edu/pharmd/research-scholars.php), a concentration offered through the Doctor of Pharmacy program.

## Getting Started
1. Install AutoDock Vina according to the directions on the developer's website. For Arch Linux users, [an unofficial package is also available in the AUR.](https://aur.archlinux.org/packages/autodock-vina/)

2. Install [MGLTools.](https://ccsb.scripps.edu/mgltools/)

3. Install [Open Babel.](https://openbabel.org)

4. Obtain a 3D protein structure in `.PDBQT` format from a database such as [RCSB PDB.](https://www.rcsb.org) This format may not be available for direct download; if this is the case, use Open Babel to convert from an available format. An uncomplexed structure of the protein N5-CAIR mutase (modified from [PBD ID: 2ATE](https://www.rcsb.org/structure/2ATE)) is included in the `targets` directory as an example.

5. Place the prepared file in the `targets` directory and create a configuration file in the `config` directory which specifies this file as the receptor for docking. See `2ate.conf` for an example. Launch AutoDockTools using `$MGL_ROOT/bin/adt` and use the graphical interface to determine docking box coordinates for your target. Several guides and video walkthroughs of this process are available online.

6. Obtain 3D ligand structure files in `.PDBQT` format for screening from a database such as [ZINC.](https://zinc15.docking.org) Place these in the `ligands` directory. NitroAIR ([CID: 135398647](https://pubchem.ncbi.nlm.nih.gov/compound/135398647)), a ligand which forms a known complex with N5-CAIR mutase, is included in the `ligands` directory as an example. Two shell scripts, `zinc15_download.sh` and `mirror_download.sh` are included to automate downloading catalogs from zinc15.docking.org and files.docking.org respectively.

7. Run `arrange_ligands.sh ##` to split ligand files into a specified number of subdirectories optimized for parallel processing (for example, `arrange_ligands.sh 100` will organize ligands into 100 subdirectories).

7. Run `convert_ligands.sh` to automatically convert downloaded ligands into .PDBQT format and prepare files for docking. AutoDock Vina and Open Babel must be installed prior to running this script.

8. Modify `run_local.sh` (or `run_parallel.sh` if using a PBS-based HPC cluster) to reference the correct configuration file for your target receptor protein. Execute the script. Be aware that screening a large number of compounds will take a long time. When run locally, a log file containing binding energies for each complex will be generated in `log`. When run on an HPC cluster, PBS will generate log files automatically.

9. Execute `vina_screen_get_info.py`. This will print the filename, ZINC ID, and binding energy of every docked structure in the `results` directory. This information can be redirected to a text file if desired; for example, a text file `results_info.txt` can be generated using the command `vina_screen_get_info.py > results_info.txt`.

    **Note:** This is a Python 2 script. It will not work if run using Python 3.

10. For additional analysis including ranking and filtering by binding site, use [Raccoon2.](http://autodock.scripps.edu/resources/raccoon2/) Launch Raccoon2 using `$MGL_ROOT/bin/cadd`. From the Analysis tab, select `Process directory (Vina)` under `Docking results`. Select the `result` directory in the first window, then the desired target receptor from the `targets` directory in the second window. The results from Vina will be processed and an analysis log file will be generated.
