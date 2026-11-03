# 🎧 Xiaomi 17 Pro (`pandora`) — Bluetooth Audio Volume Fix (HyperOS / Xiaomi.eu)

![Device](https://img.shields.io/badge/Device-Xiaomi%2017%20Pro%20(pandora)-orange?style=for-the-badge&logo=xiaomi)
![OS](https://img.shields.io/badge/OS-HyperOS%20%7C%20Xiaomi.eu-blue?style=for-the-badge&logo=android)
![Root](https://img.shields.io/badge/Root-APatch%20%7C%20Magisk%20%7C%20KernelSU-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=for-the-badge)

A systemless root module (**APatch / Magisk / KernelSU**) and one-click ADB installer that permanently resolves the **low Bluetooth headphone (`A2DP`) volume issue** on the **Xiaomi 17 Pro (`pandora`)** running HyperOS / Xiaomi.eu ROMs, caused by EU (`CE`) volume caps and Android audio effect pre-attenuation.

> [!IMPORTANT]
> This module **only** modifies Bluetooth (`A2DP`), USB, and wired headphone (`HEADSET`) volume curves. It leaves the phone's **internal stereo speakers (`SPEAKER`) and hardware codec gains at 100% factory stock**.

---

## 🔍 Root Cause Analysis

On Xiaomi.eu and Global/EEA HyperOS ROMs, Bluetooth audio output is simultaneously throttled by **two separate software layers**:

1. **AudioPolicy EU (`CE`) Volume Curve Cap (`-6.5 dB`):**
   - Inside `/odm/etc/audio_policy_engine_stream_volumes_mi.xml`, the `DEVICE_CATEGORY_A2DP_CE` profile caps maximum volume (`index 100`) at **`-650` (`-6.5 dB`)**.
   - When Bluetooth **AVRCP Absolute Volume** is enabled, Xiaomi's `AudioPolicyManagerImpl::computeVolumeForCE` applies this `-6.5 dB` attenuation as a constant digital ceiling (`PortVol dB`) across all volume steps.
2. **Android `MusicFX` / `MiSound` Effect Chain Pre-Cut (`-10 dB`):**
   - Whenever media players (Spotify, YouTube Music, Apple Music, etc.) open an audio session, `com.android.musicfx` and `com.miui.misound` attach to the stream and apply an automatic **`-10 dB` headroom pre-cut** for equalizer processing.

Combined, these two restrictions reduce perceived Bluetooth headphone loudness by roughly **50–60%** compared to Windows or iOS devices.

---

## ⚙️ What This Module Changes

| Component | Factory Stock | Patched Value | Description |
| :--- | :---: | :---: | :--- |
| **`DEVICE_CATEGORY_A2DP_CE`** | `-650` (`-6.5 dB`) | **`-350` (`-3.5 dB`)** | Raises EU Bluetooth ceiling to a safe True-Peak headroom limit |
| **`DEVICE_CATEGORY_A2DP`** | `-650` (`-6.5 dB`) | **`-350` (`-3.5 dB`)** | Aligns standard A2DP curve and smooths intermediate logarithmic steps |
| **`DEVICE_CATEGORY_A2DP_SPATIALIZER_CE`** | `-650` (`-6.5 dB`) | **`-350` (`-3.5 dB`)** | Raises Spatial Audio Bluetooth volume ceiling |
| **`DEVICE_CATEGORY_HEADSET_CE` / `USB_CE`** | `-900` (`-9.0 dB`) | **`-350` (`-3.5 dB`)** | Removes severe `-9.0 dB` EU cap on Type-C & wired headphones |
| **`MusicFX` & `MiSound`** | Enabled (`-10 dB` cut) | **Disabled** | Eliminates the `-10 dB` effect-chain pre-attenuation |
| **`audio_safe_volume_state`** | Enabled (`3`) | **Bypassed (`2`)** | Disables periodic EU safe-volume warnings and automatic volume drops |
| **`DEVICE_CATEGORY_SPEAKER`** | Factory Stock | **Factory Stock** | Internal phone speakers remain 100% untouched |

---

## 📂 Repository Structure

```text
├── pandora_btaudiofix.zip                      # Flashable module for APatch / Magisk / KernelSU
├── setup.bat                                   # One-click Windows ADB installer (no reboot required)
├── reset.bat                                   # One-click Windows ADB uninstaller (restores factory stock)
├── audio_policy_engine_stream_volumes_mi.xml   # Patched AudioPolicy volume curves configuration
└── module/                                     # Module source files (post-fs-data.sh, service.sh, module.prop)
```

---

## 🚀 Installation

### Prerequisites
- **Root Access:** APatch, Magisk, or KernelSU installed.
- *(For Method 2)* **ADB (Android Platform Tools)** on PC and **USB Debugging** enabled on the device.

---

### Method 1: Flash via APatch / Magisk / KernelSU (Recommended)
1. Download **`pandora_btaudiofix.zip`** to your phone.
2. Open your root manager (**APatch / Magisk / KernelSU**).
3. Go to the **Modules (`APModule`)** tab, tap **Install**, and select **`pandora_btaudiofix.zip`**.
4. **Reboot** your device.

---

### Method 2: One-Click Windows ADB Installer (`setup.bat`)
1. Clone or download this repository to your PC.
2. Connect your phone via USB with USB Debugging enabled.
3. Double-click **`setup.bat`**.
4. The script automatically installs the module into `/data/adb/modules/xiaomi17pro_bt_audio_fix`, bind-mounts `/odm/etc/audio_policy_engine_stream_volumes_mi.xml`, disables `MusicFX`/`MiSound`, and restarts `audioserver` (**takes effect immediately without rebooting**).

---

## 🔄 Uninstallation (Restore Factory Stock)

- **On Phone:** Remove the module from the APatch / Magisk / KernelSU app and reboot. Because this modification is completely systemless (`mount -o bind`), your original `/odm` partition remains untouched.
- **From PC:** Connect your phone via USB and double-click **`reset.bat`** to immediately restore factory settings.

---

## 🛠️ Verification

To verify that the patched volume curves are active, run the following command via ADB:

```bash
adb shell "su -c 'dumpsys media.audio_policy | grep -E \"DEVICE_CATEGORY_A2DP\"'"
```

Expected output (`(100, -350)` at maximum volume index):
```text
DEVICE_CATEGORY_A2DP : { (1, -4900), ..., (93, -470), (100, -350) }
DEVICE_CATEGORY_A2DP_CE : { (1, -4900), ..., (93, -470), (100, -350) }
```

---

## ⚠️ Disclaimer

> **USE AT YOUR OWN RISK:**  
> The files, scripts, and instructions in this repository are provided **"as-is"** for educational and personal use only. Modifying system audio policies and using root access carry inherent risks.  
>  
> The author assumes **no responsibility or liability** for any software/hardware damage, data loss, voided warranty, speaker/earbud driver wear, or hearing damage resulting from elevated volume levels. Always back up your device before applying system-level modifications.
