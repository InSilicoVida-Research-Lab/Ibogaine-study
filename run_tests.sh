#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Function to print test results
print_test_result() {
    local test_name=$1
    local result=$2
    local message=$3
    
    ((TESTS_TOTAL++))
    
    if [ "$result" -eq 0 ]; then
        echo -e "${GREEN}✓ $test_name${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ $test_name${NC}"
        echo -e "${RED}  Error: $message${NC}"
        ((TESTS_FAILED++))
    fi
}

# Function to check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${BLUE}Starting tests...${NC}\n"

# Test 1: Directory Structure
echo -e "${YELLOW}Testing Directory Structure:${NC}"

dirs=(
    "input/ligands/pdb"
    "input/ligands/mol2"
    "input/ligands/sdf"
    "input/receptor"
    "output/poses"
    "output/scores"
    "output/analysis"
    "config"
    "scripts"
    "logs"
)

for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        print_test_result "Directory $dir exists" 0
    else
        print_test_result "Directory $dir exists" 1 "Directory not found"
    fi
done

# Test 2: Required Scripts
echo -e "\n${YELLOW}Testing Required Scripts:${NC}"

scripts=(
    "scripts/dock.sh"
    "scripts/prep_receptor.sh"
    "scripts/prep_ligands.sh"
    "scripts/analyze_results.sh"
)

for script in "${scripts[@]}"; do
    if [ -x "$script" ]; then
        print_test_result "Script $script exists and is executable" 0
    else
        print_test_result "Script $script exists and is executable" 1 "Script not found or not executable"
    fi
done

# Test 3: Configuration Files
echo -e "\n${YELLOW}Testing Configuration Files:${NC}"

if [ -f "config/config.txt" ]; then
    if grep -q "receptor =" "config/config.txt" && \
       grep -q "center_x =" "config/config.txt" && \
       grep -q "size_x =" "config/config.txt"; then
        print_test_result "Configuration file is valid" 0
    else
        print_test_result "Configuration file is valid" 1 "Missing required parameters"
    fi
else
    print_test_result "Configuration file exists" 1 "File not found"
fi

# Test 4: Dependencies
echo -e "\n${YELLOW}Testing Dependencies:${NC}"

dependencies=(
    "vina"
    "python3"
    "prepare_receptor4.py"
    "prepare_ligand4.py"
)

for dep in "${dependencies[@]}"; do
    if check_command "$dep"; then
        print_test_result "Dependency $dep is installed" 0
    else
        print_test_result "Dependency $dep is installed" 1 "Command not found"
    fi
done

# Test 5: Python Dependencies
echo -e "\n${YELLOW}Testing Python Dependencies:${NC}"

python3 << EOF
import sys

dependencies = [
    'numpy',
    'scipy',
    'biopython',
    'pandas',
    'matplotlib',
    'seaborn'
]

for dep in dependencies:
    try:
        __import__(dep)
        print(f"✓ {dep}")
    except ImportError:
        print(f"✗ {dep}")
        sys.exit(1)
