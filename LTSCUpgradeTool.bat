@echo off
setlocal enabledelayedexpansion

:: ==============================================================
:: LTSCUpgradeTool.bat
:: Purpose: Make Windows appear as a selected LTSC edition
::          for in-place upgrade recognition.
:: ==============================================================

:: Print header and full disclaimer
echo ==============================================================
echo           Windows LTSC Registry Update Tool
echo ==============================================================
echo.
echo GOAL:
echo   Prepare your current Windows for an in-place upgrade to LTSC
echo   by modifying registry keys safely.
echo.
echo DISCLAIMER:
echo   Unofficial. You still need:
echo     - a "Totally" legally obtained and valid LTSC license key
echo     - the matching LTSC ISO Edition
echo     - possably system backup before running this script
echo.
echo ISO LINKS:
echo   Enterprise LTSC: https://drive.massgrave.dev/en_windows_10_iot_enterprise_ltsc_2019_x64_dvd_a1aa819f.iso
echo   IoT Enterprise LTSC: https://drive.massgrave.dev/en-us_windows_10_iot_enterprise_ltsc_2021_x64_dvd_257ad90f.iso
echo ==============================================================
echo.

:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Please run this script as Administrator.
    pause
    exit /b 1
)

:: Edition selection
echo Which Windows 10 LTSC edition do you want to modify for?
echo   1) Enterprise LTSC (enterprise desktop, long-term stability, fewer feature updates)
echo   2) IoT Enterprise LTSC (embedded/IoT devices, minimal feature changes, long-term support)
set /p choice="Enter 1 or 2: "

:: Set registry values
if "%choice%"=="1" (
    set EditionName=Windows 10 Enterprise LTSC
    set EditionID=EnterpriseS
    set CurrentBuild=17763
    set CurrentBuildNumber=17763
    set BuildLabEx=17763.4048.amd64fre.ltcm.190902-1700
    set ReleaseId=1809
    set DisplayVersion=2019 LTSC
) else if "%choice%"=="2" (
    set EditionName=Windows 10 IoT Enterprise LTSC
    set EditionID=IoTEnterpriseS
    set CurrentBuild=19044
    set CurrentBuildNumber=19044
    set BuildLabEx=19044.2364.amd64fre.vb_release_ltcm.210914-1433
    set ReleaseId=21H2
    set DisplayVersion=2021 IoT LTSC
) else (
    echo Invalid selection. Exiting.
    pause
    exit /b 1
)

:: Backup registry
echo.
echo Selected edition: %EditionName%
echo Backing up current registry...
set BACKUP_DIR=%USERPROFILE%\Desktop\LTSC_upgrade_tool_registry_backup_%date:~10,4%%date:~4,2%%date:~7,2%
mkdir "%BACKUP_DIR%" >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" "%BACKUP_DIR%\CurrentVersionBackup.reg" /y
if %errorlevel% neq 0 (
    echo Backup failed. Exiting.
    pause
    exit /b 1
)

:: Apply registry edits with before → after messages
echo.
echo Changing registry values... It should not take too long 
for %%K in EditionID ProductName CurrentBuild CurrentBuildNumber BuildLabEx ReleaseId DisplayVersion InstallationType ProductId (
    :: Get old value
    for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v %%K 2^>nul ^| find "%%K"') do set oldval=%%B
    :: Set new value
    if "%%K"=="EditionID" set newval=%EditionID%
    if "%%K"=="ProductName" set newval=%EditionName%
    if "%%K"=="CurrentBuild" set newval=%CurrentBuild%
    if "%%K"=="CurrentBuildNumber" set newval=%CurrentBuildNumber%
    if "%%K"=="BuildLabEx" set newval=%BuildLabEx%
    if "%%K"=="ReleaseId" set newval=%ReleaseId%
    if "%%K"=="DisplayVersion" set newval=%DisplayVersion%
    if "%%K"=="InstallationType" set newval=Client
    if "%%K"=="ProductId" set newval=00330-80000-00000-AAOEM
    :: Print change
    echo Changing %%K from "!oldval!" to "!newval!"
    :: Apply change
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v %%K /t REG_SZ /d "!newval!" /f >nul
)

:: Randomize number of "very"s between 2 and 10 for NEXT STEPS
set /a vcount=%random% %% 9 + 2
set verys=
for /L %%i in (1,1,%vcount%) do set verys=!verys! very

:: NEXT STEPS
echo.
echo Registry patch complete. Your system now appears as %EditionName%.
echo Backup saved at: %BACKUP_DIR%
echo.
echo NEXT STEPS:
echo 1) Be patient, the Windows installer thing will take!%verys%! long
echo 2) Reboot your PC.
echo 3) Mount the LTSC ISO for the edition you selected.
echo 4) Open it in Explorer.
echo 5) Run setup.exe in Windows, choose "Keep files and apps".
echo 6) Activate using your valid LTSC key.
echo.
echo NOTE: If the installer fails due to build/edition mismatch, restore the backup:
echo    reg import "%BACKUP_DIR%\CurrentVersionBackup.reg"
pause
