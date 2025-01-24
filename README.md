# Molecular Docking Setup with AutoDock Vina

## Directory Structure
- input/
  - ligands/ (PDB, MOL2, SDF formats)
  - receptor/
- output/
  - poses/
  - scores/
  - analysis/
- config/
- scripts/
- logs/

## Usage
1. Place receptor PDB file in input/receptor/
2. Place ligand files in appropriate input/ligands/ subdirectory
3. Run preparation scripts:
   - ./scripts/prep_receptor.sh <receptor.pdb>
   - ./scripts/prep_ligands.sh <ligand_directory>
4. Run docking:
   - ./scripts/dock.sh <receptor.pdbqt> <ligand.pdbqt>
5. Analyze results:
   - ./scripts/analyze_results.sh

## Requirements
- AutoDock Vina
- MGLTools (for preparation scripts)
