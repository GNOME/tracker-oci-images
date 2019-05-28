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

# Git is needed to clone tracker as a subproject when building tracker-miners.
dnf install -y git

# We need to be able to run tests as a normal user, not 'root'.
useradd -Um tracker

# This is needed for the functional-tests.
dnf install -y python3-gobject

# These are needed to use Address Sanitizer and Undefined Behaviour Sanitizer
# when building for extra safety checks.
dnf install -y libasan libubsan
