#!/bin/sh

cp /netdata/netdata.spec.in /root/rpmbuild/SPECS/netdata.spec || exit 1

pkg_version="$(echo "${VERSION}" | tr - .)"

cp -a /netdata "/root/rpmbuild/SOURCES/netdata-${pkg_version}" || exit 1
rm -rf "/root/rpmbuild/SOURCES/netdata-${pkg_version}/.git" || exit 1

. /etc/os-release

# These next few steps prep the spec file for building with local sources.
# Without this, we would have to create a tarball of the local sources
# that the RPM build process would then promptly extract, which is a waste
# of time.
#
# We still use release tarballs for release builds, but that's handled
# outside of the container.
sed -i 's/^Source0.*$//g' /root/rpmbuild/SPECS/netdata.spec || exit 1

if [ "${ID}" = "fedora" ] && [ "${VERSION_ID}" -ge 41 ]; then
    sed -i 's/^%setup.*$/cd %{_topdir}\n rm -rf BUILD\n mkdir -p BUILD\n cp -rf %{_topdir}\/SOURCES\/netdata-%{version} BUILD\/netdata-%{version}-build/g' /root/rpmbuild/SPECS/netdata.spec || exit 1
else
    sed -i 's/^%setup.*$/cd %{_topdir}\n rm -rf BUILD\n mkdir -p BUILD\n cp -rfT %{_topdir}\/SOURCES\/netdata-%{version} BUILD/g' /root/rpmbuild/SPECS/netdata.spec || exit 1
    sed -i "s/\${RPM_BUILD_DIR}\/%{name}-%{version}/\${RPM_BUILD_DIR}/g" /root/rpmbuild/SPECS/netdata.spec || exit 1
fi

# This updates the version in the spec file appropriately.
sed -i "s/@PACKAGE_VERSION@/${pkg_version}/g" /root/rpmbuild/SPECS/netdata.spec || exit 1

# Properly mark the installation type.
cat > "/root/rpmbuild/SOURCES/netdata-${pkg_version}/system/.install-type" <<-EOF
	INSTALL_TYPE='binpkg-rpm'
	PREBUILT_ARCH='$(uname -m)'
	PREBUILT_DISTRO='${DISTRO} ${DISTRO_VERSION}'
	EOF

# Download Sources
rpmbuild --nobuild \
         --define "_upstream_go_toolchain 1" \
         --define "_topdir /root/rpmbuild/SOURCES" \
         --define "_sourcedir /root/rpmbuild/SOURCES" \
         --define "source_date_epoch_from_changelog false" \
         --undefine "_disable_source_fetch" \
         "/root/rpmbuild/SPECS/netdata.spec" || exit 1

rpmbuild -bb --define "_upstream_go_toolchain 1" --rebuild /root/rpmbuild/SPECS/netdata.spec || exit 1

# Copy the built packages to /netdata/artifacts (which may be bind-mounted)
# Also ensure /netdata/artifacts exists and create it if it doesn't
[ -d /netdata/artifacts ] || mkdir -p /netdata/artifacts
find /root/rpmbuild/RPMS/ -type f -name '*.rpm' -exec cp '{}' /netdata/artifacts/ \; || exit 1

# Correct ownership of the artifacts.
# Without this, the artifacts directory and it's contents end up owned
# by root instead of the local user on Linux boxes
chown -R --reference=/netdata /netdata/artifacts
