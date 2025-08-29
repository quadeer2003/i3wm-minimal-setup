#!/bin/bash

# Arch Linux i3wm setup i    print_error "This script should not be run as root"


# AUR helper checkler
# Author: quadeer2003

set -e

echo "=========================================="
echo "  i3wm-minimal-setup Installation Script"
echo "  Arch Linux Edition"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Check if yay is installed, install if not
check_aur_helper() {
    if ! command -v yay &> /dev/null; then
        print_status "Installing yay (AUR helper)..."
        ORIGINAL_DIR="$(pwd)"
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd "$ORIGINAL_DIR"
        print_success "yay installed successfully"
    else
        print_success "yay is already installed"
    fi
}

# System update
print_status "Updating system packages..."
sudo pacman -Syu --noconfirm

# Core components
print_status "Installing core components..."
sudo pacman -S --needed --noconfirm \
    i3-wm \
    i3lock \
    i3status \
    kitty \
    fish

# Essential tools
print_status "Installing essential tools..."
sudo pacman -S --needed --noconfirm \
    lightdm \
    lightdm-gtk-greeter \
    networkmanager \
    network-manager-applet \
    xss-lock \
    dmenu \
    polkit-gnome \
    dex

# Visual tools
print_status "Installing visual enhancement tools..."
sudo pacman -S --needed --noconfirm \
    polybar \
    picom \
    feh \
    python-pywal

# AUR packages
check_aur_helper

print_status "Installing AUR packages..."

# Dev tools
print_status "Installing development tools..."

# Install Neovim
if ! command -v nvim &> /dev/null; then
    print_status "Installing Neovim..."
    ORIGINAL_DIR="$(pwd)"
    cd /tmp
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    cd "$ORIGINAL_DIR"
    print_success "Neovim installed successfully"
else
    print_success "Neovim is already installed"
fi

# Install nvim-dots config
print_status "Installing nvim-dots configuration..."
if [[ -d ~/.config/nvim ]]; then
    print_warning "Existing nvim config found, backing up to ~/.config/nvim.backup"
    mv ~/.config/nvim ~/.config/nvim.backup
fi

# Store current directory before going to /tmp
ORIGINAL_DIR="$(pwd)"
cd /tmp
git clone https://github.com/quadeer2003/nvim-dots.git
mv nvim-dots ~/.config/nvim
# Return to original directory
cd "$ORIGINAL_DIR"
print_success "nvim-dots configuration installed"

# Install Bun
# if ! command -v bun &> /dev/null; then
#     print_status "Installing Bun..."
#     curl -fsSL https://bun.sh/install | bash
#     print_success "Bun installed successfully"
# else
#     print_success "Bun is already installed"
# fi



# Fonts
print_status "Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \

# Config directories
print_status "Creating configuration directories..."
mkdir -p ~/.config/{i3,kitty,fish,polybar,picom}
mkdir -p ~/Wallpapers
mkdir -p ~/.cache/wal

# Set default shell
print_status "Setting fish as default shell..."
if [[ $SHELL != *"fish"* ]]; then
    chsh -s $(which fish)
    print_success "Fish set as default shell (restart terminal to take effect)"
else
    print_success "Fish is already the default shell"
fi

# Enable services
print_status "Enabling system services..."
sudo systemctl enable lightdm
sudo systemctl enable NetworkManager

# Copy configs
print_status "Copying configuration files..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Try to find configs in multiple locations
CONFIGS_DIR=""
if [[ -d "$REPO_DIR/configs" ]]; then
    CONFIGS_DIR="$REPO_DIR/configs"
elif [[ -d "./configs" ]]; then
    CONFIGS_DIR="./configs"
elif [[ -d "../configs" ]]; then
    CONFIGS_DIR="../configs"
elif [[ -d "/home/$USER/Documents/dot.quadeer.in/my-app/configs" ]]; then
    CONFIGS_DIR="/home/$USER/Documents/dot.quadeer.in/my-app/configs"
fi

