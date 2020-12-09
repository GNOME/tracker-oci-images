FROM ubuntu:rolling

RUN export DEBIAN_FRONTEND=noninteractive && \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get -yq update && apt-get -yq upgrade && \
    apt-get -yq build-dep tracker tracker-miners && \
    apt-get -yq install umockdev libumockdev-dev upower && \
    apt-get -yq install --no-install-recommends asciidoc-base && \
    apt-get -yq install git && \
    apt-get -yq install libgrss-dev && \
    apt-get -yq install eatmydata

RUN apt-get -yq remove libtracker-sparql-3.0-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    rm -R /root/*

RUN useradd -Um tracker
USER tracker
WORKDIR /home/tracker
