@echo off
chcp 65001 >nul
title Xiaomi 17 Pro (pandora) - Restore Factory Audio Settings
echo ============================================================================
echo   Xiaomi 17 Pro (pandora) - Factory Audio Settings Restore Tool
echo ============================================================================
echo.

set "ADB_PATH=adb"
where adb >nul 2>nul
if %errorlevel% neq 0 (
    if exist "%~dp0adb.exe" (
        set "ADB_PATH=%~dp0adb.exe"
    ) else if exist "C:\Users\gokse\Downloads\platform-tools-latest-windows\platform-tools\adb.exe" (
        set "ADB_PATH=C:\Users\gokse\Downloads\platform-tools-latest-windows\platform-tools\adb.exe"
    ) else (
        echo [ERROR] adb.exe not found! Please install Android Platform Tools or place adb.exe in this folder.
        pause
        exit /b 1
    )
)

echo [1/2] Waiting for device connection...
"%ADB_PATH%" wait-for-device

echo [2/2] Removing module and restoring factory audio configuration...
"%ADB_PATH%" shell "su -c 'umount -l /odm/etc/audio_policy_engine_stream_volumes_mi.xml 2>/dev/null; umount -l /odm/etc/audio/audio_effects_config.json 2>/dev/null; rm -rf /data/adb/modules/xiaomi17pro_bt_audio_fix; rm -f /data/adb/modules/tinymixbinaryinstaller/audio_policy_engine_stream_volumes_mi.xml /data/adb/modules/tinymixbinaryinstaller/post-fs-data.sh /data/adb/modules/tinymixbinaryinstaller/service.sh; pm enable com.android.musicfx >/dev/null 2>&1; pm enable com.miui.misound >/dev/null 2>&1; killall audioserver'"

echo.
echo ============================================================================
echo   Done! Device audio configuration has been restored to 100%% factory stock.
echo ============================================================================
pause
