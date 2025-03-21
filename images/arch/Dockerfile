FROM archlinux:latest

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC

# Set working directory
WORKDIR /workspace

# Install essential packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    git \
    sudo \
    ansible \
    curl \
    python \
    python-pip \
    openssh \
    tzdata \
    && pacman -Scc --noconfirm

# Create shared directories
RUN mkdir -p /shared/scripts /shared/configs

# Add a hook for running a script at container startup
COPY images/arch/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Default command
CMD ["/bin/bash"]
