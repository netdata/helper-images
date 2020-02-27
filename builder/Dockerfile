# SPDX-License-Identifier: GPL-3.0-or-later
# author  : paulfantom

# This image is used to speed up build process for official netdata images.

ARG ARCH=amd64-v3.9
FROM multiarch/alpine:${ARCH} as builder

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
                       openssl-dev \
                       libgcrypt-dev \
                       cmake

# Judy doesnt seem to be available on the repositories, download manually and install it
ENV JUDY_VER 1.0.5
RUN if [ "${ARCH}" == "aarch64" ]; then \
    echo "Executing ${ARCH} build, adding exceptional option --build for judy" \
    && wget -O /judy.tar.gz http://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VER}/Judy-${JUDY_VER}.tar.gz \
    && cd / && tar -xf judy.tar.gz && rm judy.tar.gz \
    && cd /judy-${JUDY_VER} \
    && CFLAGS="-O2 -s" CXXFLAGS="-O2 -s" ./configure --build=aarch64-unknown-linux-gnu --prefix=/deps \
    && make \
    && make install; \
    # non aarch64 branch
    else \
    wget -O /judy.tar.gz http://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VER}/Judy-${JUDY_VER}.tar.gz \
    && cd / && tar -xf judy.tar.gz && rm judy.tar.gz \
    && cd /judy-${JUDY_VER} \
    && CFLAGS="-O2 -s" CXXFLAGS="-O2 -s" ./configure --prefix=/deps \
    && make \
    && make install; \
    fi;

# freeipmi
ENV FREEIPMI_VER 1.6.4
COPY builder/patches/freeipmi-argp-redefine.patch /freeipmi-${FREEIPMI_VER}/
RUN wget -O /freeipmi.tar.gz https://ftp.gnu.org/gnu/freeipmi/freeipmi-${FREEIPMI_VER}.tar.gz \
    && cd / \
    && tar -xf freeipmi.tar.gz \
    && rm freeipmi.tar.gz \
    && cd /freeipmi-${FREEIPMI_VER} \
    && patch -p 0 < freeipmi-argp-redefine.patch \
    && rm freeipmi-argp-redefine.patch \
    && CPPFLAGS="-Dgetmsg\(a,b,c,d\)=errno=-1,-1 -Dputmsg\(a,b,c,d\)=errno=-1,-1" ./configure --prefix=/deps \
    && make \
    && make install \
    && cd / \
    && rm -rf /freeipmi-${FREEIPMI_VER}
