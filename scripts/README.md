# Installation Scripts

This directory contains automated installation scripts for different Linux distributions to set up the i3wm rice configuration.

## Available Scripts

### 🔷 Arch Linux - `install-arch.sh`
- **Package Manager**: pacman + yay (AUR helper)
- **Special Features**: 
  - Automatic yay installation if not present
  - AUR package support (Albert)
  - Latest packages from official repos

**Usage:**
```bash
chmod +x scripts/install-arch.sh
./scripts/install-arch.sh
```

### 🟠 Debian/Ubuntu - `install-debian.sh`
- **Package Manager**: apt
- **Special Features**: 
  - Automatic distribution detection (Debian vs Ubuntu)
  - Nerd Fonts manual installation
  - Snap package support for Ubuntu

**Usage:**
```bash
chmod +x scripts/install-debian.sh
./scripts/install-debian.sh
```

### 🔴 Fedora - `install-fedora.sh`
- **Package Manager**: dnf
- **Special Features**: 
  - RPM Fusion repository setup
  - COPR support
  - Flatpak applications
  - Additional development tools

**Usage:**
```bash
chmod +x scripts/install-fedora.sh
./scripts/install-fedora.sh
```

## What Gets Installed

### Core Components
- **Window Manager**: i3-wm
- **Terminal**: Kitty
- **Shell**: Fish
- **Display Manager**: LightDM
- **Screen Locker**: i3lock

### Visual Enhancements
- **Status Bar**: Polybar
- **Compositor**: Picom (shadows, transparency, blur)
- **Wallpaper Manager**: feh
- **Color Scheme**: pywal
- **App Launcher**: Albert (where available)

### Development Tools
- **Runtime**: Bun (JavaScript/TypeScript)
- **Node Manager**: NVM
- **Fonts**: JetBrains Mono Nerd Font

### System Tools
- **Audio**: PulseAudio + pavucontrol
- **Network**: NetworkManager
- **Launcher**: dmenu
- **Session Management**: xss-lock, polkit-gnome, dex

## Post-Installation

After running any script:

1. **Reboot** your system
2. **Select i3** from your display manager login screen
3. **Copy configuration files**:
   ```bash
   cp configs/i3.config ~/.config/i3/config
   cp configs/kitty.conf ~/.config/kitty/kitty.conf
   cp configs/fish.config ~/.config/fish/config.fish
   cp configs/polybar.config ~/.config/polybar/config.ini
   cp configs/picom.config ~/.config/picom/picom.conf
   ```
4. **Add wallpapers** to `~/Wallpapers/`
5. **Restart i3** with `Mod+Shift+r`

## Troubleshooting

### Permission Issues
If you get permission errors, make sure the script is executable:
```bash
chmod +x scripts/install-[distro].sh
```

### Missing Packages
Some packages might not be available in older distribution versions. The scripts will continue with warnings for missing optional packages.

### Font Issues
If Nerd Fonts don't display correctly:
```bash
fc-cache -fv
```

### Shell Change
If fish doesn't become the default shell automatically:
```bash
chsh -s $(which fish)
```

## Customization

Feel free to modify the scripts to:
- Add additional packages you need
- Remove packages you don't want
- Change default configurations
- Add distribution-specific optimizations

## Contributing

If you want to add support for other distributions (openSUSE, CentOS, Alpine, etc.), please follow the same structure and create a pull request.
