@echo off
setlocal

REM Miniconda installation path
set "MINICONDA_PATH=%USERPROFILE%\miniconda3"

REM Environment name to be created
set "ENV_NAME=py310_develop"

REM Python version to be installed
set "PYTHON_VERSION=3.10.13"

REM Project directory
set "PROJECT_DIR=%CD%"

REM Check if Miniconda is already installed
if exist "%MINICONDA_PATH%" (
    echo Miniconda is already installed at %MINICONDA_PATH%
) else (
    echo Miniconda is not installed, starting installation...
    REM Download Miniconda installer
    powershell -Command "Invoke-WebRequest -Uri https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe -OutFile miniconda.exe"
    REM Run the installer
    start /wait "" "miniconda.exe" /InstallationType=JustMe /RegisterPython=0 /S /D=%MINICONDA_PATH%
    echo Miniconda installation completed
)

REM Ensure conda is available in the current shell
set "PATH=%MINICONDA_PATH%\Scripts;%PATH%"

REM Run conda init if it hasn't been run yet
call conda init

REM Check if the specified Python environment already exists
call conda env list | findstr /i "%ENV_NAME%" >nul
if %errorlevel% == 0 (
    echo Conda environment %ENV_NAME% already exists
) else (
    echo Conda environment %ENV_NAME% does not exist, creating it...
    REM Create Python environment
    call conda create -y -n %ENV_NAME% python=%PYTHON_VERSION%
    echo Conda environment %ENV_NAME% created
)

REM Activate Python environment and run subsequent commands in the activated environment
call "%MINICONDA_PATH%\Scripts\activate.bat" %ENV_NAME%

REM Navigate to the project directory
echo cd %PROJECT_DIR% and use python version %PYTHON_VERSION%
cd %PROJECT_DIR%

REM Install additional requirements from requirements.txt
echo Installing additional requirements from requirements.txt...
pip install -r requirements.txt
echo Additional requirements installed successfully

:menu
echo.
echo Select the script to run:
echo 1. Run snapshot.py
echo 2. Run train.py
echo 3. Run predict.py
echo 4. Exit
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" (
    echo Running snapshot.py...
    python snapshot.py
    goto menu
) else if "%choice%"=="2" (
    echo Running train.py...
    python train.py
    goto menu
) else if "%choice%"=="3" (
    echo Running predict.py...
    python predict.py
    goto menu
) else if "%choice%"=="4" (
    goto end
) else (
    echo Invalid choice, please select again.
    goto menu
)

:end
echo Exiting...

endlocal

REM Exit the script
exit /b 0