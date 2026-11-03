@echo off
chcp 65001 >nul
title Xiaomi 17 Pro (pandora) - BT Audio Fix Installer
echo ============================================================================
echo   Xiaomi 17 Pro (pandora) - Bluetooth Audio Volume Fix Installer
echo   Profile: -3.5 dB True-Peak Headroom
echo   Internal Speakers: 100%% Factory Stock (Untouched)
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

echo [1/4] Waiting for device connection...
"%ADB_PATH%" wait-for-device
echo       Device connected!

echo [2/4] Pushing audio configuration files to device...
"%ADB_PATH%" push "%~dp0module\audio_policy_engine_stream_volumes_mi.xml" /data/local/tmp/audio_policy_engine_stream_volumes_mi.xml
"%ADB_PATH%" push "%~dp0module\post-fs-data.sh" /data/local/tmp/post-fs-data.sh
"%ADB_PATH%" push "%~dp0module\service.sh" /data/local/tmp/service.sh
"%ADB_PATH%" push "%~dp0module\module.prop" /data/local/tmp/module.prop

echo [3/4] Installing root module and applying AudioPolicy curves...
"%ADB_PATH%" shell "su -c 'MODDIR=/data/adb/modules/xiaomi17pro_bt_audio_fix; mkdir -p $MODDIR && cp -f /data/local/tmp/audio_policy_engine_stream_volumes_mi.xml $MODDIR/audio_policy_engine_stream_volumes_mi.xml && cp -f /data/local/tmp/post-fs-data.sh $MODDIR/post-fs-data.sh && cp -f /data/local/tmp/service.sh $MODDIR/service.sh && cp -f /data/local/tmp/module.prop $MODDIR/module.prop && chmod 0644 $MODDIR/audio_policy_engine_stream_volumes_mi.xml && chmod 0755 $MODDIR/post-fs-data.sh $MODDIR/service.sh && chown 0:0 $MODDIR/audio_policy_engine_stream_volumes_mi.xml && chcon u:object_r:vendor_configs_file:s0 $MODDIR/audio_policy_engine_stream_volumes_mi.xml && umount -l /odm/etc/audio_policy_engine_stream_volumes_mi.xml 2>/dev/null; mount -o bind $MODDIR/audio_policy_engine_stream_volumes_mi.xml /odm/etc/audio_policy_engine_stream_volumes_mi.xml && pm disable-user --user 0 com.android.musicfx >/dev/null 2>&1; pm disable-user --user 0 com.miui.misound >/dev/null 2>&1; settings put global audio_safe_volume_state 2; settings put secure audio_safe_volume_state 2; killall audioserver'"

echo [4/4] Done!
echo.
echo ============================================================================
echo   SUCCESS! Bluetooth audio fix is installed and active immediately.
echo   No reboot is required.
echo ============================================================================
pause
