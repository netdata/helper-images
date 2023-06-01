# SPDX-License-Identifier: GPL-3.0-or-later
# author  : paulfantom
# author  : Austin S. Hemmelgarn <austiN@netdata.cloud>

# This image is used to speed up build process for official netdata images.

FROM alpine:3.18 as builder

LABEL org.opencontainers.image.authors="Netdatabot <bot@netdata.cloud>"
LABEL org.opencontainers.image.source="https://github.com/netdata/helper-images"
LABEL org.opencontainers.image.title="Netdata Agent Docker Builder Image"
LABEL org.opencontainers.image.description="Builder image for official Netdata Agent Docker images."
LABEL org.opencontainers.image.vendor="Netdata Inc."

# Install prerequisites
RUN apk --no-cache add alpine-sdk \
                       autoconf \
                       automake \
                       bash \
                       build-base \
                       bison \
                       cmake \
                       curl \
                       flex \
                       jq \
                       json-c-dev \
                       yaml-dev \
                       libgcrypt-dev \
                       libmnl-dev \
                       libtool \
                       libuuid \
                       libuv-dev \
                       lm_sensors \
                       lz4-dev \
                       mariadb-dev \
                       mongo-c-driver-dev \
                       musl-dev \
                       musl-fts-dev \
                       netcat-openbsd \
                       openssl-dev \
                       pkgconfig \
                       postgresql-dev \
                       protobuf-dev \
                       py3-pip \
                       python3 \
                       python3-dev \
                       snappy-dev \
                       util-linux-dev \
                       zlib-dev \
                       zstd-dev && \
    mkdir -p /deps/etc && \
    if [ "$(uname -m)" != "ppc64le" ]; then \
        apk --no-cache add freeipmi-dev || exit 1 ; \
    fi
