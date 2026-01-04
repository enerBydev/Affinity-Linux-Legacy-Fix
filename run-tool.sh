#!/bin/bash

# Wrapper to run installers/updates inside the Affinity environment
# Usage: ./run-update.sh path/to/affinity-update.exe

if [ -z "$1" ]; then
    echo "Usage: ./run-update.sh <path-to-exe>"
    echo "Example: ./run-update.sh ~/Downloads/affinity-photo-2.6.exe"
    exit 1
fi

# Convert absolute path for host to path visible in sandbox
# (Bottles sandbox maps /home/enerby to /home/enerby, usually)
HOST_PATH=$(readlink -f "$1")

echo "=== Launching Update/Installer ==="
echo "Target: $HOST_PATH"

# First, install the new internal runner if not present
cp ./resources/installer_runner.sh ~/.var/app/com.usebottles.bottles/data/installer_runner.sh
chmod +x ~/.var/app/com.usebottles.bottles/data/installer_runner.sh

# Execute
flatpak run --command=bash com.usebottles.bottles -c "export APPIMAGE_EXTRACT_AND_RUN=1; export HOME=/var/data; /var/data/installer_runner.sh \"$HOST_PATH\""
