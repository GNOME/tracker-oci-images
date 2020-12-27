FROM alpine:edge

RUN echo 'https://alpine.global.ssl.fastly.net/alpine/edge/community/' >> /etc/apk/repositories && \
    apk add -U alpine-sdk asciidoc bash-completion dbus-dev git glib-dev gobject-introspection-dev \
               gtk-doc icu-dev json-glib-dev libsoup-dev libxml2-dev meson networkmanager-dev \
               py3-gobject3 py3-setuptools py3-tappy sqlite-dev vala \
               gdk-pixbuf-dev

# Build eatmydata from Git.
#
# This is to speed up the tests. See:
# https://gitlab.gnome.org/GNOME/tracker/merge_requests/176
#
# Currently https://gitlab.gnome.org/GNOME/tracker-oci-images/merge_requests/13
# is needed to build against musl libc.
RUN apk add -U autoconf automake libtool && \
    git clone https://github.com/ssssam/libeatmydata --branch sam/musl-open64-fix && \
    cd libeatmydata && \
    autoreconf -ivf && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    apk del autoconf automake libtool

RUN addgroup -S tracker && \
    adduser -D -G tracker -g tracker tracker
USER tracker
WORKDIR /home/tracker
