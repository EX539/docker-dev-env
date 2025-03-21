#!/usr/bin/env bash
# Initialization script for Kali Linux development container

set -e

# Set up the container environment
echo "Initializing Kali Linux development container..."

# Run shared setup scripts if available
if [ -f "/shared/scripts/install-tools.sh" ]; then
    echo "Running shared install-tools.sh..."
    bash /shared/scripts/install-tools.sh
fi

# Kali Linux-specific setup
echo "Setting up Kali Linux-specific configurations..."

# Check if any security tools are requested for installation
if [ -n "${INSTALL_SECURITY_TOOLS:-}" ]; then
    echo "Installing requested security tools..."
    apt-get update

    # Install basic security tools
    apt-get install -y \
        nmap \
        nikto \
        metasploit-framework \
        hydra \
        sqlmap \
        wireshark \
        burpsuite \
        dirb

    apt-get clean
fi

# Add Kali repository signing key if missing
if [ ! -f /etc/apt/trusted.gpg.d/kali-archive-keyring.gpg ]; then
    echo "Adding Kali repository signing key..."
    apt-get update
    apt-get install -y kali-archive-keyring
fi

echo "Kali Linux environment initialization complete!"

# Execute the command passed to the script
exec "$@"
