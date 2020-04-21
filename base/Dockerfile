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

# Conditional subscription to Polyverse's Polymorphic Linux repositories
RUN if [ "$(uname -m)" == "x86_64" ]; then \
        apk upgrade --no-cache && \
        apk add --no-cache curl && \
        curl https://sh.polyverse.io | sh -s install gcxce5byVQbtRz0iwfGkozZwy support+netdata@polyverse.io; \
        if [ $? -eq 0 ]; then \
                apk update && \
                apk upgrade --available --no-cache && \
                sed -in 's/^#//g' /etc/apk/repositories; \
        fi \
    fi && \
# Install some prerequisites
    apk --no-cache add curl \
                       fping \
                       jq \
                       json-c \
                       libmnl \
                       libuuid \
                       lm_sensors \
                       netcat-openbsd \
                       nodejs \
                       py-mysqldb \
                       py-psycopg2 \
                       py-yaml \
                       py-pip \
                       python \
                       util-linux \
                       zlib \
                       libuv \
                       openssl \
                       lz4 \
                       lz4-libs \
                       libvirt-daemon \
                       libgcrypt \
                       shadow && \
# Add Python dependencies from PyPi using `pip` we have not APK(s) for:
    pip install pymongo && \
# Add nut dependency from alpine-edge
    apk --no-cache add nut --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