# Debug: Show the paths
print_status "Script directory: $SCRIPT_DIR"
print_status "Repository directory: $REPO_DIR"
print_status "Looking for configs directory..."

# Check repo structure
if [[ -n "$CONFIGS_DIR" && -d "$CONFIGS_DIR" ]]; then
    print_status "Found config files in $CONFIGS_DIR, copying to user directories..."
    
    # Copy i3 config
    if [[ -f "$CONFIGS_DIR/i3.config" ]]; then
        cp "$CONFIGS_DIR/i3.config" ~/.config/i3/config
        print_success "i3 config copied"
    fi
    
    # Copy kitty config
    if [[ -f "$CONFIGS_DIR/kitty.conf" ]]; then
        cp "$CONFIGS_DIR/kitty.conf" ~/.config/kitty/kitty.conf
        print_success "Kitty config copied"
    fi
    
    # Copy fish config
    if [[ -f "$CONFIGS_DIR/fish.config" ]]; then
        cp "$CONFIGS_DIR/fish.config" ~/.config/fish/config.fish
        print_success "Fish config copied"
        
        # Add Neovim to PATH in fish config
        if ! grep -q "/opt/nvim-linux-x86_64/bin" ~/.config/fish/config.fish 2>/dev/null; then
            echo 'set -gx PATH $PATH /opt/nvim-linux-x86_64/bin' >> ~/.config/fish/config.fish
            print_success "Neovim added to fish PATH"
        fi
    fi
    
    # Copy polybar config
    if [[ -f "$CONFIGS_DIR/polybar.config" ]]; then
        cp "$CONFIGS_DIR/polybar.config" ~/.config/polybar/config.ini
        print_success "Polybar config copied"
    fi
    
    # Copy picom config
    if [[ -f "$CONFIGS_DIR/picom.config" ]]; then
        cp "$CONFIGS_DIR/picom.config" ~/.config/picom/picom.conf
        print_success "Picom config copied"
    fi
    
    print_success "All configuration files copied successfully!"
else
    print_warning "Config files not found in any expected location."
    print_status "Searched locations:"
    print_status "  - $REPO_DIR/configs"
    print_status "  - ./configs"
    print_status "  - ../configs"
    print_status "  - /home/$USER/Documents/dot.quadeer.in/my-app/configs"
    print_status "Current working directory: $(pwd)"
    print_warning "Please manually copy configs after installation."
fi

# Setup wallpapers
print_status "Setting up wallpapers directory..."
if [[ ! -d ~/Wallpapers ]]; then
    mkdir -p ~/Wallpapers
fi

# Download sample wallpaper
if [[ -z "$(ls -A ~/Wallpapers)" ]]; then
    print_status "Downloading a sample wallpaper..."
    curl -s -o ~/Wallpapers/sample.jpg "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop" || print_warning "Failed to download sample wallpaper"
fi

print_success "Installation completed successfully!"
print_success "Your i3wm setup is now ready to use!"
print_warning "Please reboot your system and select i3 from your display manager"

echo ""
echo "🎉 Setup Complete! Next steps:"
echo "1. Reboot your system: sudo reboot"
echo "2. At login screen, select 'i3' as your session"
echo "3. Log in and enjoy your new i3wm rice!"
echo ""
echo "🔧 Your setup includes:"
echo "   ✅ i3wm with custom config"
echo "   ✅ Kitty terminal with configuration"
echo "   ✅ Fish shell as default"
echo "   ✅ Polybar status bar"
echo "   ✅ Picom compositor with effects"
echo "   ✅ Neovim with nvim-dots config"
echo "   ✅ Sample wallpaper in ~/Wallpapers/"
echo ""
echo "📝 Key bindings (after reboot):"
echo "   Mod+Return       - Open terminal"
echo "   Mod+d           - Application launcher"
echo "   Mod+Shift+q     - Close window"
echo "   Mod+Shift+r     - Restart i3"
echo "   Mod+Shift+e     - Exit i3"
echo ""
echo "🎨 To change wallpapers, add images to ~/Wallpapers/ and use:"
echo "   wal -i ~/Wallpapers/your-image.jpg"
