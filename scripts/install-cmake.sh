#!/bin/sh
# Install the pinned CMake release used by the RPM v2 package builders.
# CPack only emits RPM weak dependencies (Recommends/Suggests) from CMake 4.1
# on, and the container entrypoint prefers /cmake/bin when present.
# The hashes are hard-coded here to mitigate the risk of supply-chain attacks;
# they come from the cmake-${CMAKE_VERSION}-SHA-256.txt upstream release asset.
set -eu

CMAKE_VERSION=4.1.6

case "$(uname -m)" in
    x86_64)
        cmake_arch=x86_64
        cmake_sha256=d5c2e72820e01f1c3a07092d0a29e209263a7d22f55b4ad7f414ee870ae6b8e0
        ;;
    aarch64)
        cmake_arch=aarch64
        cmake_sha256=8b3e3af8e4b4e95224a4490f4772adb7a512be34c8380fe76e7be003e0fd4394
        ;;
    *)
        echo "No CMake binary release for $(uname -m)" >&2
        exit 1
        ;;
esac

tarball="cmake-${CMAKE_VERSION}-linux-${cmake_arch}.tar.gz"

curl --fail -sSL --connect-timeout 20 --retry 3 --max-time 600 --output "/tmp/${tarball}" \
     "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${tarball}"
echo "${cmake_sha256}  /tmp/${tarball}" | sha256sum -c -
tar -xzf "/tmp/${tarball}" -C /opt
rm -f "/tmp/${tarball}"

# Fail the image build if a future release changes the tarball layout; a
# dangling /cmake symlink would otherwise make the entrypoint silently fall
# back to the distro CMake.
test -x "/opt/cmake-${CMAKE_VERSION}-linux-${cmake_arch}/bin/cmake"

# -T so a pre-existing /cmake directory fails the build instead of silently
# nesting the symlink inside it.
ln -sT "/opt/cmake-${CMAKE_VERSION}-linux-${cmake_arch}" /cmake
