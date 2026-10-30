#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
shopt -s nullglob
isos=("$ROOT"/out/*.iso)

((${#isos[@]})) || { echo "No hay ISO generada en out/."; exit 1; }

ISO="${isos[0]}"
echo "=== Probando arranque de $ISO en QEMU ==="

OVMF=""
for f in /usr/share/edk2/x64/OVMF_CODE.4m.fd /usr/share/edk2-ovmf/x64/OVMF_CODE.4m.fd /usr/share/OVMF/OVMF_CODE.fd; do
    [[ -f "$f" ]] && OVMF="$f" && break
done

if [[ -n "$OVMF" ]]; then
    qemu-system-x86_64 -enable-kvm -m 4096 -smp 4 -bios "$OVMF" -cdrom "$ISO" -boot d -nic user,model=virtio
else
    qemu-system-x86_64 -enable-kvm -m 4096 -smp 4 -cdrom "$ISO" -boot d -nic user,model=virtio
fi
