#!/system/bin/sh
MODDIR=${0%/*}
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 1
done

if ! grep -q "/odm/etc/audio_policy_engine_stream_volumes_mi.xml" /proc/mounts; then
    chcon u:object_r:vendor_configs_file:s0 "$MODDIR/audio_policy_engine_stream_volumes_mi.xml" 2>/dev/null
    mount -o bind "$MODDIR/audio_policy_engine_stream_volumes_mi.xml" /odm/etc/audio_policy_engine_stream_volumes_mi.xml 2>/dev/null
    killall audioserver 2>/dev/null
fi

pm disable-user --user 0 com.android.musicfx >/dev/null 2>&1
pm disable-user --user 0 com.miui.misound >/dev/null 2>&1
settings put global audio_safe_volume_state 2
settings put secure audio_safe_volume_state 2