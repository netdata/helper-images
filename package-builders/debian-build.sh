#!/bin/sh

# Extract specific release info from `/etc/os-release`
# The use of cut and tr here is to handle Ubuntu's multi-word codenames with capital letters.
CODENAME="$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release | cut -f 1 -d ' ' | tr '[:upper:]' '[:lower:]')"
DISTVERS="$(awk -F'"' '/VERSION_ID=/ {print $2}' /etc/os-release)"
DISTNAME="$(awk -F'=' '/^ID=/ {print $2}' /etc/os-release)"

# Explicitly opt out of LTO, we don’t want it.
export DEB_BUILD_MAINT_OPTIONS=optimize=-lto

if [ -z "${BUILD_DATE}" ]; then
  BUILD_DATE="$(date -R)"
fi

# If libipmimonitoring.pc is borked, fix it.
for path in $(pkg-config --variable pc_path pkg-config | tr ':' ' '); do
  if [ -e "${path}/libipmimonitoring.pc/libipmimonitoring.pc" ] ; then
    mv "${path}/libipmimonitoring.pc" tmp/libipmimonitoring
    mv tmp/libipmimonitoring/libipmimonitoring.pc "${path}"
    break
  fi
done

# Run the builds in an isolated source directory.
# This removes the need for cleanup, and ensures anything the build does
# doesn't muck with the user's sources.
cp -a /netdata /usr/src || exit 1
rm -rf /usr/src/netdata/.git || exit 1
cd /usr/src/netdata || exit 1

# If the `debian` directory is not in the root of the source tree, copy it there.
if [ ! -d debian ]; then
    cp -a contrib/debian debian || exit 1
fi

# If there's a specific control file for this OS release, use it
if [ -e "debian/control.${CODENAME}" ]; then
  cp "debian/control.${CODENAME}" debian/control || exit 1
fi

# Remove the build dependency on Golang, since we provide our own
# toolchain for that independent of the distro packages.
sed -i -e '/^ *golang.*,$/d' debian/control

# If the changelog was not updated on the host, assume this is a
# development build and update the changelog appropriately.
# shellcheck disable=SC2153
sed -i "s/PREVIOUS_PACKAGE_VERSION/${VERSION}/g" debian/changelog
sed -i "s/PREVIOUS_PACKAGE_DATE/${BUILD_DATE}/g" debian/changelog

# Properly mark the installation type.
cat > system/.install-type <<-EOF
	INSTALL_TYPE='binpkg-deb'
	PREBUILT_ARCH='$(uname -m)'
	PREBUILT_DISTRO='${DISTRO} ${DISTRO_VERSION}'
	EOF

# pre/post options are after 1.18.8, is simpler to just check help for their existence than parsing version
if dpkg-buildpackage --help | grep "\-\-post\-clean" 2> /dev/null > /dev/null; then
  dpkg-buildpackage --post-clean --pre-clean -b -us -uc || exit 1
else
  dpkg-buildpackage -b -us -uc || exit 1
fi

# Embed distro info in package name.
# This is required to make the repo actually standards compliant wthout packageclouds hacks.
distid="${DISTNAME}${DISTVERS}"
for pkg in /usr/src/*.deb; do
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
cp -a /usr/src/netdata/*.deb /netdata/artifacts/ || exit 1

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
