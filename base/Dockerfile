# This image is used to speed up build process for official netdata images.
#
# Copyright: 2019 and later Netdata Incorporated
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Author : Paul Emm. Katsoulakis <paul@netdata.rocks>
# Author : Austin S. Hemmelgarn <austiN@netdata.cloud>

# This image is used to speed up build process for official netdata images.

FROM alpine:3.17 as builder

LABEL org.opencontainers.image.authors="Netdatabot <bot@netdata.cloud>"
LABEL org.opencontainers.image.source="https://github.com/netdata/helper-images"
LABEL org.opencontainers.image.title="Netdata Agent Docker Base Image"
LABEL org.opencontainers.image.description="Base image for official Netdata Agent Docker images."
LABEL org.opencontainers.image.vendor="Netdata Inc."

# Install some prerequisites
RUN apk --no-cache add apcupsd \
                       curl \
                       fping \
                       iproute2 \
                       jq \
                       json-c \
                       libgcrypt \
                       libmnl \
                       libuuid \
                       libuv \
                       libvirt-daemon \
                       lm-sensors \
                       lz4 \
                       lz4-libs \
                       mongo-c-driver \
                       msmtp \
                       ncurses \
                       netcat-openbsd \
                       nut \
                       openssl \
                       postgresql-client \
                       protobuf \
                       py3-pip \
                       python3 \
                       shadow \
                       snappy \
                       util-linux \
                       zlib && \
    if [ "$(uname -m)" != "ppc64le" ]; then \
        apk --no-cache add freeipmi freeipmi-libs || exit 1 ; \
    fi

# Add extra dependencies from alpine-edge
#RUN apk --no-cache \
#        --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
#        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
#        add
