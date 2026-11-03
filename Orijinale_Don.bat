@echo off
chcp 65001 >nul
title Xiaomi 17 Pro - Fabrika Ses Ayarlarina Geri Donus
echo ============================================================================
echo   Xiaomi 17 Pro (pandora) - Fabrika Ses Ayarlarina Donus Araci
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
        echo [HATA] adb.exe bulunamadi! Lutfen Android Platform Tools ^(adb.exe^) kurun veya bu klasore kopyalayin.
        pause
        exit /b 1
    )
)

echo [1/2] Telefon baglantisi bekleniyor...
"%ADB_PATH%" wait-for-device

echo [2/2] Ses modulu kaldiriliyor ve fabrika ayarlarina donuluyor...
"%ADB_PATH%" shell "su -c 'umount -l /odm/etc/audio_policy_engine_stream_volumes_mi.xml 2>/dev/null; umount -l /odm/etc/audio/audio_effects_config.json 2>/dev/null; rm -rf /data/adb/modules/xiaomi17pro_bt_audio_fix; rm -f /data/adb/modules/tinymixbinaryinstaller/audio_policy_engine_stream_volumes_mi.xml /data/adb/modules/tinymixbinaryinstaller/post-fs-data.sh /data/adb/modules/tinymixbinaryinstaller/service.sh; pm enable com.android.musicfx >/dev/null 2>&1; pm enable com.miui.misound >/dev/null 2>&1; killall audioserver'"

echo.
echo ============================================================================
echo   Tamamlandi! Cihaz tamamen orijinal fabrika ses ayarlarina dondu.
echo ============================================================================
pause
