@echo off
REM Activate the virtual environment
IF EXIST .\venv (
    echo Activating virtual environment...
    call .\venv\Scripts\activate
)

REM Check if pip3 is available in the virtual environment
pip --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo "pip not found in the virtual environment, please check your setup."
    pause
    exit /b
)

REM Install the specified Python packages
echo Installing Python packages: scipy, pillow, tensorflow, opencv-python...
pip install scipy pillow tensorflow opencv-python

REM Completion message
echo Installation complete!
pause
