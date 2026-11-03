#!/system/bin/sh
MODDIR=${0%/*}
if [ -f "$MODDIR/audio_policy_engine_stream_volumes_mi.xml" ]; then
    chmod 0644 "$MODDIR/audio_policy_engine_stream_volumes_mi.xml" 2>/dev/null
    chown 0:0 "$MODDIR/audio_policy_engine_stream_volumes_mi.xml" 2>/dev/null
    chcon u:object_r:vendor_configs_file:s0 "$MODDIR/audio_policy_engine_stream_volumes_mi.xml" 2>/dev/null
    mount -o bind "$MODDIR/audio_policy_engine_stream_volumes_mi.xml" /odm/etc/audio_policy_engine_stream_volumes_mi.xml 2>/dev/null
fi