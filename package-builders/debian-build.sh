#!/bin/sh

# Extract the release codename from `/etc/os-release`
# The use of cut and tr here is to handle Ubuntu's multi-word codenames with capital letters.
CODENAME="$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release | cut -f 1 -d ' ' | tr '[:upper:]' '[:lower:]')"

if [ -z "${BUILD_DATE}" ]; then
  BUILD_DATE="$(date -R)"
fi

# Run the builds in an isolated source directory.
# This removes the need for cleanup, and ensures anything the build does
# doesn't muck with the user's sources.
cp -a /netdata /usr/src || exit 1
cd /usr/src/netdata || exit 1

cp -a contrib/debian debian || exit 1

# If there's a specific control file for this OS release, use it
if [ -e "debian/control.${CODENAME}" ]; then
  cp "debian/control.${CODENAME}" debian/control || exit 1
fi

# If the changelog was not updated on the host, assume this is a
# development build and update the changelog appropriately.
sed -i "s/PREVIOUS_PACKAGE_VERSION/${VERSION}/g" debian/changelog
sed -i "s/PREVIOUS_PACKAGE_DATE/${BUILD_DATE}/g" debian/changelog

# pre/post options are after 1.18.8, is simpler to just check help for their existence than parsing version
if dpkg-buildpackage --help | grep "\-\-post\-clean" 2> /dev/null > /dev/null; then
  dpkg-buildpackage --post-clean --pre-clean -b -us -uc || exit 1
else
  dpkg-buildpackage -b -us -uc || exit 1
fi

# Copy the built packages to /netdata/artifacts (which may be bind-mounted)
# Also ensure /netdata/artifacts exists and create it if it doesn't
[ -d /netdata/artifacts ] || mkdir -p /netdata/artifacts
cp -a /usr/src/*.deb /netdata/artifacts/ || exit 1

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
