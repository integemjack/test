#!/bin/bash

# Function to detect the operating system and architecture
detect_os_arch() {
    local unameOut
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     os=Linux;;
        Darwin*)    os=Mac;;
        *)          os="UNKNOWN:${unameOut}"
    esac

    arch=$(uname -m)
    case "${arch}" in
        x86_64) arch="x86_64";;
        arm64) arch="aarch64";;
        *) arch="UNKNOWN:${arch}"
    esac
}

# Function to download and install Miniconda
install_miniconda() {
    if [ "$os" == "Linux" ]; then
        if [ "$arch" == "x86_64" ]; then
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
        elif [ "$arch" == "aarch64" ]; then
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
        fi
    elif [ "$os" == "Mac" ]; then
        if [ "$arch" == "x86_64" ]; then
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
        elif [ "$arch" == "aarch64" ]; then
            miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
        fi
    else
        echo "Unsupported OS or architecture"
        exit 1
    fi

    curl -o miniconda.sh -O $miniconda_url
    bash miniconda.sh -b -p $MINICONDA_PATH
    echo "Miniconda installation completed"
    $MINICONDA_PATH/bin/conda init
    source ~/.bashrc
}

# Miniconda installation path
MINICONDA_PATH="$HOME/miniconda3"

# Environment name to be created
ENV_NAME="py310_develop"

# Python version to be installed
PYTHON_VERSION="3.10.13"

# Project directory (change this to the actual path if different)
PROJECT_DIR="$(pwd)/teachable-machine-image"

# Detect OS and architecture
detect_os_arch

# Check if Miniconda is already installed
if [ -d "$MINICONDA_PATH" ]; then
    echo "Miniconda is already installed at $MINICONDA_PATH"
else
    echo "Miniconda is not installed, starting installation..."
    install_miniconda
fi

# Ensure conda is available in the current shell
export PATH="$MINICONDA_PATH/bin:$PATH"

# Check if the specified Python environment already exists
if conda env list | grep -q "$ENV_NAME"; then
    echo "Conda environment $ENV_NAME already exists"
else
    echo "Conda environment $ENV_NAME does not exist, creating it..."
    # Create Python environment
    conda create -y -n $ENV_NAME python=$PYTHON_VERSION
    echo "Conda environment $ENV_NAME created"
fi

# Activate Python environment and run subsequent commands in the activated environment
source $MINICONDA_PATH/bin/activate $ENV_NAME

# Install the required packages with compatible versions
echo "Installing required packages..."
pip install scipy==1.11.4 pillow==10.2.0 tensorflow==2.16.0 opencv-python==4.9.0.80
echo "Packages installed successfully"

# Navigate to the project directory
cd $PROJECT_DIR

# Install additional requirements from requirements.txt
echo "Installing additional requirements from requirements.txt..."
pip install -r requirements.txt
echo "Additional requirements installed successfully"

echo "Running train.py..."
python train.py

# Menu for running project scripts
# while true; do
#     echo
#     echo "Select the script to run:"
#     echo "1. Run snapshot.py"
#     echo "2. Run train.py"
#     echo "3. Run predict.py"
#     echo "4. Exit"
#     echo
#     read -p "Enter your choice: " choice

#     case $choice in
#         1)
#             echo "Running snapshot.py..."
#             python snapshot.py
#             ;;
#         2)
#             echo "Running train.py..."
#             python train.py
#             ;;
#         3)
#             echo "Running predict.py..."
#             python predict.py
#             ;;
#         4)
#             break
#             ;;
#         *)
#             echo "Invalid choice, please select again."
#             ;;
#     esac
# done

echo "Exiting..."
