#!/bin/bash

port=$1
micropyserver=$2
utils=$3
mainFile=$4

pythonExe="python"
pipExe="pip"

# 检查 Python 是否已安装
if [ "$(command -v python3)" ]; then
    echo "Python3 已安装，版本为 $(python3 --version)"
    pythonExe="python3"
    pipExe="pip3"
elif [ "$(command -v python)" ]; then
      echo "Python 已安装，版本为 $(python --version)"
      pythonExe="python"
      pipExe="pip"
elif [ "$(command -v py)" ]; then
    echo "Python 已安装，版本为 $(py --version)"
    pythonExe="py"
else
    echo "Python 未安装，请前往 https://www.python.org/downloads/ 下载并安装 Python。"
    exit 1
fi

# 检查 Adafruit-ampy 是否已安装
if [ "$(command -v ampy)" ]; then
    echo "Adafruit-ampy 已安装，版本为 $(ampy --version)"
else
    echo "Adafruit-ampy 未安装，正在安装..."
    $pythonExe -m pip install Adafruit-ampy
fi

# 检查 PySerial 是否已安装
if $pythonExe -c "import serial" &>/dev/null; then
    echo "PySerial 已安装，版本为 $($pythonExe -c "import serial; print(serial.VERSION)")"
else
    echo "PySerial 未安装，正在安装..."
    $pythonExe -m pip install pyserial
fi

$pythonExe $port $micropyserver $utils $mainFile
