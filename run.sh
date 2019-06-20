# Run the docking simulation.
# TODO: Set up a parallel processing batch script that screens all compounds in ligand/ against a specified enzyme in protein/

vina --config config/2ate_conf.txt --log log/2ate_log.txt
