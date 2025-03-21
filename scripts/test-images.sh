#!/usr/bin/env bash
# Script to test all Docker development environments

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
echo -e "${GREEN}=== Testing Docker Development Environments ===${NC}"

# Test an image
test_image() {
    local distro=$1
    local tag="dev-$distro"

    echo -e "${YELLOW}Testing $distro image...${NC}"

    # Check if image exists
    if ! docker image inspect "$tag" &>/dev/null; then
        echo -e "${RED}Image $tag does not exist. Please build it first.${NC}"
        return 1
    fi

    # Test basic functionality
    echo -e "${YELLOW}Running basic functionality tests for $tag...${NC}"

    # Test 1: Container starts and exits properly
    echo "Test 1: Container starts and exits properly"
    if docker run --rm "$tag" echo "Container works!"; then
        echo -e "${GREEN}✓ Container starts and exits properly${NC}"
    else
        echo -e "${RED}✗ Container failed to start and exit properly${NC}"
        return 1
    fi

    # Test 2: Git is installed
    echo "Test 2: Git is installed"
    if docker run --rm "$tag" git --version; then
        echo -e "${GREEN}✓ Git is installed${NC}"
    else
        echo -e "${RED}✗ Git is not installed${NC}"
        return 1
    fi

    # Test 3: Ansible is available
    echo "Test 3: Ansible is available"
    if docker run --rm "$tag" which ansible &>/dev/null; then
        echo -e "${GREEN}✓ Ansible is available${NC}"
    else
        echo -e "${RED}✗ Ansible is not available${NC}"
        return 1
    fi

    # Test 4: Workspace directory exists
    echo "Test 4: Workspace directory exists"
    if docker run --rm "$tag" test -d /workspace; then
        echo -e "${GREEN}✓ Workspace directory exists${NC}"
    else
        echo -e "${RED}✗ Workspace directory does not exist${NC}"
        return 1
    fi

    # Test 5: Shared directory exists
    echo "Test 5: Shared directory exists"
    if docker run --rm "$tag" test -d /shared; then
        echo -e "${GREEN}✓ Shared directory exists${NC}"
    else
        echo -e "${RED}✗ Shared directory does not exist${NC}"
        return 1
    fi

    echo -e "${GREEN}All tests passed for $tag${NC}"
    return 0
}

# List of distributions to test
DISTROS=("ubuntu" "debian" "alpine" "arch" "kali")

# Test each image
FAILED=()
for distro in "${DISTROS[@]}"; do
    if ! test_image "$distro"; then
        FAILED+=("$distro")
    fi
done

# Print summary
echo -e "${GREEN}=== Test Summary ===${NC}"
if [ ${#FAILED[@]} -eq 0 ]; then
    echo -e "${GREEN}All images passed tests!${NC}"
else
    echo -e "${RED}The following images failed tests:${NC}"
    for distro in "${FAILED[@]}"; do
        echo -e "${RED}- $distro${NC}"
    done
    exit 1
fi
