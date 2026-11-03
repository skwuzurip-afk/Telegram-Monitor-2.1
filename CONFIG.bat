@echo off
chcp 65001 >nul
setlocal EnableExtensions
cd /d "%~dp0"
title Telegram Monitor - CONFIG
color 07 >nul

set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"

set "PY=python"
where python >nul 2>nul
if errorlevel 1 (
    where py >nul 2>nul
    if errorlevel 1 (
        echo.
        echo Python was not found.
        echo Install Python 3.10 or newer from https://www.python.org/downloads/windows/
        echo During installation check "Add python.exe to PATH".
        echo.
        pause
        exit /b 1
    )
    set "PY=py -3"
)

%PY% -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 10) else 1)" >nul 2>nul
if errorlevel 1 (
    echo.
    echo Python 3.10 or newer is required.
    %PY% --version
    echo.
    pause
    exit /b 1
)

%PY% -c "import telethon, pystray, PIL" >nul 2>nul
if errorlevel 1 (
    echo.
    echo Installing required libraries. This may take a minute...
    %PY% -m pip install -r "LIB\requirements.txt"
    %PY% -c "import telethon" >nul 2>nul
    if errorlevel 1 (
        echo.
        echo Installation failed. Check your internet connection and try again.
        pause
        exit /b 1
    )
)

%PY% "LIB\main.py" config
set "EXIT_CODE=%ERRORLEVEL%"
if not "%EXIT_CODE%"=="0" (
    echo.
    echo CONFIG stopped with an error. See LOGS\monitor.log
    pause
)
endlocal & exit /b %EXIT_CODE%
