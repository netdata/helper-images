# This image is used to speed up build process for official netdata images.
#
# Copyright: SPDX-License-Identifier: GPL-3.0-or-later
#
# Author : paulfantom
# Author : Paul Emm. Katsoulakis <paul@netdata.rocks>

# This image is used to speed up build process for official netdata images.

ARG ARCH=amd64-v3.12
FROM multiarch/alpine:${ARCH} as builder

ENV JUDY_VER 1.0.5

# Install some prerequisites
RUN apk --no-cache add curl \
                       fping \
                       jq \
                       json-c \
                       libmnl \
                       libuuid \
                       lm_sensors \
                       netcat-openbsd \
                       nodejs \
                       util-linux \
                       zlib \
                       libuv \
                       openssl \
                       lz4 \
                       lz4-libs \
                       libvirt-daemon \
                       libgcrypt \
                       iproute2 \
                       shadow \
                       msmtp \
                       postgresql-client \
                       mongo-c-driver \
                       python3 \
                       py3-pip \
                       protobuf \
                       snappy

# Add nut dependency from alpine-edge
RUN apk --no-cache add nut --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/main
