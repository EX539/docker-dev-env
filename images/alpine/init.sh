#!/usr/bin/env bash
# Initialization script for Alpine development container

set -e

# Set up the container environment
echo "Initializing Alpine development container..."

# Run shared setup scripts if available
if [ -f "/shared/scripts/install-tools.sh" ]; then
    echo "Running shared install-tools.sh..."
    bash /shared/scripts/install-tools.sh
fi

# Alpine-specific setup
echo "Setting up Alpine-specific configurations..."

# Install ansible if not already installed
if ! command -v ansible &>/dev/null; then
    echo "Installing Ansible via pip..."
    pip3 install --no-cache-dir ansible
fi

# Ensure Python symlinks
if [ ! -L /usr/bin/python ] && [ -f /usr/bin/python3 ]; then
    ln -s /usr/bin/python3 /usr/bin/python
fi

echo "Alpine environment initialization complete!"

# Execute the command passed to the script
exec "$@"
