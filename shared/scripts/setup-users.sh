#!/usr/bin/env bash
# Script to set up a non-root user in the development container

set -euo pipefail

USERNAME=${1:-"developer"}
USER_UID=${2:-1000}
USER_GID=${3:-1000}

# Detect OS type
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_TYPE=$ID
elif [ -f /etc/alpine-release ]; then
    OS_TYPE="alpine"
elif command -v pacman &>/dev/null; then
    OS_TYPE="arch"
else
    echo "Unable to determine OS type"
    exit 1
fi

echo "Setting up user '$USERNAME' with UID:$USER_UID and GID:$USER_GID"

# Create user based on OS type
case $OS_TYPE in
"ubuntu" | "debian" | "kali")
    groupadd -g "$USER_GID" -o "$USERNAME"
    useradd -m -u "$USER_UID" -g "$USER_GID" -o -s /bin/bash "$USERNAME"
    apt-get update
    apt-get install -y sudo
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/"$USERNAME"
    chmod 0440 /etc/sudoers.d/"$USERNAME"
    ;;
"alpine")
    addgroup -g "$USER_GID" -S "$USERNAME"
    adduser -u "$USER_UID" -S "$USERNAME" -G "$USERNAME" -s /bin/ash
    apk add --no-cache sudo
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/"$USERNAME"
    chmod 0440 /etc/sudoers.d/"$USERNAME"
    ;;
"arch")
    groupadd -g "$USER_GID" -o "$USERNAME"
    useradd -m -u "$USER_UID" -g "$USER_GID" -o -s /bin/bash "$USERNAME"
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/"$USERNAME"
    chmod 0440 /etc/sudoers.d/"$USERNAME"
    ;;
*)
    echo "Unsupported OS: $OS_TYPE"
    exit 1
    ;;
esac

# Create workspace directory and set permissions
mkdir -p /workspace
chown "$USERNAME":"$USERNAME" /workspace

# Set up bash configuration
if [ -d /shared/configs ]; then
    if [ -f /shared/configs/bashrc ]; then
        cp /shared/configs/bashrc /home/"$USERNAME"/.bashrc
        chown "$USERNAME":"$USERNAME" /home/"$USERNAME"/.bashrc
    fi
    if [ -f /shared/configs/vimrc ]; then
        mkdir -p /home/"$USERNAME"/.vim
        cp /shared/configs/vimrc /home/"$USERNAME"/.vimrc
        chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.vim /home/"$USERNAME"/.vimrc
    fi
fi

echo 'User "$USERNAME" has been set up successfully!'
