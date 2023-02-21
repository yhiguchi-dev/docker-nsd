FROM ubuntu:22.04 as builder

ARG NSD_VERSION=4_6_1

WORKDIR /build

RUN apt update
RUN apt install -y \
  curl \
  unzip \
  build-essential \
  libevent-dev \
  libtool \
  libssl-dev \
  automake \
  flex \
  bison
RUN curl -SsL -o nsd.zip https://github.com/NLnetLabs/nsd/archive/refs/tags/NSD_${NSD_VERSION}_REL.zip
RUN unzip nsd.zip

WORKDIR /build/nsd-NSD_${NSD_VERSION}_REL

RUN aclocal && autoconf && autoheader
RUN automake -a -c || exit 0;
RUN ./configure && make && make install

FROM debian:bullseye-20230208-slim

WORKDIR /app

COPY --from=builder /usr/local/sbin/nsd-* /app

ENV PATH=$PATH:$/app

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "nsd" ]