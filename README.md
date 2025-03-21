# Docker Development Environments

A collection of Docker environments for development across multiple Linux distributions. This project provides consistent, reproducible development environments that can be used for testing, development, and CI/CD pipelines.

## Overview

This repository contains Dockerfiles for various Linux distributions, configured with common development tools and utilities. Each environment is designed to be lightweight yet functional for software development.

Currently supported distributions:

- Ubuntu (latest)
- Debian (latest)
- Arch Linux
- Alpine Linux
- Kali Linux

## Quick Start

### Prerequisites

- Docker installed on your system
- Make (optional, for using the Makefile)

### Building Images

Build all images:

```bash
make build-all
```

Or build a specific image:

```bash
make build DISTRO=ubuntu
```

### Running Containers

Start a container for a specific distribution:

```bash
make run DISTRO=ubuntu
```

This will start an interactive shell in the container with the current directory mounted at `/workspace`.

## Docker Compose

For more complex setups, you can use the provided docker-compose.yml:

```bash
docker-compose up -d ubuntu
docker-compose exec ubuntu bash
```

## Image Details

Each Docker image includes:

- Git for version control
- Ansible for automation
- Build tools appropriate for the distribution
- Sudo for privilege escalation
- UTF-8 locale configuration

### Alpine Linux

Lightweight container based on Alpine, ideal for minimal environments and CI/CD pipelines.

```bash
docker build -t dev-alpine ./images/alpine
docker run -it --rm -v $(pwd):/workspace dev-alpine
```

### Arch Linux

Rolling release distribution with up-to-date packages.

```bash
docker build -t dev-arch ./images/arch
docker run -it --rm -v $(pwd):/workspace dev-arch
```

### Debian

Stable distribution with excellent package availability.

```bash
docker build -t dev-debian ./images/debian
docker run -it --rm -v $(pwd):/workspace dev-debian
```

### Kali Linux

Security-focused distribution with penetration testing tools.

```bash
docker build -t dev-kali ./images/kali
docker run -it --rm -v $(pwd):/workspace dev-kali
```

### Ubuntu

Popular distribution with extensive community support.

```bash
docker build -t dev-ubuntu ./images/ubuntu
docker run -it --rm -v $(pwd):/workspace dev-ubuntu
```

## Customization

### Adding Additional Packages

Each Dockerfile can be customized to include additional packages needed for your development workflow. Simply modify the relevant Dockerfile to add more packages during the build process.

Example for Ubuntu:

```dockerfile
RUN apt-get update && \
    apt-get install -y \
    your-package-1 \
    your-package-2 \
    # Add more packages here
    && apt-get clean
```

### Adding Custom Configuration

Mount custom configuration files into the container or add them to the shared/configs directory.

Example:

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -v ~/.gitconfig:/root/.gitconfig \
  dev-ubuntu
```

### Creating a Custom User

By default, containers run as root. For a more realistic development environment, you can create a custom user:

```bash
# Using the provided script
docker run -it --rm \
  -v $(pwd):/workspace \
  dev-ubuntu \
  /shared/scripts/setup-user.sh myusername
```

## Use Cases

### Local Development

Use these containers to ensure consistent development environments across a team:

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -p 3000:3000 \
  dev-ubuntu
```

### CI/CD Pipelines

These images can be used in CI/CD pipelines to ensure consistent testing environments:

```yaml
# Example GitLab CI configuration
test:
  image: yourrepo/dev-ubuntu:latest
  script:
    - cd /builds/your-project
    - ./run-tests.sh
```

### Cross-Platform Testing

Test your applications on different Linux distributions to ensure compatibility:

```bash
# Test on Ubuntu
docker run -it --rm -v $(pwd):/app dev-ubuntu ./run-tests.sh

# Test on Alpine
docker run -it --rm -v $(pwd):/app dev-alpine ./run-tests.sh
```

## Project Structure

```
docker-dev-env/
├── Makefile
├── README.md
├── docker-compose.yml
├── .dockerignore
├── images/
│   ├── alpine/
│   │   ├── Dockerfile
│   │   └── init.sh
│   ├── arch/
│   │   ├── Dockerfile
│   │   └── init.sh
│   ├── debian/
│   │   ├── Dockerfile
│   │   └── init.sh
│   ├── kali/
│   │   ├── Dockerfile
│   │   └── init.sh
│   └── ubuntu/
│       ├── Dockerfile
│       └── init.sh
├── scripts/
│   ├── build-all.sh
│   └── test-images.sh
└── shared/
    ├── configs/
    │   ├── bashrc
    │   ├── gitconfig
    │   └── vimrc
    └── scripts/
        ├── install-tools.sh
        └── setup-user.sh
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
