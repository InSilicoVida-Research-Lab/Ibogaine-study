#!/bin/bash


# Check if input file exists

if [ ! -f $1 ]; then
    echo "Usage: ./prep_receptor.sh <receptor.pdb>"
    exit 1
fi

# Convert PDB to PDBQT

prepare_receptor4.py -r $1 -o ../input/receptor/$(basename $1 .pdb).pdbqt
