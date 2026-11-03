#!/system/bin/sh
ui_print "- Xiaomi 17 Pro Bluetooth Ses Yukseltme Modulu kuruluyor..."
set_perm "$MODPATH/audio_policy_engine_stream_volumes_mi.xml" 0 0 0644 u:object_r:vendor_configs_file:s0
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
pm disable-user --user 0 com.android.musicfx >/dev/null 2>&1
pm disable-user --user 0 com.miui.misound >/dev/null 2>&1
settings put global audio_safe_volume_state 2 >/dev/null 2>&1
settings put secure audio_safe_volume_state 2 >/dev/null 2>&1
ui_print "- Kurulum tamamlandi! Yeniden baslatmaniz onerilir."