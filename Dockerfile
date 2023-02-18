FROM ubuntu:22.04 as builder

ARG NSD_VERSION 4_6_1

WORKDIR /tmp

RUN apt update
RUN apt install -y \
  curl \
  unzip \
  build-essential \
  libevent-dev \
  libssl-dev \
  flex \
  bison
RUN curl -SsL -o nsd.zip https://github.com/NLnetLabs/nsd/archive/refs/tags/NSD_${NSD_VERSION}_REL.zip
RUN unzip nsd.zip

WORKDIR /build

RUN mv /tmp/nsd-NSD_${NSD_VERSION}_REL .
RUN automake -c -a
RUN ./configure
RUN make
RUN make install

FROM debian:bullseye-20230208-slim

WORKDIR /app

COPY --from=builder /usr/local/sbin/nsd-* /app

ENV PATH $PATH:$/app

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "nsd" ]