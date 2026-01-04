# Affinity Legacy Bridge
**For GLIBC < 2.38 Systems (Ubuntu 22.04, Pop!_OS 22.04, Linux Mint 21, etc.)**

This repository provides an automated solution to run **Affinity V2/V3** on "older" Linux distributions where modern installers fail due to outdated `GLIBC` versions.

## 🛑 The Problem
Affinity (via modern Wine builds) requires `GLIBC 2.38+`.
Stable LTS systems like Ubuntu 22.04 only provide `GLIBC 2.35`.
As a result, the application fails to start or crashes silently.

## 💡 The Solution
This kit uses **Bottles (Flatpak)** as a "bridge".
It executes the official Affinity AppImage **inside** the Bottles runtime, which contains isolated modern libraries (`GLIBC 2.42+`), allowing it to run on older systems without breaking anything.

## 🚀 Requirements
1.  **Flatpak** installed.
2.  **Bottles** installed via Flatpak (`flatpak install flathub com.usebottles.bottles`).

## 📥 Installation

1.  Clone this repository:
    ```bash
    git clone https://github.com/your-username/Affinity-Legacy-Bridge.git
    cd Affinity-Legacy-Bridge
    ```

2.  Run the installer:
    ```bash
    chmod +x install.sh
    ./install.sh
    ```

3.  Done! Search for "Affinity Studio" in your applications menu.

## 🛠️ What the installer does
1.  Downloads the Affinity AppImage (`~2GB`) to `~/.var/app/com.usebottles.bottles/data/`.
2.  Installs a bridge script inside the Bottles sandbox.
3.  Creates a local launcher in `~/.local/bin/` that connects everything.
4.  Configures the system icon and desktop shortcut.

## Credits
- Solution based on [AffinityOnLinux](https://github.com/ryzendew/AffinityOnLinux).
- Legacy/Flatpak adaptation by EnerBy & Antigravity.

## 🔄 How to Update or Install Other Apps
This solution works for **Affinity Photo, Designer, and Publisher** (V2/V3). They all share the same environment.

To install a new version (e.g., 2.6) or a different Affinity app:
1.  Download the `.exe` installer from your Serif account.
2.  Run the helper script:
    ```bash
    ./run-tool.sh /path/to/affinity-photo-installer.exe
    ```
3.  The installer will open inside the correct environment. Follow the steps as usual.

## ❓ FAQ / Troubleshooting

**Q: Do I need to install .NET, Wine, or Python on my system first?**
A: **No.** Everything is self-contained.
- **Bottles** provides the Wine engine.
- **The AppImage** provides the environment.
- **Affinity's Installer** (`.exe`) will install its own .NET version inside the virtual bottle.

**Q: "Wine Mono Installer" popped up. What do I do?**
A: Click **Install**. This is normal for a fresh Wine prefix. It's a one-time dependency needed for the setup to start.

**Q: Does this work on Fedora / Arch / Other distros?**
A: Yes, as long as you have **Flatpak** installed, this solution is universal.

