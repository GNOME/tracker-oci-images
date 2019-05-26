#!/bin/sh

set -eu

# This is installed by `dnf build-dep tracker-miners`. We don't want it in the
# test environment, so we can be sure that tests are running against what's in
# the build tree and not what's installed in /usr.
echo "Removing Tracker package"
dnf remove -y tracker

echo "Removing DNF cache"
dnf clean all

rm -R /root/*
