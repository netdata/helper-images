#!/bin/sh

set -e

SRC_DIR=/usr/src/netdata
BUILD_DIR=/build
DISTRO="$(awk -F'=' '/^ID=/ {print $2}' /etc/os-release)"
DISTRO_VERSION="$(awk -F'"' '/VERSION_ID=/ {print $2}' /etc/os-release)"

mkdir -p /usr/src
cp -a /netdata "${SRC_DIR}" || exit 1
rm -rf "${SRC_DIR}/.git" || exit 1

# Properly mark the installation type.
cat > "${SRC_DIR}/system/.install-type" <<-EOF
	INSTALL_TYPE='binpkg-rpm'
	PREBUILT_ARCH='$(uname -m)'
	PREBUILT_DISTRO='${DISTRO} ${DISTRO_VERSION}'
	EOF

"${SRC_DIR}/packaging/build-package.sh" RPM "${BUILD_DIR}"

[ -d /netdata/artifacts ] || mkdir -p /netdata/artifacts

for pkg in "${BUILD_DIR}"/packages/*.rpm ; do
    mv "${pkg}" /netdata/artifacts || exit 1
done

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
