#!/bin/sh

set -ex

dnf upgrade -y
dnf install -y 'dnf-command(builddep)' libseccomp-devel redhat-rpm-config

dnf install -y meson
dnf install -y make

# Tracker dependencies
dnf install -y dbus-devel dbus-x11
dnf builddep -y tracker
dnf install -y dconf
dnf install -y asciidoc

# tracker-miners dependencies
dnf install -y libseccomp-devel
dnf builddep -y tracker-miners
dnf install -y gstreamer1-plugins-good

# We need libav so we can test the libav-based mediafile extractor, and so
# we can test our support for .m4a/mp4 files.
#
# RPM Fusion install commands from https://rpmfusion.org/Configuration
#
# We ignore the weak dependencies of this package, which include compiler-rt, pocl
# and mesa-libOpenCL -- these pull in the Clang/LLVM toolchain. Excluding them
# saves 300MB of image size.
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y --setopt=install_weak_deps=False gstreamer1-libav

# Git is needed to clone tracker as a subproject when building tracker-miners.
dnf install -y git

# We need to be able to run tests as a normal user, not 'root'.
useradd -Um tracker

# This is needed for the functional-tests.
dnf install -y python3-gobject

# These are needed to use Address Sanitizer and Undefined Behaviour Sanitizer
# when building for extra safety checks.
dnf install -y libasan libubsan

# This is to speed up the tests. See:
# https://gitlab.gnome.org/GNOME/tracker/merge_requests/176
curl --get 'https://www.flamingspork.com/projects/libeatmydata/libeatmydata-105.tar.gz' --output libeatmydata-105.tar.gz
tar -x -f ./libeatmydata-105.tar.gz
cd libeatmydata-105
./configure --prefix=/usr
make install
sed -e '/dpkg-architecture/ d' -i /usr/bin/eatmydata
sed -e 's@shlib="/usr/lib/$DEB_BUILD_MULTIARCH/eatmydata.sh@shlib="/usr/libexec/eatmydata.sh@' -i /usr/bin/eatmydata
cd ..
