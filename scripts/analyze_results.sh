#!/bin/bash

# Analyze docking results
echo "Analyzing docking results..."
grep "REMARK VINA RESULT" ../output/poses/*.pdbqt > ../output/analysis/all_scores.txt
sort -k 4 -n ../output/analysis/all_scores.txt > ../output/analysis/sorted_scores.txt
