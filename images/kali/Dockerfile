FROM kalilinux/kali-rolling:latest

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
    kali-linux-core \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

# Set up locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Create shared directories
RUN mkdir -p /shared/scripts /shared/configs

# Add a hook for running a script at container startup
COPY images/kali/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Default command
CMD ["/bin/bash"]
