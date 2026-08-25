#!/usr/bin/env bash
#
# Installs sccache from upstream release binaries.
#
# Distro sccache packages are frequently built without the S3/opendal backend.
# Such a build accepts SCCACHE_BUCKET and credentials, then silently falls back
# to an on-disk cache, which is discarded with the build container. Upstream
# release binaries always carry the cloud backends.

set -exu -o pipefail

SCCACHE_VERSION="v0.17.0"

case "$(uname -m)" in
    x86_64)          target="x86_64-unknown-linux-musl";   sha256="67c4a96dd237c1f518f6b36083f270f9976d516f1e57fce891755ea782e50006" ;;
    aarch64|arm64)   target="aarch64-unknown-linux-musl";  sha256="821a86343191aa1cbab74bd42f9e93c9a63bf85e4742945f40d3ae84193c1c77" ;;
    armv7l|armv6l)   target="armv7-unknown-linux-musleabi"; sha256="6d35509fba5df6553893b33883054ec8994e9be97d669f965aa30bcc96c9b685" ;;
    i?86)            target="i686-unknown-linux-musl";     sha256="07cb06858d70e6d91678b1e8ed347c880ffd285c90ee4de3018384f1093c0dbf" ;;
    *)               echo "No sccache release for $(uname -m); skipping." >&2 ; exit 0 ;;
esac

archive="sccache-${SCCACHE_VERSION}-${target}.tar.gz"

curl --fail -sSL --connect-timeout 20 --max-time 600 --retry 3 --output "/tmp/${archive}" \
    "https://github.com/mozilla/sccache/releases/download/${SCCACHE_VERSION}/${archive}"
echo "${sha256}  /tmp/${archive}" | sha256sum -c -

tar -xzf "/tmp/${archive}" -C /tmp
install -m 0755 "/tmp/sccache-${SCCACHE_VERSION}-${target}/sccache" /usr/local/bin/sccache
install -D -m 0644 "/tmp/sccache-${SCCACHE_VERSION}-${target}/LICENSE" \
    /usr/share/licenses/sccache/LICENSE
rm -rf "/tmp/${archive}" "/tmp/sccache-${SCCACHE_VERSION}-${target}"

# Fail loudly now rather than silently degrading at build time.
sccache --version
