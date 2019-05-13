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
                       libuuid \
                       lm_sensors \
                       netcat-openbsd \
                       nodejs \
                       py-mysqldb \
                       py-psycopg2 \
                       py-yaml \
                       python \
                       util-linux \
                       libuv \
                       lz4 \
                       openssl

# Add nut dependency from alpine-edge
RUN apk --no-cache add nut --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing

# Judy doesnt seem to be available on the repositories, download manually and install it
RUN mkdir -p /opt/src && wget -O /opt/src/judy.tar.gz http://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VER}/Judy-${JUDY_VER}.tar.gz \
    && cd /opt/src && tar -xf judy.tar.gz && rm judy.tar.gz \
    # Build Judy
    && cd /opt/src/judy-${JUDY_VER} \
    && autoreconf -ivf \
    && CFLAGS="-O2 -s" CXXFLAGS="-O2 -s" ./configure \
    && make \
    # Install Judy
    && make install
