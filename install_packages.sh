#!/bin/bash

# Activate the virtual environment
if [ -d ./venv ]; then
    echo "Activating virtual environment..."
    source ./venv/bin/activate
fi

# Check if pip is available in the virtual environment
if ! command -v pip &> /dev/null
then
    echo "pip not found in the virtual environment, please check your setup."
    exit 1
fi

# Install the specified Python packages
echo "Installing Python packages: scipy, pillow, tensorflow, opencv-python..."
pip install scipy pillow tensorflow opencv-python

# Completion message
echo "Installation complete!"
