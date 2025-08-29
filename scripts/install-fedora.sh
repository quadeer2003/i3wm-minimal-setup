#!/bin/bash

# Fedora Installation Script for i3wm-minimal-setup
# Author: quadeer2003
# Description: Installs all dependencies needed for the i3wm rice configuration

set -e

echo "=========================================="
echo "  i3wm-minimal-setup Installation Script"
echo "  Fedora Edition"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if this is Fedora
if ! grep -q "Fedora" /etc/os-release; then
    print_error "This script is designed for Fedora systems"
    exit 1
fi

print_status "Detected Fedora"

# Update system
print_status "Updating system packages..."
sudo dnf update -y

# Enable RPM Fusion repositories
print_status "Enabling RPM Fusion repositories..."
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install core components
print_status "Installing core components..."
sudo dnf install -y \
    i3 \
    i3lock \
    i3status \
    kitty \
    fish

# Install essential tools
print_status "Installing essential tools..."
sudo dnf install -y \
    lightdm \
    lightdm-gtk \
    pulseaudio \
    pulseaudio-utils \
    pavucontrol \
    NetworkManager \
    network-manager-applet \
    xss-lock \
    dmenu \
    polkit-gnome \
    dex

# Install visual enhancement tools
print_status "Installing visual enhancement tools..."
sudo dnf install -y \
    polybar \
    picom \
    feh \
    python3-pip \
    curl \
    wget \
    git

# Install pywal via pip
print_status "Installing pywal..."
pip3 install --user pywal

# Install Albert (from Fedora repos if available)
if dnf search albert 2>/dev/null | grep -q "albert"; then
    print_status "Installing Albert..."
    sudo dnf install -y albert
else
    print_warning "Albert not available in repositories, skipping..."
fi

# COPR support
print_status "Installing dnf-plugins-core for COPR support..."
sudo dnf install -y dnf-plugins-core

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

ORIGINAL_DIR="$(pwd)"
cd /tmp
git clone https://github.com/quadeer2003/nvim-dots.git
mv nvim-dots ~/.config/nvim
cd "$ORIGINAL_DIR"
print_success "nvim-dots configuration installed"

# Install Bun
print_status "Installing development tools..."

# Install Bun
if ! command -v bun &> /dev/null; then
    print_status "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    print_success "Bun installed successfully"
else
    print_success "Bun is already installed"
fi

# Install NVM
if [ ! -d "$HOME/.nvm" ]; then
    print_status "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    print_success "NVM installed successfully"
else
    print_success "NVM is already installed"
fi

# Install fonts
print_status "Installing fonts..."
sudo dnf install -y \
    jetbrains-mono-fonts \
    google-noto-fonts \
    google-noto-emoji-fonts

# Install Nerd Fonts manually
if ! fc-list | grep -i "nerd" > /dev/null; then
    print_status "Installing Nerd Fonts..."
    mkdir -p ~/.local/share/fonts
    ORIGINAL_DIR="$(pwd)"
    cd /tmp
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/
    cd "$ORIGINAL_DIR"
    fc-cache -fv
    print_success "Nerd Fonts installed"
fi

# Install additional useful packages
print_status "Installing additional useful packages..."
sudo dnf install -y \
    htop \
    neofetch \
    ranger \
    zoxide \
    ripgrep \
    fd-find \
    bat

# Create necessary directories
print_status "Creating configuration directories..."
mkdir -p ~/.config/{i3,kitty,fish,polybar,picom}
mkdir -p ~/Wallpapers
mkdir -p ~/.cache/wal

# Set fish as default shell
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

# Copy configuration files
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

# Check if we're in the correct repository structure
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

# Create a sample wallpaper directory with a default wallpaper
print_status "Setting up wallpapers directory..."
if [[ ! -d ~/Wallpapers ]]; then
    mkdir -p ~/Wallpapers
fi

# Download a sample wallpaper if none exists
if [[ -z "$(ls -A ~/Wallpapers)" ]]; then
    print_status "Downloading a sample wallpaper..."
    curl -s -o ~/Wallpapers/sample.jpg "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h-1080&fit=crop" || print_warning "Failed to download sample wallpaper"
fi

# Install flatpak apps (optional)
print_status "Installing useful Flatpak applications..."
sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.mozilla.firefox || print_warning "Firefox flatpak installation failed"

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
echo ""
echo "Optional: Install VS Code via RPM:"
echo "sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
echo "sudo sh -c 'echo -e \"[code]\\nname=Visual Studio Code\\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\\nenabled=1\\ngpgcheck=1\\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\" > /etc/yum.repos.d/vscode.repo'"
echo "sudo dnf install -y code"
