#!/usr/bin/env bash

set -exu -o pipefail

curl --fail -sSL --connect-timeout 20 --retry 3 --output /tmp/rustup-init.sh \
    "https://raw.githubusercontent.com/rust-lang/rustup/refs/tags/1.28.1/rustup-init.sh"
echo 'b25b33de9e5678e976905db7f21b42a58fb124dd098b35a962f963734b790a9b  /tmp/rustup-init.sh' | sha256sum -c - ;

EXTRA_OPTS=""

if command -v gcc ; then
    case "$(gcc -dumpmachine)" in
        i?86-linux-gnu) EXTRA_OPTS="--default-toolchain stable-i686-unknown-linux-gnu" ;;
    esac
fi

chmod u+x /tmp/rustup-init.sh
# shellcheck disable=SC2086
/tmp/rustup-init.sh -y -v ${EXTRA_OPTS}

rm /tmp/rustup-init.sh
