#!/bin/sh

dnf upgrade -y
dnf install -y 'dnf-command(builddep)' libseccomp-devel redhat-rpm-config

dnf install -y meson

# Tracker dependencies
dnf install -y dbus-devel dbus-x11 tracker
dnf builddep -y tracker

# tracker-miners dependencies
dnf install -y libseccomp-devel
dnf builddep -y tracker-miners

# Git is needed to clone tracker as a subproject when building tracker-miners.
dnf install -y git

# We need to be able to run tests as a normal user, not 'root'.
useradd -Um tracker

# This shouldn't be needed, but currently is.
#
# Some of the tests depend on the GSettings schemas being installed.
#
# Some of the tests also seem to interact with the session-wide Tracker
# instance!
- dnf install -y tracker
