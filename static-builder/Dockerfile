FROM alpine:3.16

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
    fts-dev \
    gcc \
    git \
    gnutls-dev \
    gzip \
    jq \
    libelf-static \
    libmnl-dev \
    libnetfilter_acct-dev \
    libtool \
    libuv-dev \
    libuv-static \
    lz4-dev \
    lz4-static \
    make \
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
    zlib-static
