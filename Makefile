.PHONY: build build-all run run-compose clean-all help

# Default distribution
DISTRO ?= ubuntu

help:
	@echo "Docker Development Environments"
	@echo ""
	@echo "Usage:"
	@echo "  make build DISTRO=<distro>    Build a specific Docker image"
	@echo "  make build-all                Build all Docker images"
	@echo "  make run DISTRO=<distro>      Run a container for a specific distribution"
	@echo "  make run-compose DISTRO=<distro> Run using docker-compose"
	@echo "  make clean-all                Remove all Docker images"
	@echo ""
	@echo "Available distributions: ubuntu, debian, alpine, arch, kali"

build:
	@echo "Building $(DISTRO) image..."
	docker build -t dev-$(DISTRO) -f images/$(DISTRO)/Dockerfile .

build-all:
	@echo "Building all Docker images..."
	@for distro in ubuntu debian alpine arch kali; do \
		echo "Building $$distro image..."; \
		docker build -t dev-$$distro -f images/$$distro/Dockerfile . || exit 1; \
	done
	@echo "All images built successfully!"

run:
	@echo "Running $(DISTRO) container..."
	docker run -it --rm \
		-v $$(pwd):/workspace \
		-v $$(pwd)/shared:/shared \
		--workdir /workspace \
		dev-$(DISTRO)

run-compose:
	@echo "Running $(DISTRO) container with docker-compose..."
	docker-compose up -d $(DISTRO)
	docker-compose exec $(DISTRO) bash

clean-all:
	@echo "Removing all Docker images..."
	docker rmi -f dev-ubuntu dev-debian dev-alpine dev-arch dev-kali 2>/dev/null || true
	@echo "All images removed!"
