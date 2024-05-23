# Teachable Machine Image Project
>
> This is a project to classify images using Teachable Machine

## Getting Started

### Prerequisites

- Miniconda

* Python 3.10.13
* Pip3
* Git
* A webcam

### Requirements

```
scipy==1.11.4
pillow==10.2.0
tensorflow==2.15.0
opencv-python==4.9.0.80
```

### Installation

1. Clone the repo

   ```sh
   git clone
   cd ./teachable-machine-image
   ```

2. Create a virtual environment

   ```sh
   # Create conda environment
   conda create -n py310_develop python=3.10.13 -y
   # Activate conda environment
   conda activate py310_develop
   ```
   
3. Install the requirements

   ~~***Double-click the install_packages script file, or run the following code from the command line.***~~

   ```sh
   pip3 install -r requirements.txt
   ```
   
4. Run the app

   ```sh
   python3 snapshot.py
   python3 train.py
   python3 predict.py
   ```

5. Stop the env

   ```shell
   # Deactivate conda environment
   conda deactivate
   ```
   
   
