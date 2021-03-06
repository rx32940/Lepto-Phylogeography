import csv 
import sys
import pandas as pd

# read in csv into dict, query from bash, return species name to bash
# work with picardeau_assemble_pipeline

biosample=sys.argv[1]
species_dict=sys.argv[2] # provide path to the dict file in the argument
data = pd.read_csv(species_dict,header=None, sep=",",index_col=0)
species_dict = data.to_dict()[1]
dir_name=str(species_dict[biosample].split(" ")[1])
print(dir_name)

