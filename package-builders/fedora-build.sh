#!/bin/sh

cp /netdata/netdata.spec.in /root/rpmbuild/SPECS/netdata.spec || exit 1

cp -a /netdata "/root/rpmbuild/SOURCES/netdata-${VERSION}" || exit 1

# These next few steps prep the spec file for building with local sources.
# Without this, we would have to create a tarball of the local sources
# that the RPM build process would then promptly extract, which is a waste
# of time.
#
# We still use release tarballs for release builds, but that's handled
# outside of the container.
sed -i 's/^Source.*$//g' /root/rpmbuild/SPECS/netdata.spec || exit 1
sed -i 's/^%setup.*$/cd %{_topdir}\n rm -rf BUILD\n cp -rf %{_topdir}\/SOURCES\/netdata-%{version} BUILD/g' /root/rpmbuild/SPECS/netdata.spec || exit 1

# This updates the version in the spec file appropriately.
sed -i "s/@PACKAGE_VERSION@/${VERSION}/g" /root/rpmbuild/SPECS/netdata.spec || exit 1

rpmbuild -bb --rebuild /root/rpmbuild/SPECS/netdata.spec || exit 1

# Copy the built packages to /netdata/artifacts (which may be bind-mounted)
# Also ensure /netdata/artifacts exists and create it if it doesn't
[ -d /netdata/artifacts ] || mkdir -p /netdata/artifacts
find /root/rpmbuild/RPMS/ -type f -name '*.rpm' -exec cp '{}' /netdata/artifacts/ \; || exit 1

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
