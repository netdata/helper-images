#!/bin/sh

# Extract the release codename from `/etc/os-release`
# The use of cut and tr here is to handle Ubuntu's multi-word codenames with capital letters.
CODENAME="$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release | cut -f 1 -d ' ' | tr '[:upper:]' '[:lower:]')"

if [ -z "${BUILD_DATE}" ] ; then
    BUILD_DATE="$(date +%F)"
fi

cd /netdata || exit 1

cp -a contrib/debian debian || exit 1

# If there's a specific control file for this OS release, use it
if [ -e "debian/control.${CODENAME}" ] ; then
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

# Copy the built packages back to the host.
cp -a /*.deb /netdata/ || exit 1

rm -rf debian || exit 1
