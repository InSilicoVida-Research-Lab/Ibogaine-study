#!/bin/bash

# Check if required files exist
if [ ! -f \$1 ] || [ ! -f \$2 ]; then
    echo "Usage: ./dock.sh <receptor.pdbqt> <ligand.pdbqt>"
    exit 1
fi

# Create log file
LOG_FILE="../logs/docking_\$(date +%Y%m%d_%H%M%S).log"

# Run Vina
vina --config ../config/config.txt \
     --receptor \$1 \
     --ligand \$2 \
     --log \$LOG_FILE

# Extract scores
grep "REMARK VINA RESULT" ../output/poses/docked.pdbqt > ../output/scores/scores_\$(basename \$2 .pdbqt).txt

echo "Docking completed. Check logs at \$LOG_FILE"
