#!/bin/bash -e

BLUE='\E[1;34m'
CYAN='\E[1;36m'
YELLOW='\E[1;33m'
GREEN='\E[1;32m'
RESET='\E[0m'

IMAGE="rpmbuild-rocky9"
# PLATFORMS=linux/amd64,linux/arm64
PLATFORMS=linux/amd64

export BASE_IMAGE="${IMAGE}:latest"
export GOLANG_IMAGE="${DOCKER_IMAGE}:golang"
export RUST_IMAGE="${DOCKER_IMAGE}:rust"
export HASKELL_IMAGE="${DOCKER_IMAGE}:haskell"

# Setup

docker buildx rm "${BUILDX_NAME:-rpmbuild8}" || echo
docker buildx create --name "${BUILDX_NAME:-rpmbuild8}" || echo
docker buildx use "${BUILDX_NAME:-rpmbuild8}"

# Builds

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}latest ${CYAN}...${RESET}"
docker buildx build \
	--platform "$PLATFORMS" \
	--progress plain \
	--pull \
	--push \
	-t "$BASE_IMAGE" \
	-f docker/Dockerfile \
	.

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}golang ${CYAN}...${RESET}"
docker buildx build \
	--platform "$PLATFORMS" \
	--progress plain \
	--push \
	--build-arg BASE_IMAGE \
	-t "$GOLANG_IMAGE" \
	-f docker/Dockerfile.golang \
	.

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}rust ${CYAN}...${RESET}"
docker buildx build \
	--platform "$PLATFORMS" \
	--progress plain \
	--push \
	--build-arg BASE_IMAGE \
	-t "$RUST_IMAGE" \
	-f docker/Dockerfile.rust \
	.

echo -e "${BLUE}❯ ${CYAN}Building ${YELLOW}haskell ${CYAN}...${RESET}"
docker buildx build \
	--platform "$PLATFORMS" \
	--progress plain \
	--push \
	--build-arg BASE_IMAGE \
	-t "$HASKELL_IMAGE" \
	-f docker/Dockerfile.haskell \
	.

docker buildx rm "${BUILDX_NAME:-rpmbuild9}"

echo -e "${BLUE}❯ ${GREEN}All done!${RESET}"
