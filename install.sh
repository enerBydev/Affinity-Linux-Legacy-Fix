#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Affinity Legacy Fix Installer ===${NC}"
echo "This script will configure Affinity to run on systems with older GLIBC versions."

# 1. Pre-checks
echo -e "\n${BLUE}1. Checking Dependencies...${NC}"

if ! command -v flatpak &> /dev/null; then
    echo -e "${RED}Error: Flatpak is not installed.${NC}"
    exit 1
fi

if ! flatpak list | grep -q "com.usebottles.bottles"; then
    echo "Installing Bottles..."
    flatpak install -y flathub com.usebottles.bottles
else
    echo -e "${GREEN}✓ Bottles detected${NC}"
fi

# 2. Prepare Directories
echo -e "\n${BLUE}2. Preparing directories...${NC}"
BOTTLES_DATA="$HOME/.var/app/com.usebottles.bottles/data"
APPIMAGE_PATH="$BOTTLES_DATA/Affinity.AppImage"
INTERNAL_SCRIPT="$BOTTLES_DATA/affinity_internal_launcher.sh"
LOCAL_BIN="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons"

mkdir -p "$LOCAL_BIN" "$ICON_DIR"

if [ ! -d "$BOTTLES_DATA" ]; then
    echo "Initializing Bottles (required to create data folders)..."
    flatpak run com.usebottles.bottles --help > /dev/null 2>&1
fi

# 3. Download AppImage
echo -e "\n${BLUE}3. Verifying AppImage...${NC}"
if [ -f "$APPIMAGE_PATH" ]; then
    echo -e "${GREEN}✓ AppImage already exists at $APPIMAGE_PATH${NC}"
else
    echo "Downloading Affinity AppImage (2GB)..."
    # Hardcoded URL to current wine-10.10 version
    wget https://github.com/ryzendew/Linux-Affinity-Installer/releases/download/Affinity-wine-10.10-Appimage/Affinity-3-x86_64.AppImage -O "$APPIMAGE_PATH"
    chmod +x "$APPIMAGE_PATH"
fi

# 4. Install Internal Script
echo -e "\n${BLUE}4. Installing internal script...${NC}"
cp ./resources/internal_runner.sh "$INTERNAL_SCRIPT"
chmod +x "$INTERNAL_SCRIPT"
echo -e "${GREEN}✓ Script installed in sandbox${NC}"

# 5. Create Local Launcher
echo -e "\n${BLUE}5. Creating local launcher...${NC}"
WRAPPER_SCRIPT="$LOCAL_BIN/affinity-legacy-launcher"

cat > "$WRAPPER_SCRIPT" <<EOF
#!/bin/bash
echo "Launching Affinity (Legacy Fix)..."
flatpak run --command=bash com.usebottles.bottles -c "export APPIMAGE_EXTRACT_AND_RUN=1; export HOME=/var/data; /var/data/affinity_internal_launcher.sh"
EOF

chmod +x "$WRAPPER_SCRIPT"
echo -e "${GREEN}✓ Launcher created at $WRAPPER_SCRIPT${NC}"

# 6. Configure Icon
echo -e "\n${BLUE}6. Configuring Icon...${NC}"
# Download SVG if not exists
if [ ! -f "$ICON_DIR/affinity.svg" ]; then
    echo "Attempting to retrieve icon..."
    # Fallback download if SVG not available from extraction
    wget https://upload.wikimedia.org/wikipedia/commons/e/e6/Affinity_Designer_Icon_2019.png -O "$ICON_DIR/affinity.png"
    ICON_NAME="affinity.png"
else
    ICON_NAME="affinity.svg"
fi

# 7. Create .desktop
echo -e "\n${BLUE}7. Creating shortcuts...${NC}"
cp ./resources/affinity.desktop "$DESKTOP_DIR/affinity-studio-legacy.desktop"
# Replace placeholders
sed -i "s|HOME_DIR|$HOME|g" "$DESKTOP_DIR/affinity-studio-legacy.desktop"
sed -i "s|affinity.svg|$ICON_NAME|g" "$DESKTOP_DIR/affinity-studio-legacy.desktop"

update-desktop-database "$DESKTOP_DIR" 2>/dev/null

echo -e "\n${GREEN}=== Installation Complete ===${NC}"
echo "Search for 'Affinity Studio' in your applications menu."
