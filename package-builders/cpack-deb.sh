#!/bin/sh

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

# Embed distro info in package name.
# This is required to make the repo actually standards compliant wthout packageclouds hacks.
distid="${DISTNAME}${DISTVERS}"
for pkg in "${BUILD_DIR}"/*.deb; do
  pkgname="$(basename "${pkg}" .deb)"
  name="$(echo "${pkgname}" | cut -f 1 -d '_')"
  version="$(echo "${pkgname}" | cut -f 2 -d '_')"
  arch="$(echo "${pkgname}" | cut -f 3 -d '_')"

  newname="$(dirname "${pkgname}")/${name}_${version}+${distid}_${arch}.deb"
  mv "${pkg}" "${newname}"
done

# Copy the built packages to /netdata/artifacts (which may be bind-mounted)
# Also ensure /netdata/artifacts exists and create it if it doesn't
[ -d /netdata/artifacts ] || mkdir -p /netdata/artifacts
cp -a "${BUILD_DIR}"/*.deb /netdata/artifacts/ || exit 1

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
