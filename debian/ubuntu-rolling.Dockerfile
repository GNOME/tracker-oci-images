FROM ubuntu:rolling

RUN export DEBIAN_FRONTEND=noninteractive && \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
    apt-get -yq update && apt-get -yq upgrade && \
    apt-get -yq build-dep tracker tracker-miners && \
    apt-get -yq install python3-tap umockdev libumockdev-dev upower && \
    apt-get -yq install --no-install-recommends asciidoc-base && \
    apt-get -yq install git && \
    apt-get -yq install libgrss-dev && \
    apt-get -yq install eatmydata && \
    apt-get -yq install libgdk-pixbuf2.0-dev

RUN apt-get -yq remove libtracker-sparql-2.0-0 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN useradd -Um tracker
USER tracker
WORKDIR /home/tracker
