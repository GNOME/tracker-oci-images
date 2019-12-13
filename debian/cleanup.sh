#!/bin/sh

set -eu

# These are installed by `apt build-dep tracker-miners`. We don't want them in
# the test environment, so we can be sure that tests are running against what's
# in the build tree and not what's installed in /usr.
echo "Removing Tracker packages"
apt-get -yq remove libtracker-sparql-2.0-0 libtracker-miner-2.0-0 libtracker-control-2.0-0 tracker

echo "Removing apt cache"
apt-get clean
rm -rf /var/lib/apt/lists

rm -R /root/*
