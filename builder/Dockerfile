# SPDX-License-Identifier: GPL-3.0-or-later
# author  : paulfantom

# This image is used to speed up build process for official netdata images.

ARG ARCH=amd64-v3.9
FROM multiarch/alpine:${ARCH} as builder

ENV JUDY_VER 1.0.5

# Install prerequisites
RUN apk --no-cache add alpine-sdk \
                       autoconf \
                       automake \
                       bash \
                       build-base \
                       curl \
                       jq \
                       libmnl-dev \
                       libuuid \
                       lm_sensors \
                       netcat-openbsd \
                       nodejs \
                       pkgconfig \
                       py-mysqldb \
                       py-psycopg2 \
                       py-yaml \
                       python \
                       util-linux-dev \
                       zlib-dev \
                       libuv \
                       lz4 \
                       openssl

# Judy doesnt seem to be available on the repositories, download manually and install it
RUN mkdir -p /opt/src && wget -O /opt/src/judy.tar.gz http://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VER}/Judy-${JUDY_VER}.tar.gz \
    && cd /opt/src && tar -xf judy.tar.gz && rm judy.tar.gz \
    # Build Judy
    && cd /opt/src/judy-${JUDY_VER} \
    && CFLAGS="-O2 -s" CXXFLAGS="-O2 -s" ./configure --host="$(gcc -v 2>&1 | grep ^Target | sed -e 's/ //g' | cut -d':' -f 2)"\
    && make \
    # Install Judy
    && make install
