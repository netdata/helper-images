#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Author  : Pawel Krupa (paulfantom)
# Cross-arch docker build helper script

set -e

if [ ! -f .travis.yml ]; then
	echo "Run as ./.travis/$(basename "$0") from top level directory of git repository"
	exit 1
fi

if [ -z ${DEVEL+x} ]; then
    declare -a ARCHITECTURES=(i386 armhf aarch64 amd64)
else
    declare -a ARCHITECTURES=(amd64)
    unset DOCKER_PASSWORD
    unset DOCKER_USERNAME
fi

# Start paravirtualization
docker run --rm --privileged multiarch/qemu-user-static:register --reset

# Build images using multi-arch Dockerfile.
for repo in builder base; do
	for ARCH in "${ARCHITECTURES[@]}"; do
		eval docker build \
	     		--build-arg ARCH="${ARCH}-v3.9" \
	     		--tag "netdata/${repo}:${ARCH}" \
	     		--file "${repo}/Dockerfile" ./
	done
done

# There is no reason to continue if we cannot log in to docker hub
if [ -z ${DOCKER_USERNAME+x} ] || [ -z ${DOCKER_PASSWORD+x} ]; then
    echo "No docker hub username or password specified. Exiting without pushing images to registry"
    exit 0
fi

# Login to docker hub to allow futher operations
echo "$DOCKER_PASSWORD" | docker --config /tmp/docker login -u "$DOCKER_USERNAME" --password-stdin

# Push images to registry
for repo in builder base; do
	for ARCH in "${ARCHITECTURES[@]}"; do
		docker --config /tmp/docker push "netdata/${repo}:${ARCH}"
	done
done
