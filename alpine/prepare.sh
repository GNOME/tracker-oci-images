#!/bin/sh

set -ex

echo 'https://alpine.global.ssl.fastly.net/alpine/edge/community/' >> /etc/apk/repositories

# Tracker SPARQL dependencies
apk add -U alpine-sdk asciidoc bash-completion dbus-dev git glib-dev gobject-introspection-dev \
           gtk-doc icu-dev json-glib-dev libsoup-dev libxml2-dev meson networkmanager-dev \
           py3-gobject3 py3-setuptools sqlite-dev vala

# Tracker Miners dependencies
apk add gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly
        gstreamer-dev libcue-dev libgrss-dev libgsf-dev libgxps-dev
        libosinfo-dev libseccomp-dev poppler-dev shared-mime-info tiff-dev \
        totem-pl-parser-dev upower-dev

addgroup -S tracker
adduser -D -G tracker -g tracker tracker


# Build eatmydata from Git.
#
# This is to speed up the tests. See:
# https://gitlab.gnome.org/GNOME/tracker/merge_requests/176
#
# Currently https://gitlab.gnome.org/GNOME/tracker-oci-images/merge_requests/13
# is needed to build against musl libc.
apk add -U autoconf automake libtool
git clone https://github.com/ssssam/libeatmydata --branch sam/musl-open64-fix
cd libeatmydata
autoreconf -ivf
./configure
make
make install
cd ..
apk del autoconf automake libtool
