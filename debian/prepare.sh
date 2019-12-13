#!/bin/sh

# Enable source repositories so we can use `apt-get build-dep`

sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
apt-get -yq update && apt-get -yq upgrade

apt-get -yq build-dep tracker tracker-miners

# For rss miner, which I guess Debian/Ubuntu disable by default
apt-get -yq install libgrss-dev

# We need to be able to run tests as a normal user, not 'root'.
useradd -Um tracker
