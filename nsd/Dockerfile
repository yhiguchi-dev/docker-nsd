FROM debian:bullseye-20230208 as builder

ARG NSD_VERSION=4_6_1

WORKDIR /build

RUN apt-get update
RUN apt-get install -y \
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
RUN ./configure -h
RUN ./configure && make && make install

FROM debian:bullseye-20230208-slim

WORKDIR /app

RUN \
  apt-get update \
  && \
  apt-get install -y \
    libevent-dev \
    libssl-dev \
  && \
  rm -rf /var/lib/apt/lists/* \
  && \
  mkdir -p /etc/nsd

COPY --from=builder /usr/local/sbin/nsd* /app

VOLUME ["/etc/nsd"]

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "/app/nsd", "-d" ]