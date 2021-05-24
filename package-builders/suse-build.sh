#!/bin/sh

cp /netdata/netdata.spec.in /usr/src/packages/SPECS/netdata.spec || exit 1

pkg_version="$(echo "${VERSION}" | tr - .)"

cp -a /netdata "/usr/src/packages/SOURCES/netdata-${pkg_version}" || exit 1

# These next few steps prep the spec file for building with local sources.
# Without this, we would have to create a tarball of the local sources
# that the RPM build process would then promptly extract, which is a waste
# of time.
#
# We still use release tarballs for release builds, but that's handled
# outside of the container.
sed -i 's/^Source.*$//g' /usr/src/packages/SPECS/netdata.spec || exit 1
sed -i 's/^%setup.*$/cd %{_topdir}\n rm -rf BUILD\n mkdir -p BUILD\n cp -rfT %{_topdir}\/SOURCES\/netdata-%{version} BUILD/g' /usr/src/packages/SPECS/netdata.spec || exit 1
sed -i "s/\${RPM_BUILD_DIR}\/%{name}-%{version}/\${RPM_BUILD_DIR}/g" /usr/src/packages/SPECS/netdata.spec || exit 1

# This updates the version in the spec file appropriately.
sed -i "s/@PACKAGE_VERSION@/${pkg_version}/g" /usr/src/packages/SPECS/netdata.spec || exit 1

# Properly mark the installation type.
cat > system/.install-type <<-EOF
	INSTALL_TYPE='binpkg-rpm'
	PREBUILT_ARCH='$(uname -m)'
	PREBUILT_DISTRO='${DISTRO} ${DISTRO_VERSION}'
	EOF

rpmbuild -bb --rebuild /usr/src/packages/SPECS/netdata.spec || exit 1

# Copy the built packages to /netdata/artifacts (which may be bind-mounted)
# Also ensure /netdata/artifacts exists and create it if it doesn't
[ -d /netdata/artifacts ] || mkdir -p /netdata/artifacts
find /usr/src/packages/RPMS/ -type f -name '*.rpm' -exec cp '{}' /netdata/artifacts \; || exit 1

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
