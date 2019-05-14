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
                       libuv-dev \
                       lz4-dev \
                       openssl-dev

# Judy doesnt seem to be available on the repositories, download manually and install it
RUN if [ "${ARCH}" == "aarch64" ]; then mkdir -p /opt/src \
    && echo "Executing ${ARCH} build, adding exceptional option --build for judy" \
    && wget -O /opt/src/judy.tar.gz http://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VER}/Judy-${JUDY_VER}.tar.gz \
    && cd /opt/src && tar -xf judy.tar.gz && rm judy.tar.gz \
    && cd /opt/src/judy-${JUDY_VER} \
    && CFLAGS="-O2 -s" CXXFLAGS="-O2 -s" ./configure --build=aarch64-unknown-linux-gnu \
    && make \
    && make install; \
    # non aarch64 branch
    else mkdir -p /opt/src \
    && wget -O /opt/src/judy.tar.gz http://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VER}/Judy-${JUDY_VER}.tar.gz \
    && cd /opt/src && tar -xf judy.tar.gz && rm judy.tar.gz \
    && cd /opt/src/judy-${JUDY_VER} \
    && CFLAGS="-O2 -s" CXXFLAGS="-O2 -s" ./configure \
    && make \
    && make install; \
    fi;

