#!/usr/bin/env bash

set -exu -o pipefail

curl \
    --fail -sSL --connect-timeout 20 --retry 3 --output /tmp/rustup.sh \
    "https://sh.rustup.rs"
chmod u+x /tmp/rustup.sh

/tmp/rustup.sh -y -v
rm /tmp/rustup.sh
