FROM alpine:3.5
MAINTAINER Daisuke Nakano

ENV UNBOUND_VERSION '1.6.2'

RUN apk add --update --no-cache gcc make linux-headers musl-dev libressl-dev expat-dev curl && \
    cd /tmp && \
    curl -O https://www.unbound.net/downloads/unbound-${UNBOUND_VERSION}.tar.gz && \
    tar zxf unbound-${UNBOUND_VERSION}.tar.gz && \
    cd unbound-${UNBOUND_VERSION} && \
    ./configure --disable-flto --disable-shared && make && make install && \
    apk del gcc make linux-headers musl-dev libressl-dev expat-dev curl && \
    rm -fr /tmp/* && \
    adduser -h /home/unbound -s /sbin/nologin -D -H unbound

COPY /unbound.conf /usr/local/etc/unbound/unbound.conf

EXPOSE 53/udp 53/tcp

#CMD ["/bin/sh"]
CMD ["/usr/local/sbin/unbound"]
