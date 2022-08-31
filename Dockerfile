# Snort in Docker
FROM debian:bookworm-slim

MAINTAINER jgru

RUN apt-get update && \
    apt-get install -y \
        git \
        python3-setuptools \
        python3-pip \
        python3-dev \
        wget \
        automake \
        build-essential \
        bison \
        flex \
        cmake \
        g++ \
        libhwloc-dev \
        libluajit-5.1-dev \
        libssl-dev \
        libdnet-dev \
        libpcap-dev \
        libpcre3-dev \
        libdumbnet-dev \
        zlib1g-dev \
        liblzma-dev \
        libnetfilter-queue1 \
        tcpdump \
        unzip

WORKDIR /opt

ENV DAQ_VERSION 3.0.8
RUN wget https://github.com/snort3/libdaq/archive/refs/tags/v${DAQ_VERSION}.tar.gz \
    && tar xvfz v${DAQ_VERSION}.tar.gz \
    && cd libdaq-${DAQ_VERSION} \
    && autoreconf -vif; ./configure; make; make install

ENV INSTALLPATH /
RUN export my_path=${INSTALLPATH}

ENV SNORT_VERSION 3.1.40.0
RUN wget https://github.com/snort3/snort3/archive/refs/tags/${SNORT_VERSION}.tar.gz \
    && tar xvfz ${SNORT_VERSION}.tar.gz \
    && cd snort3-${SNORT_VERSION} \
    && ./configure_cmake.sh --prefix=${INSTALLPATH} \
    && cd build \
    && make install

RUN ldconfig

RUN mkdir -p /var/log/snort

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    /opt/snort3-${SNORT_VERSION}.tar.gz /opt/libdaq-${DAQ_VERSION}.tar.gz

WORKDIR /tmp

ENV NIC eth0

# Validate an installation
# snort -i eth0 -c /etc/snort/etc/snort.lua -T
CMD ["snort", "-i", "${NIC}", "-c", "/etc/snort/snort.lua", "-T"]
