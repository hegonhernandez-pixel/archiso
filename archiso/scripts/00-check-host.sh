#!/usr/bin/env bash
set -euo pipefail

echo "=== compresSO Arch: Verificación del Host ==="
printf 'Kernel: '; uname -r
printf 'Arquitectura: '; uname -m
printf 'Espacio libre: '; df -h .

for cmd in pacman mkarchiso qemu-system-x86_64; do
    if command -v "$cmd" >/dev/null; then
        echo "[✔] $cmd instalado"
    else
        echo "[✘] FALTA: $cmd"
    fi
done
