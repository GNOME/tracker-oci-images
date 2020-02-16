#!/bin/sh

echo 'https://alpine.global.ssl.fastly.net/alpine/edge/community/' >> /etc/apk/repositories
apk add -U alpine-sdk bash-completion dbus-dev git glib-dev gobject-introspection-dev \
           icu-dev json-glib-dev libsoup-dev libxml2-dev meson networkmanager-dev \
           py3-gobject3 py3-setuptools sqlite-dev vala

addgroup -S tracker
adduser -D -G tracker -g tracker tracker
