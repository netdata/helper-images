# This image is used to speed up build process for official netdata images.
#
# Copyright: 2019 and later Netdata Incorporated
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Author : Paul Emm. Katsoulakis <paul@netdata.rocks>
# Author : Austin S. Hemmelgarn <austiN@netdata.cloud>

# This image is used to speed up build process for official netdata images.

FROM alpine:3.14.0 as builder

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
RUN apk --no-cache add nut lm-sensors --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/main
