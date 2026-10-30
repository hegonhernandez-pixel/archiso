5. Validación de la ISO (scripts/30-validate-iso.sh)

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
shopt -s nullglob

isos=("$ROOT"/out/*.iso)

((${#isos[@]})) || { echo "[-] Error: No se encontró ninguna ISO en out/. Ejecuta 20-build-iso.sh primero."; exit 1; }

for iso in "${isos[@]}"; do
    echo "=================================================="
    echo " Verificando archivo: $iso"
    echo "=================================================="
    file "$iso"
    
    if [[ ! -s "$iso" ]]; then
        echo "[-] Error: La ISO generada tiene tamaño 0 o está corrupta." >&2
        exit 1
    fi
    
    echo "--- Hash SHA256 ---"
    sha256sum "$iso"
    
    echo "--- Catálogo del Sistema de Archivos ISO ---"
    if command -v xorriso >/dev/null 2>&1; then
        xorriso -indev "$iso" -toc
    elif command -v isoinfo >/dev/null 2>&1; then
        isoinfo -d -i "$iso"
    else
        echo "[!] Aviso: Instala libisoburn (xorriso) para inspeccionar el catálogo de la ISO."
    fi
done

echo "[✔] Validación de ISO finalizada correctamente."
