FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC

# Set working directory
WORKDIR /workspace

# Install essential packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    software-properties-common \
    curl \
    git \
    build-essential \
    sudo \
    ansible \
    locales \
    tzdata \
    ca-certificates \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

# Set up locales
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Create shared directories
RUN mkdir -p /shared/scripts /shared/configs

# Add a hook for running a script at container startup
COPY images/ubuntu/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Default command
CMD ["/bin/bash"]
