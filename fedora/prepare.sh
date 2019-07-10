#!/bin/sh

dnf upgrade -y
dnf install -y 'dnf-command(builddep)' libseccomp-devel redhat-rpm-config

dnf install -y meson
dnf install -y make

# Tracker dependencies
dnf install -y dbus-devel dbus-x11
dnf builddep -y tracker
dnf install -y dconf

# tracker-miners dependencies
dnf install -y libseccomp-devel
dnf builddep -y tracker-miners
dnf install -y gstreamer1-plugins-good

# We need to test our support for .m4a/mp4. This requires the 'faad' codec,
# which is distrubuted via rpmfusion as Red Hat considers it nonfree.
#
# Fedora 30 contains the fdk-aac-free codec, which would also suffice, but
# the 'fdkaacdec' GStreamer plugin is not available in any of the packages
# so it's not available for use by Tracker.
#
# RPM Fusion install commands from https://rpmfusion.org/Configuration
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y gstreamer1-plugins-bad-nonfree

# Git is needed to clone tracker as a subproject when building tracker-miners.
dnf install -y git

# We need to be able to run tests as a normal user, not 'root'.
useradd -Um tracker

# This is needed for the functional-tests.
dnf install -y python3-gobject

# These are needed to use Address Sanitizer and Undefined Behaviour Sanitizer
# when building for extra safety checks.
dnf install -y libasan libubsan
