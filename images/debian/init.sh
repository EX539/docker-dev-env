#!/usr/bin/env bash
# Initialization script for Debian development container

set -e

# Set up the container environment
echo "Initializing Debian development container..."

# Run shared setup scripts if available
if [ -f "/shared/scripts/install-tools.sh" ]; then
    echo "Running shared install-tools.sh..."
    bash /shared/scripts/install-tools.sh
fi

# Additional Debian-specific setup can go here
# For example, set up APT sources or Debian-specific tools
if [ ! -f /etc/apt/sources.list.d/backports.list ]; then
    echo "Setting up Debian backports repository..."
    echo "deb http://deb.debian.org/debian $(lsb_release -cs)-backports main" >/etc/apt/sources.list.d/backports.list
    apt-get update
fi

echo "Debian environment initialization complete!"

# Execute the command passed to the script
exec "$@"
