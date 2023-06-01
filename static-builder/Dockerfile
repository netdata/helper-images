FROM alpine:3.18

LABEL org.opencontainers.image.authors="Netdatabot <bot@netdata.cloud>"
LABEL org.opencontainers.image.source="https://github.com/netdata/helper-images"
LABEL org.opencontainers.image.title="Netdata Agent Static Builder Image"
LABEL org.opencontainers.image.description="Builder image for creating static builds of the Netdata Agent"
LABEL org.opencontainers.image.vendor="Netdata Inc."

RUN apk add --no-cache \
    alpine-sdk \
    autoconf \
    automake \
    bash \
    binutils \
    bison \
    cmake \
    curl \
    elfutils-dev \
    flex \
    gcc \
    git \
    gnutls-dev \
    gzip \
    jq \
    libelf-static \
    libmnl-dev \
    libmnl-static \
    libtool \
    libuv-dev \
    libuv-static \
    lz4-dev \
    lz4-static \
    yaml-dev \
    yaml-static \
    make \
    musl-fts-dev \
    ncurses \
    netcat-openbsd \
    openssh \
    pkgconfig \
    protobuf-dev \
    snappy-dev \
    snappy-static \
    util-linux-dev \
    wget \
    xz \
    zlib-dev \
    zlib-static \
    zstd-dev \
    zstd-static
