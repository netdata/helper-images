#!/bin/sh

set -e

SRC_DIR=/usr/src/netdata
BUILD_DIR=/build

cp -a /netdata "${SRC_DIR}" || exit 1
rm -rf "${SRC_DIR}/.git" || exit 1

# Properly mark the installation type.
cat > "${SRC_DIR}/system/.install-type" <<-EOF
	INSTALL_TYPE='binpkg-deb'
	PREBUILT_ARCH='$(uname -m)'
	PREBUILT_DISTRO='${DISTRO} ${DISTRO_VERSION}'
	EOF

"${SRC_DIR}/packaging/build-package.sh" DEB "${BUILD_DIR}"

[ -d /netdata/artifacts ] || mkdir -p /netdata/artifacts

# Embed distro info in package name.
# This is required to make the repo actually standards compliant wthout packageclouds hacks.
distid="${DISTNAME}${DISTVERS}"
for pkg in "${BUILD_DIR}"/packages/*.deb "${BUILD_DIR}"/packages/*.ddeb; do
  extension="${pkg##*.}"
  pkgname="$(basename "${pkg}" "${extension}")"
  name="$(echo "${pkgname}" | cut -f 1 -d '_')"
  version="$(echo "${pkgname}" | cut -f 2 -d '_')"
  arch="$(echo "${pkgname}" | cut -f 3 -d '_')"

  newname="/netdata/artifacts/${name}_${version}+${distid}_${arch}${extension}"
  mv "${pkg}" "${newname}" || exit 1
done

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
