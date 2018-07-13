#!/bin/sh

set -eu

echo "Removing DNF cache"
dnf clean all

rm -R /root/*