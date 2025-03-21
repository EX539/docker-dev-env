#!/usr/bin/env bash
# Script to build all Docker development environments

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Print header
echo -e "${GREEN}=== Building Docker Development Environments ===${NC}"

# Build all images
build_image() {
    local distro=$1
    local tag="dev-$distro"
    local dockerfile="images/$distro/Dockerfile"

    if [ ! -f "$dockerfile" ]; then
        echo -e "${RED}Error: Dockerfile not found for $distro${NC}"
        return 1
    fi

    echo -e "${YELLOW}Building $distro image...${NC}"
    if docker build -t "$tag" -f "$dockerfile" .; then
        echo -e "${GREEN}Successfully built $tag${NC}"
        return 0
    else
        echo -e "${RED}Failed to build $tag${NC}"
        return 1
    fi
}

# List of distributions to build
DISTROS=("ubuntu" "debian" "alpine" "arch" "kali")

# Build each image
FAILED=()
for distro in "${DISTROS[@]}"; do
    if ! build_image "$distro"; then
        FAILED+=("$distro")
    fi
done

# Print summary
echo -e "${GREEN}=== Build Summary ===${NC}"
if [ ${#FAILED[@]} -eq 0 ]; then
    echo -e "${GREEN}All images built successfully!${NC}"
else
    echo -e "${RED}The following images failed to build:${NC}"
    for distro in "${FAILED[@]}"; do
        echo -e "${RED}- $distro${NC}"
    done
    exit 1
fi
