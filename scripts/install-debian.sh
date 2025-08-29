#!/bin/bash

# Debian/Ubuntu i3wm setup    exit 1
fi

# Detect distrotaller
# Author: quadeer2003

set -e

echo "=========================================="
echo "  i3wm-minimal-setup Installation Script"
echo "  Debian/Ubuntu Edition"
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

# Detect distribution
if [ -f /etc/debian_version ]; then
    if grep -q "Ubuntu" /etc/os-release; then
        DISTRO="ubuntu"
        print_status "Detected Ubuntu"
    else
        DISTRO="debian"
        print_status "Detected Debian"
    fi
else
    print_error "This script is designed for Debian/Ubuntu systems"
    exit 1
fi

# System update
print_status "Updating package lists..."
sudo apt update

print_status "Upgrading system packages..."
sudo apt upgrade -y

# Core components
print_status "Installing core components..."
sudo apt install -y \
    i3 \
    i3lock \
    i3status \
    kitty \
    fish

# Essential tools
print_status "Installing essential tools..."
sudo apt install -y \
    lightdm \
    lightdm-gtk-greeter \
    pulseaudio \
    pulseaudio-utils \
    pavucontrol \
    network-manager \
    network-manager-gnome \
    xss-lock \
    dmenu \
    policykit-1-gnome \
    dex

# Visual tools
print_status "Installing visual enhancement tools..."
sudo apt install -y \
    polybar \
    picom \
    feh \
    python3-pip \
    curl \
    wget \
    git

# Install pywal
print_status "Installing pywal..."
pip3 install --user pywal

# Install Albert
if apt search albert 2>/dev/null | grep -q "albert"; then
    print_status "Installing Albert..."
    sudo apt install -y albert
else
    print_warning "Albert not available in repositories, skipping..."
fi

# Dev tools
print_status "Installing development tools..."

# Install Neovim
if ! command -v nvim &> /dev/null; then
    print_status "Installing Neovim..."
    cd /tmp
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
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

cd /tmp
git clone https://github.com/quadeer2003/nvim-dots.git
mv nvim-dots ~/.config/nvim
print_success "nvim-dots configuration installed"

# Install development tools
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
sudo apt install -y \
    fonts-jetbrains-mono

# Install Nerd Fonts manually if needed
if ! fc-list | grep -i "nerd" > /dev/null; then
    print_status "Installing Nerd Fonts..."
    mkdir -p ~/.local/share/fonts
    cd /tmp
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/
    fc-cache -fv
    print_success "Nerd Fonts installed"
fi

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

# Check if we're in the correct repository structure
if [[ -d "$REPO_DIR/configs" ]]; then
    print_status "Found config files, copying to user directories..."
    
    # Copy i3 config
    if [[ -f "$REPO_DIR/configs/i3.config" ]]; then
        cp "$REPO_DIR/configs/i3.config" ~/.config/i3/config
        print_success "i3 config copied"
    fi
    
    # Copy kitty config
    if [[ -f "$REPO_DIR/configs/kitty.conf" ]]; then
        cp "$REPO_DIR/configs/kitty.conf" ~/.config/kitty/kitty.conf
        print_success "Kitty config copied"
    fi
    
    # Copy fish config
    if [[ -f "$REPO_DIR/configs/fish.config" ]]; then
        cp "$REPO_DIR/configs/fish.config" ~/.config/fish/config.fish
        print_success "Fish config copied"
        
        # Add Neovim to PATH in fish config
        if ! grep -q "/opt/nvim-linux-x86_64/bin" ~/.config/fish/config.fish 2>/dev/null; then
            echo 'set -gx PATH $PATH /opt/nvim-linux-x86_64/bin' >> ~/.config/fish/config.fish
            print_success "Neovim added to fish PATH"
        fi
    fi
    
    # Copy polybar config
    if [[ -f "$REPO_DIR/configs/polybar.config" ]]; then
        cp "$REPO_DIR/configs/polybar.config" ~/.config/polybar/config.ini
        print_success "Polybar config copied"
    fi
    
    # Copy picom config
    if [[ -f "$REPO_DIR/configs/picom.config" ]]; then
        cp "$REPO_DIR/configs/picom.config" ~/.config/picom/picom.conf
        print_success "Picom config copied"
    fi
    
    print_success "All configuration files copied successfully!"
else
    print_warning "Config files not found. Please manually copy configs after installation."
fi

# Create a sample wallpaper directory with a default wallpaper
print_status "Setting up wallpapers directory..."
if [[ ! -d ~/Wallpapers ]]; then
    mkdir -p ~/Wallpapers
fi

# Download a sample wallpaper if none exists
if [[ -z "$(ls -A ~/Wallpapers)" ]]; then
    print_status "Downloading a sample wallpaper..."
    curl -s -o ~/Wallpapers/sample.jpg "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop" || print_warning "Failed to download sample wallpaper"
fi

# Additional setup for Ubuntu
if [[ $DISTRO == "ubuntu" ]]; then
    print_status "Performing Ubuntu-specific setup..."
    # Install snap packages if needed
    if command -v snap &> /dev/null; then
        print_status "Installing snap packages..."
        sudo snap install code --classic 2>/dev/null || print_warning "VS Code snap installation failed"
    fi
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
echo ""
echo "Note: Some packages might not be available in older Debian/Ubuntu versions."
echo "Consider adding additional repositories or building from source if needed."
