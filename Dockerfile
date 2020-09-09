FROM debian:10

RUN useradd -p locked -m heads && \
    apt-get -qq -y update && \
    apt-get install -y \
      bc \
      bison \
      build-essential \
      cpio \
      curl \
      flex \
      git \
      libelf-dev \
      libncurses5-dev \
      pkg-config \
      python \
      texinfo \
      wget \
      zlib1g-dev && \
    apt-get clean && \
    apt-get autoremove


RUN mkdir /home/heads/.ccache && \
  	chown heads:heads /home/heads/.ccache

VOLUME /home/heads/.ccache

USER heads
