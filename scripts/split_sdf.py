#!/usr/bin/python

# This script downloaded from Pankaj Mishra on ResearchGate.
# https://www.researchgate.net/profile/Pankaj_Mishra5

# Two arguments: Base filename, number of ligands per split file

import sys
f= sys.argv[1]
split_number = int(sys.argv[2])
number_of_sdfs = split_number
i=0
j=0
f2=open(f+'_'+str(j)+'.sdf','w')
for line in open(f+'.sdf'):
	f2.write(line)
	if line[:4] == "$$$$":
		i+=1
	if i > number_of_sdfs:
		number_of_sdfs += split_number
		f2.close()
		j+=1
		f2=open(f+'_'+str(j)+'.sdf','w')
print(i)

