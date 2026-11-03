@echo off
chcp 65001 >nul
setlocal EnableExtensions
cd /d "%~dp0"
title Telegram Monitor - background

set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"

set "PY=python"
where python >nul 2>nul
if errorlevel 1 (
    where py >nul 2>nul
    if errorlevel 1 (
        echo Python was not found. Install Python 3.10+ with "Add python.exe to PATH".
        pause
        exit /b 1
    )
    set "PY=py -3"
)

%PY% -c "import telethon, pystray, PIL" >nul 2>nul
if errorlevel 1 (
    echo Installing required libraries. This may take a minute...
    %PY% -m pip install -r "LIB\requirements.txt"
    %PY% -c "import telethon, pystray, PIL" >nul 2>nul
    if errorlevel 1 (
        echo Installation failed. Check your internet connection and try again.
        pause
        exit /b 1
    )
)

set "PYW="
where pythonw >nul 2>nul
if not errorlevel 1 set "PYW=pythonw"
if not defined PYW (
    where pyw >nul 2>nul
    if not errorlevel 1 set "PYW=pyw -3"
)
if not defined PYW (
    echo pythonw was not found. Reinstall Python with the standard options.
    pause
    exit /b 1
)

rem Without a window: only the tray icon stays. Exit via the tray menu.
start "" %PYW% "LIB\main.py" run --background
endlocal
exit /b 0
