#!/usr/bin/env bash
# ==============================================================================
# TWRP & Odin Packaging Script for Samsung Galaxy A12 Nacho (SM-A127F / a12s)
# ==============================================================================

set -euo pipefail

RECOVERY_IMG="${1:-recovery.img}"
OUTPUT_DIR="${2:-.}"

if [ ! -f "$RECOVERY_IMG" ]; then
    echo "[!] Error: Recovery image not found at $RECOVERY_IMG"
    exit 1
fi

BUILD_DATE=$(date +'%Y%m%d')
TAR_NAME="TWRP-3.7.0_12-SM-A127F-${BUILD_DATE}-Odin.tar"

echo "[*] Packaging $RECOVERY_IMG into Odin-flashable archive: $TAR_NAME"

cd "$(dirname "$RECOVERY_IMG")"
BASE_IMG="$(basename "$RECOVERY_IMG")"

# Create standard Odin AP flashable tar archive
tar -H ustar -c "$BASE_IMG" > "$OUTPUT_DIR/$TAR_NAME"

echo "[*] Creating empty vbmeta_disabled image to bypass AVB 2.0..."
# Generate standard 4096-byte AVB disabled vbmeta header if python avbtool is available,
# or create standard disabled vbmeta file
python3 -c "
import struct
# AVB magic 'AVB0' + flags (0x2 = AVB_VBMETA_IMAGE_FLAGS_HASHTREE_DISABLED | 0x1 = AVB_VBMETA_IMAGE_FLAGS_VERIFICATION_DISABLED)
header = bytearray(4096)
header[0:4] = b'AVB0'
header[120:124] = struct.pack('>I', 3) # disable verity + verification
with open('$OUTPUT_DIR/vbmeta_disabled.img', 'wb') as f:
    f.write(header)
" 2>/dev/null || true

if [ -f "$OUTPUT_DIR/vbmeta_disabled.img" ]; then
    tar -H ustar -c -C "$OUTPUT_DIR" vbmeta_disabled.img > "$OUTPUT_DIR/vbmeta_disabled.tar"
    echo "[✓] Generated vbmeta_disabled.tar for Odin AP/USERDATA slot."
fi

# Generate Checksums
cd "$OUTPUT_DIR"
sha256sum "$TAR_NAME" > "${TAR_NAME}.sha256"
md5sum "$TAR_NAME" > "${TAR_NAME}.md5"

echo "[✓] Odin packaging complete: $OUTPUT_DIR/$TAR_NAME"
