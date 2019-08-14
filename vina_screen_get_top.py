#! /usr/bin/python2.7
# Find the lowest binding energies within a set of AutoDock output files.

# This script was written by the authors of [AutoDock Vina.](https://vina.scripps.edu)
# It is available at https://vina.scripps.edu/vina_screen_get_top.py

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

import sys
import glob

def doit(n):
    file_names = glob.glob('results/*.pdbqt')
    everything = []
    failures = []
    print 'Found', len(file_names), 'pdbqt files'
    for file_name in file_names:
        file = open(file_name)
        lines = file.readlines()
        file.close()
        try:
            line = lines[1]
            result = float(line.split(':')[1].split()[0])
            everything.append([result, file_name])
        except:
            failures.append(file_name)
    everything.sort(lambda x,y: cmp(x[0], y[0]))
    part = everything[:n]
    for p in part:
        print p[1],
    print
    if len(failures) > 0:
        print 'WARNING:', len(failures), 'pdbqt files could not be processed'

if __name__ == '__main__':
    doit(int(sys.argv[1]))
