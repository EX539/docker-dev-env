#!/usr/bin/env bash
# Initialization script for Arch Linux development container

set -e

# Set up the container environment
echo "Initializing Arch Linux development container..."

# Run shared setup scripts if available
if [ -f "/shared/scripts/install-tools.sh" ]; then
    echo "Running shared install-tools.sh..."
    bash /shared/scripts/install-tools.sh
fi

# Arch Linux-specific setup
echo "Setting up Arch Linux-specific configurations..."

# Enable parallel downloads in pacman if not already configured
if ! grep -q "ParallelDownloads" /etc/pacman.conf; then
    echo "Enabling parallel downloads in pacman..."
    sed -i '/\[options\]/a ParallelDownloads = 5' /etc/pacman.conf
fi

# Set up yay (AUR helper) if not already installed
if ! command -v yay &>/dev/null; then
    echo "Setting up yay AUR helper..."
    pacman -S --needed --noconfirm git base-devel

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd /
    rm -rf /tmp/yay
fi

echo "Arch Linux environment initialization complete!"

# Execute the command passed to the script
exec "$@"
