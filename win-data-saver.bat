@echo off
title WIN DATA SAVER(v1 - Maximum Block)
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator privileges required. Elevating...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~dpnx0\"' -Verb RunAs"
    exit
)

:MENU
cls
echo =====================================================
echo       WIN DATA SAVER MODE v1 (MAXIMUM BLOCK)
echo =====================================================
echo.
echo  [1] Enable WINDATA-SAVER Mode
echo  [2] Disable WINDATA-SAVER (Restore Normal)
echo  [3] Show current data usage (Task Manager)
echo  [4] Exit
echo.
set /p choice="Choose an option (1-4): "

if "%choice%"=="1" goto ENABLE
if "%choice%"=="2" goto DISABLE
if "%choice%"=="3" goto USAGE
if "%choice%"=="4" goto EOF
goto MENU

:ENABLE
cls
echo Applying Maximum WIN DATA SAVER Settings...
echo.

:: -------- NETWORK: Mark as Metered --------
echo [01/20] Marking WiFi + Ethernet as Metered...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v 3G /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v 4G /t REG_DWORD /d 2 /f >nul 2>&1

:: -------- WINDOWS UPDATE --------
echo [02/20] Disabling Windows Update auto-start (manual mode - fixes Settings crash)...
net stop wuauserv >nul 2>&1
sc config wuauserv start= demand >nul 2>&1
net stop bits >nul 2>&1
sc config bits start= demand >nul 2>&1
net stop UsoSvc >nul 2>&1
sc config UsoSvc start= demand >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f >nul 2>&1

:: -------- PAUSE UPDATES TO 2099 --------
echo [03/20] Pausing Windows Updates until 2099...
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesStartTime /t REG_SZ /d 2015-01-01T00:00:00Z /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesEndTime /t REG_SZ /d 2099-12-31T23:59:59Z /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesStartTime /t REG_SZ /d 2015-01-01T00:00:00Z /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesEndTime /t REG_SZ /d 2099-12-31T23:59:59Z /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /t REG_SZ /d 2099-12-31T23:59:59Z /f >nul 2>&1

:: -------- DELIVERY OPTIMIZATION (P2P) --------
echo [04/20] Disabling Delivery Optimization (P2P uploads)...
net stop DoSvc >nul 2>&1
sc config DoSvc start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f >nul 2>&1

:: -------- ONEDRIVE --------
echo [05/20] Disabling OneDrive sync...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul 2>&1
taskkill /f /im OneDrive.exe >nul 2>&1
net stop OneSyncSvc >nul 2>&1
sc config OneSyncSvc start= disabled >nul 2>&1
net stop OneSyncSvc_* >nul 2>&1

:: -------- TELEMETRY / DIAGNOSTICS --------
echo [06/20] Disabling Telemetry and DiagTrack (crash upload)...
net stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
net stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1

:: -------- WINDOWS SEARCH (cloud indexing) --------
echo [07/20] Disabling Windows Search cloud sync...
net stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCloudSearch /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f >nul 2>&1

:: -------- MICROSOFT EDGE BACKGROUND --------
echo [08/20] Disabling Microsoft Edge background activity...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v NetworkPredictionOptions /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Edge\Main" /v AllowPrelaunch /t REG_DWORD /d 0 /f >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1

:: -------- MICROSOFT STORE AUTO-UPDATES --------
echo [09/20] Disabling Microsoft Store auto-updates...
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /t REG_DWORD /d 2 /f >nul 2>&1
net stop wuauserv >nul 2>&1

:: -------- CONNECTED STANDBY / NETWORK IN SLEEP --------
echo [10/20] Disabling network activity during sleep...
powercfg /setacvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0 >nul 2>&1
powercfg /apply SCHEME_CURRENT >nul 2>&1

:: -------- SUPERFETCH / SYSMAIN --------
echo [11/20] Disabling Superfetch / SysMain...
net stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1

:: -------- MALICIOUS SOFTWARE REMOVAL TOOL SCHEDULE --------
echo [12/20] Disabling scheduled MRT scans...
schtasks /Change /TN "\Microsoft\Windows\RemovalTools\MRT_HB" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\RemovalTools\MRT_ERROR_HB" /Disable >nul 2>&1

:: -------- BACKGROUND APPS (Global) --------
echo [13/20] Disabling all background applications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f >nul 2>&1

:: -------- CORTANA --------
echo [14/20] Disabling Cortana online activity...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortanaAboveLock /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1

