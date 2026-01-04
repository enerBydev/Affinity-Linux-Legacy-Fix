#!/bin/bash
# Internal script to run ANY executable inside the bottle
# Usage: ./installer_runner.sh /path/to/installer.exe

export HERE="/var/data/squashfs-root"
export PATH="${HERE}/usr/wine/bin:${PATH}"
export WINELOADER="${HERE}/usr/wine/bin/wine"
export WINEDLLPATH="${HERE}/usr/wine/lib/wine"
export LD_LIBRARY_PATH="${HERE}/usr/wine/lib:${LD_LIBRARY_PATH}"
export DXVK_ASYNC=0
export WINEPREFIX="/home/enerby/.AffinityLinux-Appimage"
export WINEDLLOVERRIDES="mscoree=native;winemenubuilder.exe=d"

# User detection
CURRENT_USER=$(whoami)
export WINEPREFIX="/home/$CURRENT_USER/.AffinityLinux-Appimage"

if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_exe>"
    exit 1
fi

TARGET_EXE="$1"

echo "=== [Internal] Running Installer/Tool: $TARGET_EXE ==="
exec "${WINELOADER}" "$TARGET_EXE"
