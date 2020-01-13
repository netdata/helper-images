# This image is used to speed up build process for official netdata images.
#
# Copyright: SPDX-License-Identifier: GPL-3.0-or-later
#
# Author : paulfantom
# Author : Paul Emm. Katsoulakis <paul@netdata.rocks>

# This image is used to speed up build process for official netdata images.

ARG ARCH=amd64-v3.9
FROM multiarch/alpine:${ARCH} as builder

ENV JUDY_VER 1.0.5

# Install some prerequisites
RUN apk --no-cache add curl \
                       fping \
                       jq \
                       libmnl \
                       libuuid \
                       lm_sensors \
                       netcat-openbsd \
                       nodejs \
                       py-mysqldb \
                       py-psycopg2 \
                       py-yaml \
                       python \
                       util-linux \
                       zlib \
                       libuv \
                       openssl \
                       lz4 \
                       lz4-libs \
                       libvirt-daemon \
                       libgcrypt \
                       shadow

# Add nut dependency from alpine-edge
RUN apk --no-cache add nut --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
