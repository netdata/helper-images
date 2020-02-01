#!/usr/bin/env bash
#
# Cross-arch docker build helper script
#
# Copyright: SPDX-License-Identifier: GPL-3.0-or-later
#
# Author : Pawel Krupa (paulfantom)
# Author : Paul Emm. Katsoulakis <paul@netdata.cloud>

set -e

if [ ! -f .travis.yml ]; then
	echo "Run as ./.travis/$(basename "$0") from top level directory of git repository"
	exit 1
fi

echo "Initiating helper image building"

if [ ! -z ${ARCH+x} ]; then
	# Specified architecture
	declare -a ARCHITECTURES=(${ARCH})
elif [ -z ${DEVEL+x} ]; then
	# Default architectures
	declare -a ARCHITECTURES=(i386 armhf aarch64 amd64)
else
	# Devel amd64 only
	declare -a ARCHITECTURES=(amd64)
fi

if [ ! -z ${DEVEL+x} ]; then
	unset DOCKER_PASSWORD
	unset DOCKER_USERNAME
fi

# Start paravirtualization
docker run --rm --privileged multiarch/qemu-user-static:register --reset

# Build images using multi-arch Dockerfile.
for repo in builder base; do
	for ARCH in "${ARCHITECTURES[@]}"; do
		BUILD_ARCH="${ARCH}-v3.9"
		echo "Building docker image ${repo}:${BUILD_ARCH}"
		eval docker build \
			--build-arg ARCH="${BUILD_ARCH}" \
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
		echo "Publishing image ${repo}:${ARCH}"
		docker --config /tmp/docker push "netdata/${repo}:${ARCH}"
	done
done

echo "Done!"
