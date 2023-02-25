FROM debian:bullseye-20230208 as builder

ARG NSD_VERSION=4_6_1

WORKDIR /build

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
  curl=7.74.0-1.3+deb11u5 \
  ca-certificates=20210119 \
  unzip=6.0-26+deb11u1 \
  build-essential=12.9 \
  libevent-dev=2.1.12-stable-1 \
  libtool=2.4.6-15 \
  libssl-dev=1.1.1n-0+deb11u4 \
  automake=1:1.16.3-2 \
  flex=2.6.4-8 \
  bison=2:3.7.5+dfsg-1
RUN curl -SsL -o nsd.zip https://github.com/NLnetLabs/nsd/archive/refs/tags/NSD_${NSD_VERSION}_REL.zip
RUN unzip nsd.zip

WORKDIR /build/nsd-NSD_${NSD_VERSION}_REL

RUN aclocal && autoconf && autoheader
RUN automake -a -c || exit 0;
RUN ./configure -h
RUN ./configure && make && make install

FROM debian:bullseye-20230208-slim

WORKDIR /app

RUN \
  apt-get update \
  && \
  apt-get install --no-install-recommends -y \
    libevent-dev=2.1.12-stable-1 \
    libssl-dev=1.1.1n-0+deb11u4 \
    # CVE-2023-0361
    libgnutls30=3.7.1-5+deb11u3 \
  && \
  rm -rf /var/lib/apt/lists/* \
  && \
  mkdir -p /etc/nsd

COPY --from=builder /usr/local/sbin/nsd* /app

VOLUME ["/etc/nsd"]

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "/app/nsd", "-d" ]