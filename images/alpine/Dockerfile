FROM alpine:latest

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC

# Set working directory
WORKDIR /workspace

# Install essential packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    curl \
    git \
    sudo \
    build-base \
    python3 \
    py3-pip \
    openssl \
    ca-certificates \
    tzdata \
    bash \
    && rm -rf /var/cache/apk/*

# Add bash as a login shell
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Set timezone
RUN cp /usr/share/zoneinfo/UTC /etc/localtime

# Create shared directories
RUN mkdir -p /shared/scripts /shared/configs

# Add a hook for running a script at container startup
COPY images/alpine/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Default command
CMD ["/bin/bash"]
