# Custom TWRP Recovery for Samsung Galaxy A12 Nacho (SM-A127F)

[![TWRP CI](https://github.com/Itszeeshanrajput/samsung-a12s-custom-twrp/actions/workflows/build-twrp.yml/badge.svg)](https://github.com/Itszeeshanrajput/samsung-a12s-custom-twrp/actions/workflows/build-twrp.yml)
[![GitHub Release](https://img.shields.io/github/v/release/Itszeeshanrajput/samsung-a12s-custom-twrp?color=blue&logo=github)](https://github.com/Itszeeshanrajput/samsung-a12s-custom-twrp/releases)
[![Platform](https://img.shields.io/badge/Platform-Samsung%20Exynos%20850-orange?logo=samsung)](https://semiconductor.samsung.com/processor/mobile-processor/exynos-850/)
[![Arch](https://img.shields.io/badge/Architecture-ARM64%20(aarch64)-green)](#)
[![TWRP Version](https://img.shields.io/badge/TWRP-v3.7.0_12-blue?logo=android)](#)
[![License](https://img.shields.io/badge/License-GPL%20v3-lightgrey)](#)

---

## 📱 Hardware & Compatibility Specs

| Target Parameter | Value / Specification |
| :--- | :--- |
| **Device Model** | Samsung Galaxy A12 Nacho (`SM-A127F` / `SM-A127M`) |
| **Device Codename** | `a12s` / `a12snsxx` / `universal3830` |
| **SoC** | Samsung Exynos 850 (8nm LPP Octa-Core Cortex-A55) |
| **GPU** | ARM Mali-G52 MP1 |
| **Resolution** | 720 x 1600 pixels (20:9 Aspect Ratio) |
| **Partition Layout** | A-only with Dynamic Logical Partitions (`super.img`) |
| **File Systems** | F2FS (`/data`), EXT4 & EROFS (`/system`, `/vendor`, `/product`), VFAT (SD/OTG) |

---

## ✨ Features & Upgrades

- **Dynamic Super Partition Management:** Full support for `/super` (System + Vendor + Product + ODM) raw image backup and flashing. Allows restoring complete ROMs in a single step.
- **Full Encryption & FBE v2 Compatibility:** Supports F2FS encrypted user data formatting and multidisabler integration to permanently prevent force-encryption loops.
- **Odin Flashable `.tar` Archives:** Direct packaging into Samsung Odin-compatible TAR files (`TWRP-*-Odin.tar`) ready for flashing in the **AP** slot.
- **AVB VBMeta Disabled Header:** Includes standalone `vbmeta_disabled.tar` to bypass Knox Android Verified Boot (AVB) integrity verification loops.
- **USB High-Speed MTP & ADB:** Fixed Samsung USB composite endpoints (`04e8:6860`) for reliable PC file transfer and ADB sideloading inside recovery.
- **Fastbootd & GSI Support:** Seamless transition into Android `fastbootd` mode for flashing Project Treble GSIs directly.
- **Storage Versatility:** MicroSD card (`/external_sd`) and USB OTG (`/usb-otg`) plug-and-play mount support.
- **Critical Radio Backup:** Dedicated partitions for `/efs` (IMEI/NVRAM), `/param` (Boot Logo/Config), and `/dtbo`.

---

## 📥 Downloads

Download the latest verified recovery packages from the official [Releases](https://github.com/Itszeeshanrajput/samsung-a12s-custom-twrp/releases) page:

1. **`TWRP-3.7.0_12-SM-A127F-*-Odin.tar`** — Odin flashable recovery archive for PC.
2. **`vbmeta_disabled.tar`** — Odin flashable AVB disabled header (flashed in **USERDATA** slot).
3. **`recovery.img`** — Raw image for Fastboot or on-device flashing via TWRP.
4. **`.sha256` and `.md5`** — Cryptographic checksums for payload verification.

---

## ⚡ Flashing Guide via Odin (Samsung PC Suite)

### Requirements
- Unlocked bootloader (OEM unlocking enabled in Developer Options).
- Samsung USB Drivers installed on Windows PC.
- Odin v3.14.4 or newer.
- USB-C cable connected between phone and PC.

### Step-by-Step Procedure
1. Power off device completely.
2. Hold `Volume Down + Volume Up` together and connect the USB cable to enter **Download Mode**. Press `Volume Up` to confirm.
3. Launch Odin v3.14.4 on PC:
   - Place `TWRP-3.7.0_12-SM-A127F-*-Odin.tar` into the **AP** slot.
   - Place `vbmeta_disabled.tar` into the **USERDATA** (or **CSC**) slot.
4. **CRUCIAL STEP:** In Odin, switch to the **Options** tab and **UNCHECK "Auto Reboot"**.
5. Click **Start**. Wait until the top-left box displays `PASS!`.
6. Disconnect or keep USB connected, then:
   - Hold `Volume Down + Power` to force the phone out of Download Mode.
   - **The very instant the screen turns black**, immediately switch fingers to **Volume Up + Power** (while keeping the USB cable connected to PC).
7. Keep holding until the TWRP splash screen appears!

### First Boot Setup (Avoid Bootloops)
1. In TWRP, tap **Wipe** > **Format Data**.
2. Type `yes` and confirm (this removes Samsung Knox encryption on `/data`).
3. Flash your custom kernel or multidisabler if required.
4. Tap **Reboot** > **System**.

---

## 🛡️ Device Fail-Safe Reference

A complete working baseline backup of all critical partitions is maintained on the build host at:
```bash
/root/device_backups/SM-A127F_working_state/
```
To restore the device to its known baseline state:
```bash
bash /root/device_backups/SM-A127F_working_state/restore.sh
```

---

## 🤝 Credits & Acknowledgements
- **TeamWin Recovery Project (TWRP):** Core recovery framework.
- **MizProject:** Initial Exynos 850 device tree research.
- **TopJohnWu & Ianmacd:** Multidisabler and Samsung encryption research.
- **osm0sis:** Packaging and script utilities.

---
**Maintained by:** [Itszeeshanrajput](https://github.com/Itszeeshanrajput)  
**License:** GNU General Public License v3 (GPL-3.0).
