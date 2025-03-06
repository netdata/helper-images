#!/usr/bin/env bash

set -exu -o pipefail

curl --fail -sSL --connect-timeout 20 --retry 3 --output /tmp/rustup-init.sh \
    "https://raw.githubusercontent.com/rust-lang/rustup/refs/tags/1.28.1/rustup-init.sh"
echo 'b25b33de9e5678e976905db7f21b42a58fb124dd098b35a962f963734b790a9b  /tmp/rustup-init.sh' | sha256sum -c - ;

chmod u+x /tmp/rustup-init.sh
/tmp/rustup-init.sh -y -v

rm /tmp/rustup-init.sh
