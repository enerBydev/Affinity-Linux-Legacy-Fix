#!/bin/bash
# Internal script executed INSIDE the Bottles Flatpak sandbox
# This script configures the Wine environment and launches the AppImage content

# Path Configuration
export HERE="/var/data/squashfs-root"
export PATH="${HERE}/usr/wine/bin:${PATH}"
export WINELOADER="${HERE}/usr/wine/bin/wine"
export WINEDLLPATH="${HERE}/usr/wine/lib/wine"
export LD_LIBRARY_PATH="${HERE}/usr/wine/lib:${LD_LIBRARY_PATH}"
export DXVK_ASYNC=0
export WINEPREFIX="/home/enerby/.AffinityLinux-Appimage"
export WINEDLLOVERRIDES="mscoree=native;winemenubuilder.exe=d"

# User detection (usually the same inside sandbox, but safe to check)
CURRENT_USER=$(whoami)
export WINEPREFIX="/home/$CURRENT_USER/.AffinityLinux-Appimage"

echo "=== [Internal] Environment Configured ==="
echo "   User: $CURRENT_USER"
echo "   Prefix: $WINEPREFIX"

# 1. AppImage Extraction (if not exists)
# Assumes AppImage is mounted or copied at /var/data/Affinity.AppImage
if [ ! -d "$HERE" ]; then
    echo "=== [Internal] Extracting AppImage (First run)... ==="
    mkdir -p "$HERE"
    cd /var/data
    
    if [ -f "./Affinity.AppImage" ]; then
        ./Affinity.AppImage --appimage-extract > /dev/null
    else
        echo "ERROR: /var/data/Affinity.AppImage not found"
        exit 1
    fi
fi

# 2. Prefix Configuration (Basic copy from AppImage)
if [ ! -d "$WINEPREFIX" ]; then
    echo "=== [Internal] Creating initial Wine prefix... ==="
    mkdir -p "$WINEPREFIX"
    cp -r "${HERE}/usr/wineprefix/"* "$WINEPREFIX/"
    cp -r "${HERE}/usr/wineprefix/".[!.]* "$WINEPREFIX/" 2>/dev/null
fi

# 3. Copy VKD3D libraries (Graphics)
VKD3D_DLLS="${HERE}/usr/wineprefix/vkd3d_dlls"
USER_VKD3D="${WINEPREFIX}/vkd3d_dlls"
if [ -d "$VKD3D_DLLS" ]; then
    mkdir -p "$USER_VKD3D"
    cp -r "$VKD3D_DLLS/"* "$USER_VKD3D/" 2>/dev/null
    export WINEDLLPATH="${WINEDLLPATH}:${USER_VKD3D}"
fi

# 4. LAUNCH
echo "=== [Internal] Launching Affinity... ==="
exec "${WINELOADER}" "${WINEPREFIX}/drive_c/Program Files/Affinity/Affinity/Affinity.exe" "$@"
