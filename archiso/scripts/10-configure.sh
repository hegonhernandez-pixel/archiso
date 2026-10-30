#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONF="$ROOT/config/selection.conf"

if [[ ! -f "$CONF" ]]; then
    echo "[-] Error: No se encontró el archivo de configuración en $CONF" >&2
    exit 1
fi

source "$CONF"

ask() {
    local key="$1" label="$2" current="$3" answer
    read -r -p "$label [${current}]: " answer
    answer="${answer:-$current}"
    
    if [[ "$answer" != "0" && "$answer" != "1" ]]; then
        echo "[-] Valor inválido: usa 0 o 1"
        ask "$key" "$label" "$current"
        return
    fi
    
    sed -i "s/^${key}=.*/${key}=${answer}/" "$CONF"
}

echo "=================================================="
echo "   compresSO Arch | Selección de Paquetes ISO"
echo "=================================================="
echo "Instrucciones: Enter 1 para ACEPTAR, 0 para OMITIR"
echo "Presiona [ENTER] para conservar el valor por defecto"
echo "--------------------------------------------------"

ask ENLIGHTENMENT "1. Escritorio Enlightenment (Entorno Principal)" "$ENLIGHTENMENT"
ask LXQT          "2. Escritorio Secundario LXQt"                 "$LXQT"
ask AMD_VULKAN    "3. Controladores AMDGPU + Vulkan RADV (mesa)"  "$AMD_VULKAN"
ask ALSA          "4. Soporte de Audio ALSA + UCM"               "$ALSA"
ask PIPEWIRE      "5. Servidor PipeWire + WirePlumber"          "$PIPEWIRE"
ask FFMPEG        "6. Paquete Multimedia FFmpeg"                 "$FFMPEG"
ask RETROARCH     "7. RetroArch + Archivos Core Info"            "$RETROARCH"
ask STEAM         "8. Cliente Steam Oficial (Multilib x86_32)"    "$STEAM"
ask LXD           "9. Contenedores LXD / LXC"                    "$LXD"
ask DEV_TOOLS     "10. Herramientas de Desarrollo (GCC, CMake)"   "$DEV_TOOLS"
ask FONTS         "11. Fuentes Tipográficas (Noto, DejaVu)"      "$FONTS"

echo "--------------------------------------------------"
echo "[✔] Selección guardada correctamente en:"
echo "    $CONF"
echo "=================================================="
