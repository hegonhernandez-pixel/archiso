#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="compresso-arch"
mkdir -p "$TARGET_DIR"/{config,scripts,logs,out,work}

# Crear config/selection.conf
cat << 'EOF' > "$TARGET_DIR/config/selection.conf"
ENLIGHTENMENT=1
LXQT=0
AMD_VULKAN=1
ALSA=1
PIPEWIRE=1
FFMPEG=1
RETROARCH=1
STEAM=0
LXD=0
DEV_TOOLS=1
FONTS=1
EOF

chmod +x "$TARGET_DIR"/scripts/*.sh 2>/dev/null || true

# Empaquetar
zip -r compresso-arch-starter.zip "$TARGET_DIR"
echo "[✔] Generado compresso-arch-starter.zip con éxito."