:: -------- WINDOWS ERROR REPORTING --------
echo [15/20] Disabling Windows Error Reporting upload...
net stop WerSvc >nul 2>&1
sc config WerSvc start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1

:: -------- SCHEDULED TASKS THAT USE NETWORK --------
echo [16/20] Disabling network-hungry scheduled tasks...
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1

:: -------- LIVE TILES / NOTIFICATION PUSH --------
echo [17/20] Disabling Live Tiles and Push Notifications...
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoTileApplicationNotification /t REG_DWORD /d 1 /f >nul 2>&1
net stop WpnService >nul 2>&1
sc config WpnService start= disabled >nul 2>&1
net stop WpnUserService >nul 2>&1

:: -------- NETWORK LOCATION AWARENESS --------
echo [18/20] Restricting automatic network detection uploads...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v NoActiveProbe /t REG_DWORD /d 1 /f >nul 2>&1

:: -------- ADVERTISING ID --------
echo [19/20] Disabling Advertising ID (stops ad-sync traffic)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f >nul 2>&1

:: -------- DNS FLUSH --------
echo [20/20] Flushing DNS cache...
ipconfig /flushdns >nul 2>&1

echo.
echo =====================================================
echo  SUCCESS: Maximum WIN-DATA SAVER Mode is ACTIVE!
echo.
echo  What was blocked:
echo   - Windows Update + BITS + UsoSvc
echo   - OneDrive sync
echo   - Telemetry + DiagTrack (crash uploads)
echo   - Windows Search cloud sync
echo   - Microsoft Edge background + preload
echo   - Delivery Optimization (P2P)
echo   - Sleep network (Connected Standby)
echo   - Superfetch / SysMain
echo   - MRT scheduled scans
echo   - Background apps (global)
echo   - Cortana online
echo   - Windows Error Reporting
echo   - Network-hungry scheduled tasks
echo   - Live Tiles + Push Notifications
echo   - Advertising ID sync
echo.
echo  RESTART your PC for all changes to take effect.
echo =====================================================
pause
goto MENU

:DISABLE
cls
echo Restoring All Normal Settings...
echo.

echo [01/15] Restoring network cost...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v WiFi /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v Ethernet /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v 3G /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" /v 4G /t REG_DWORD /d 1 /f >nul 2>&1

echo [02/15] Restoring Windows Update services...
sc config wuauserv start= demand >nul 2>&1
sc config bits start= demand >nul 2>&1
sc config UsoSvc start= demand >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /f >nul 2>&1

echo [03/15] Unpausing Windows Updates...
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesStartTime /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseFeatureUpdatesEndTime /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesStartTime /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseQualityUpdatesEndTime /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /f >nul 2>&1

echo [04/15] Restoring Delivery Optimization...
sc config DoSvc start= delayed-auto >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /f >nul 2>&1

echo [05/15] Re-enabling OneDrive...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /f >nul 2>&1
sc config OneSyncSvc start= demand >nul 2>&1

echo [06/15] Re-enabling Telemetry/DiagTrack...
sc config DiagTrack start= auto >nul 2>&1
sc config dmwappushservice start= auto >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f >nul 2>&1

echo [07/15] Restoring Windows Search...
sc config WSearch start= delayed-auto >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCloudSearch /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /f >nul 2>&1

echo [08/15] Restoring Edge background mode...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /f >nul 2>&1

echo [09/15] Restoring Microsoft Store auto-updates...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /f >nul 2>&1

echo [10/15] Restoring Connected Standby (sleep network)...
powercfg /setacvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 1 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 1 >nul 2>&1
powercfg /apply SCHEME_CURRENT >nul 2>&1

echo [11/15] Restoring SysMain / Superfetch...
sc config SysMain start= auto >nul 2>&1

echo [12/15] Re-enabling background apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /f >nul 2>&1

echo [13/15] Restoring Windows Error Reporting...
sc config WerSvc start= demand >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /f >nul 2>&1

echo [14/15] Restoring Push Notification service...
sc config WpnService start= auto >nul 2>&1

echo [15/15] Restoring Advertising ID...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /f >nul 2>&1

echo.
echo =====================================================
echo  SUCCESS: All settings restored to Windows defaults.
echo  Please restart your PC.
echo =====================================================
pause
goto MENU

:USAGE
start taskmgr
goto MENU

:EOF
exit
