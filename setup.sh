#!/usr/bin/env bash
set -euo pipefail

# Create directory structure
mkdir -p images/{alpine,ubuntu,debian,arch,kali}/
mkdir -p shared/scripts
mkdir -p src

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  cat > .env << EOF
USERNAME=developer
USER_UID=$(id -u)
USER_GID=$(id -g)
SOURCE_DIR=$(pwd)/src
EOF
fi

# Create Alpine Dockerfile
cat > images/alpine/Dockerfile << 'EOF'
FROM alpine:3.19

# Set build arguments
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC

# Use a single RUN command to reduce layers
RUN apk add --no-cache \
    bash \
    curl \
    git \
    sudo \
    build-base \
    python3 \
    py3-pip \
    tzdata \
    && pip3 install --no-cache-dir ansible \
    && cp /usr/share/zoneinfo/UTC /etc/localtime \
    # Create non-root user
    && addgroup -g $USER_GID $USERNAME \
    && adduser -D -u $USER_UID -G $USERNAME -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Clean up
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Set working directory to user home
WORKDIR /home/$USERNAME

# Switch to non-root user
USER $USERNAME

CMD ["/bin/bash"]
EOF

# Create Ubuntu Dockerfile
cat > images/ubuntu/Dockerfile << 'EOF'
FROM ubuntu:22.04

# Set build arguments
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC

# Use a single RUN command to reduce layers
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
        sudo \
        build-essential \
        software-properties-common \
        locales \
        tzdata \
        python3 \
        python3-pip \
    # Set up locale
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    # Install ansible using pip (more up-to-date than repos)
    && pip3 install --no-cache-dir ansible \
    # Create non-root user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Clean up
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory to user home
WORKDIR /home/$USERNAME

# Switch to non-root user
USER $USERNAME

CMD ["/bin/bash"]
EOF

# Create Debian Dockerfile
cat > images/debian/Dockerfile << 'EOF'
FROM debian:bookworm-slim

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
        sudo \
        build-essential \
        locales \
        python3 \
        python3-pip \
        tzdata \
    # Set up locale
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    # Install ansible
    && pip3 install --no-cache-dir ansible \
    # Create non-root user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Clean up
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/$USERNAME
USER $USERNAME
CMD ["/bin/bash"]
EOF

# Create Arch Linux Dockerfile
cat > images/arch/Dockerfile << 'EOF'
FROM archlinux:base-20240221.0.204094

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed \
        git \
        sudo \
        curl \
        python \
        python-pip \
        base-devel \
    && pip install --no-cache-dir ansible \
    # Create non-root user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Clean up
    && pacman -Scc --noconfirm \
    && rm -rf /tmp/* /var/tmp/*

WORKDIR /home/$USERNAME
USER $USERNAME
CMD ["/bin/bash"]
EOF

# Create Kali Linux Dockerfile
cat > images/kali/Dockerfile << 'EOF'
FROM kalilinux/kali-rolling:latest

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
        sudo \
        build-essential \
        locales \
        python3 \
        python3-pip \
    # Set up locale
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    # Install ansible
    && pip3 install --no-cache-dir ansible \
    # Create non-root user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Clean up
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/$USERNAME
USER $USERNAME
CMD ["/bin/bash"]
EOF

# Create user setup script
cat > shared/scripts/setup-user.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

USERNAME=${1:-developer}
USER_UID=${2:-1000}
USER_GID=${3:-1000}

# Create user based on distro
if command -v apt-get > /dev/null 2>&1; then
    # Debian-based
    groupadd --gid $USER_GID $USERNAME
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
elif command -v apk > /dev/null 2>&1; then
    # Alpine
    addgroup -g $USER_GID $USERNAME
    adduser -D -u $USER_UID -G $USERNAME -s /bin/bash $USERNAME
elif command -v pacman > /dev/null 2>&1; then
    # Arch
    groupadd --gid $USER_GID $USERNAME
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
fi

# Configure sudo
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME

echo "User $USERNAME created successfully"
EOF

chmod +x shared/scripts/setup-user.sh

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  alpine:
    build:
      context: ./images/alpine
      args:
        USERNAME: ${USERNAME:-developer}
        USER_UID: ${USER_UID:-1000}
        USER_GID: ${USER_GID:-1000}
    volumes:
      - ${SOURCE_DIR:-./src}:/home/${USERNAME:-developer}/src
    tty: true
    stdin_open: true
    working_dir: /home/${USERNAME:-developer}
    command: /bin/bash

  ubuntu:
    build:
      context: ./images/ubuntu
      args:
        USERNAME: ${USERNAME:-developer}
        USER_UID: ${USER_UID:-1000}
        USER_GID: ${USER_GID:-1000}
    volumes:
      - ${SOURCE_DIR:-./src}:/home/${USERNAME:-developer}/src
    tty: true
    stdin_open: true
    working_dir: /home/${USERNAME:-developer}
    command: /bin/bash

  debian:
    build:
      context: ./images/debian
      args:
        USERNAME: ${USERNAME:-developer}
        USER_UID: ${USER_UID:-1000}
        USER_GID: ${USER_GID:-1000}
    volumes:
      - ${SOURCE_DIR:-./src}:/home/${USERNAME:-developer}/src
    tty: true
    stdin_open: true
    working_dir: /home/${USERNAME:-developer}
    command: /bin/bash

  arch:
    build:
      context: ./images/arch
      args:
        USERNAME: ${USERNAME:-developer}
        USER_UID: ${USER_UID:-1000}
        USER_GID: ${USER_GID:-1000}
    volumes:
      - ${SOURCE_DIR:-./src}:/home/${USERNAME:-developer}/src
    tty: true
    stdin_open: true
    working_dir: /home/${USERNAME:-developer}
    command: /bin/bash

  kali:
    build:
      context: ./images/kali
      args:
        USERNAME: ${USERNAME:-developer}
        USER_UID: ${USER_UID:-1000}
        USER_GID: ${USER_GID:-1000}
    volumes:
      - ${SOURCE_DIR:-./src}:/home/${USERNAME:-developer}/src
    tty: true
    stdin_open: true
    working_dir: /home/${USERNAME:-developer}
    command: /bin/bash
EOF

# Create README.md
cat > README.md << 'EOF'
# Docker Development Environment

A collection of Docker containers for cross-distribution development and testing.

## Features

- Consistent development environments across multiple Linux distributions
- Non-root user setup with sudo privileges
- Common development tools pre-installed
- Docker Compose for easy environment orchestration
- Volume mounting for convenient source code access

## Supported Distributions

- Alpine Linux 3.19
- Ubuntu 22.04
- Debian (latest stable)
- Arch Linux
- Kali Linux

## Prerequisites

- Docker
- Docker Compose

## Usage

### Starting a Container

```bash
# Launch a specific environment
docker-compose up -d ubuntu

# Get a shell in the container
docker-compose exec ubuntu bash
