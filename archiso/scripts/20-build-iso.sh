#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

source config/selection.conf

echo "=== Generando Perfil de Archiso ==="
mkdir -p profile logs out work

if [[ ! -f profile/profiledef.sh ]]; then
    cp -a /usr/share/archiso/configs/releng/. profile/
fi

cat > profile/packages.x86_64 <<'PKG'
base
linux
linux-firmware
mkinitcpio
mkinitcpio-archiso
arch-install-scripts
grub
efibootmgr
squashfs-tools
dosfstools
e2fsprogs
mtools
libisoburn
networkmanager
sudo
git
base-devel
btrfs-progs
zram-generator
zstd
lz4
xz
xorg-server
lightdm
lightdm-gtk-greeter
mesa
libdrm
vulkan-icd-loader
vulkan-tools
PKG

addpkg(){ grep -qxF "$1" profile/packages.x86_64 || echo "$1" >> profile/packages.x86_64; }

[[ "$ENLIGHTENMENT" == 1 ]] && addpkg enlightenment
if [[ "$AMD_VULKAN" == 1 ]]; then
    addpkg vulkan-radeon
    addpkg lib32-vulkan-radeon
fi
if [[ "$ALSA" == 1 ]]; then
    addpkg alsa-utils
    addpkg alsa-ucm-conf
fi
[[ "$FFMPEG" == 1 ]] && addpkg ffmpeg
if [[ "$RETROARCH" == 1 ]]; then
    addpkg retroarch
    addpkg libretro-core-info
fi

LOG="logs/build-$(date +%Y%m%d-%H%M%S).log"
echo "=== Ejecutando mkarchiso ==="

if [[ $EUID -eq 0 ]]; then
    mkarchiso -v -w work -o out profile 2>&1 | tee "$LOG"
else
    sudo mkarchiso -v -w work -o out profile 2>&1 | tee "$LOG"
fi

echo "=== Compilación completada exitosamente ==="
