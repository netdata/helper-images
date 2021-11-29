# SPDX-License-Identifier: GPL-3.0-or-later
# author  : paulfantom
# author  : Austin S. Hemmelgarn <austiN@netdata.cloud>

# This image is used to speed up build process for official netdata images.

FROM alpine:3.15.0 as builder

# Install prerequisites
RUN apk --no-cache add alpine-sdk \
                       autoconf \
                       automake \
                       bash \
                       build-base \
                       curl \
                       jq \
                       json-c-dev \
                       libmnl-dev \
                       libtool \
                       libuuid \
                       lm_sensors \
                       netcat-openbsd \
                       nodejs \
                       pkgconfig \
                       py3-pip \
                       python3 \
                       python3-dev \
                       util-linux-dev \
                       zlib-dev \
                       libuv-dev \
                       lz4-dev \
                       openssl-dev \
                       libgcrypt-dev \
                       mariadb-dev \
                       cmake \
                       musl-dev \
                       postgresql-dev \
                       mongo-c-driver-dev \
                       protobuf-dev \
                       snappy-dev

# Add Python dependencies from PyPi using `pip`
COPY builder/requirements.txt /tmp/requirements.txt
RUN pip install wheel && \
    pip wheel -w /wheels -r /tmp/requirements.txt

# External dependencies (bundled to avoid network access)
COPY deps /deps

# freeipmi
ENV FREEIPMI_VER 1.6.4
COPY builder/patches/freeipmi-argp-redefine.patch /freeipmi-${FREEIPMI_VER}/
RUN if [ "$(uname -m)" != "ppc64le" ]; then \
    tar -xf /deps/freeipmi-${FREEIPMI_VER}.tar.gz -C /\
    && cd /freeipmi-${FREEIPMI_VER} \
    && patch -p 0 < freeipmi-argp-redefine.patch \
    && rm freeipmi-argp-redefine.patch \
    && CPPFLAGS="-Dgetmsg\(a,b,c,d\)=errno=-1,-1 -Dputmsg\(a,b,c,d\)=errno=-1,-1" ./configure --prefix=/deps --disable-dependency-tracking --with-gnu-ld \
    && make -j2 \
    && make install \
    && rm -rf /freeipmi-${FREEIPMI_VER} \
    && exit 0 ; \
    else exit 0; fi; exit 1
