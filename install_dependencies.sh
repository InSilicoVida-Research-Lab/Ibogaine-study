#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if running with sudo
check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        if [ -n "$SUDO_USER" ]; then
            # Running with sudo
            REAL_USER=$SUDO_USER
            REAL_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
        else
            # Running as root
            echo -e "${RED}[!] Please run this script as a normal user, not as root${NC}"
            exit 1
        fi
    else
        # Running as normal user
        REAL_USER=$USER
        REAL_HOME=$HOME
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

print_error() {
    echo -e "${RED}[!] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Function to check system
check_system() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        print_error "Cannot detect OS"
        exit 1
    fi
}

# Create installation directory
setup_directories() {
    INSTALL_DIR="$REAL_HOME/molecular_docking_tools"
    mkdir -p "$INSTALL_DIR"
    chown -R $REAL_USER:$REAL_USER "$INSTALL_DIR"
}

# Function to install system dependencies
install_system_dependencies() {
    print_status "Installing system dependencies..."
    
    case $OS in
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y wget python3 python3-pip build-essential \
                                  openbabel pymol python3-tk tcsh expect
            ;;
        fedora)
            sudo dnf install -y wget python3 python3-pip gcc gcc-c++ make \
                              openbabel pymol python3-tkinter tcsh expect
            ;;
        centos|rhel)
            sudo yum install -y wget python3 python3-pip gcc gcc-c++ make \
                              openbabel pymol python3-tkinter tcsh expect
            ;;
        *)
            print_error "Unsupported operating system"
            exit 1
            ;;
    esac
}

# Rest of the functions remain the same...

# Main installation process
main() {
    print_status "Starting installation process..."
    
    check_sudo
    check_system
    setup_directories
    install_system_dependencies
    
    # Run the rest of the installation as the real user
    if [ "$EUID" -eq 0 ]; then
        su - $REAL_USER -c "cd $INSTALL_DIR && {
            $(declare -f install_autodock_vina)
            $(declare -f install_mgltools)
            $(declare -f install_python_dependencies)
            $(declare -f verify_installation)
            install_autodock_vina
            install_mgltools
            install_python_dependencies
            verify_installation
        }"
    else
        install_autodock_vina
        install_mgltools
        install_python_dependencies
        verify_installation
    fi
    
    print_status "Installation complete! Please restart your terminal or run 'source ~/.bashrc'"
}

# Run main function
main
