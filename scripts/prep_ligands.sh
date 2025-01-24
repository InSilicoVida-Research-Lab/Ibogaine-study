#!/bin/bash

# Directory containing ligand PDB files
LIGAND_DIR="$1"

if [ ! -d "$LIGAND_DIR" ]; then
    echo "Usage: ./prep_ligands.sh <ligand_directory>"
    exit 1
fi

# Convert all PDB files to PDBQT
for ligand in $LIGAND_DIR/*.pdb; do
    if [ -f "$ligand" ]; then
        prepare_ligand4.py -l "$ligand" -o "../input/ligands/$(basename $ligand .pdb).pdbqt"
    fi
done
