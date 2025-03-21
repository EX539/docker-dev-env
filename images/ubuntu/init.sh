#!/usr/bin/env bash
# Initialization script for Ubuntu development container

set -e

# Set up the container environment
echo "Initializing Ubuntu development container..."

# Run shared setup scripts if available
if [ -f "/shared/scripts/install-tools.sh" ]; then
    echo "Running shared install-tools.sh..."
    bash /shared/scripts/install-tools.sh
fi

# Additional Ubuntu-specific setup can go here
echo "Ubuntu environment initialization complete!"

# Execute the command passed to the script
exec "$@"
