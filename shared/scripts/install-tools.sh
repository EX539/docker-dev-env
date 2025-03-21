#!/usr/bin/env bash
# Common development tool installation script for Docker development environments

set -euo pipefail

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

echo "Detected OS: $OS_TYPE"
echo "Installing common development tools..."

# Install common development tools based on OS type
case $OS_TYPE in
"ubuntu" | "debian" | "kali")
    apt-get update
    apt-get install -y \
        build-essential \
        wget \
        curl \
        git \
        vim \
        tmux \
        zsh \
        unzip \
        openssh-client \
        python3-pip \
        python3-venv
    apt-get clean
    ;;
"alpine")
    apk update
    apk add --no-cache \
        build-base \
        wget \
        curl \
        git \
        vim \
        tmux \
        zsh \
        unzip \
        openssh-client \
        python3 \
        py3-pip
    ;;
"arch")
    pacman -Sy --noconfirm \
        base-devel \
        wget \
        curl \
        git \
        vim \
        tmux \
        zsh \
        unzip \
        openssh \
        python \
        python-pip
    ;;
*)
    echo "Unsupported OS: $OS_TYPE"
    exit 1
    ;;
esac

# Install common Python packages
pip3 install --no-cache-dir \
    ipython \
    pytest \
    flake8 \
    black \
    mypy

echo "Installation complete!"
