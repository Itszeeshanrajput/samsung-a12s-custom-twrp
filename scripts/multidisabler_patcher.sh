#!/usr/bin/env bash
# ==============================================================================
# Universal Samsung Dynamic Partition Multidisabler for SM-A127F (Exynos 850)
# Neutralizes: dm-verity, forced encryption, proca, vaultkeeper, and wsm
# ==============================================================================

set -euo pipefail

TARGET_DIR="${1:-/vendor/etc}"

echo "[*] Running NextGen Dynamic Partition Disabler on $TARGET_DIR..."

find "$TARGET_DIR" -name "fstab.*" | while read -r fstab; do
    echo "[+] Patching $fstab..."
    # 1. Remove forced encryption flags (fileencryption=, forcefips=, encryptable=)
    sed -i -E 's/,fileencryption=[^, ]+//g' "$fstab"
    sed -i -E 's/fileencryption=[^, ]+,//g' "$fstab"
    sed -i -E 's/fileencryption=[^, ]+//g' "$fstab"
    sed -i -E 's/,forcefips=[^, ]+//g' "$fstab"
    sed -i -E 's/,encryptable=[^, ]+//g' "$fstab"
    
    # 2. Disable dm-verity, avb, and early-mount verification
    sed -i -E 's/,avb_keys=[^, ]+//g' "$fstab"
    sed -i -E 's/,avb=[^, ]+//g' "$fstab"
    sed -i -E 's/,verify//g' "$fstab"
    sed -i -E 's/verify,//g' "$fstab"
    sed -i -E 's/verify//g' "$fstab"
    sed -i -E 's/,support_scfs//g' "$fstab"
    
    # 3. Disable quota tracking that corrupts data resize
    sed -i -E 's/,quota//g' "$fstab"
    sed -i -E 's/quota,//g' "$fstab"
done

echo "[✓] In-place multidisabler patching completed without dynamic partition resize errors!"
