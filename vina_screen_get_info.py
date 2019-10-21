#! /usr/bin/python2.7

# Print the filename, ZINC ID, and binding energy for every file within a directory of AutoDock Vina results.

# This is a modified version of a script written by the authors of [AutoDock Vina.](https://vina.scripps.edu)
# The original is available at https://vina.scripps.edu/vina_screen_get_top.py

# Trott O, Olson AJ.
# AutoDock Vina: improving the speed and accuracy of docking
# with a new scoring function, efficient optimization and
# multithreading. J. Comput. Chem. 2010;31(2):455-461.
# doi:10.0112/jcc.21334

import os
import sys
import glob


def doit():
    os.chdir("./results")
    file_names = glob.glob('*.pdbqt')
    everything = []
    failures = []
    for file_name in file_names:
        result_file = open(file_name)
        lines = result_file.readlines()
        result_file.close()
        try:
            result = float(lines[1].strip().split(':')[1].split()[0])
            zinc = lines[2].strip().split('=')[1]
            everything.append([file_name, zinc, result])
        except:
            failures.append(file_name)
    everything.sort(lambda x, y: cmp(x[0], y[0]))
    for i in everything:
        print i[0], "\t", i[1], "\t", i[2]


if __name__ == '__main__':
    doit()
