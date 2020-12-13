FROM registry.fedoraproject.org/fedora:latest

# tracker and tracker-miners build deps
RUN dnf upgrade -y && \
    dnf install -y 'dnf-command(builddep)' redhat-rpm-config && \
    dnf builddep -y tracker tracker-miners && \
    dnf install -y asciidoc dbus-devel dbus-x11 dconf meson make gstreamer1-plugins-good libseccomp-devel

# test suite, Coverity and website dependencies
RUN dnf install -y clang gcovr git libasan libubsan python3-gobject python3-pip umockdev-devel xmlto && \
    pip3 install beautifulsoup4 mkdocs mkdocs-cinder tap.py

# We need libav so we can test the libav-based mediafile extractor, and so
# we can test our support for .m4a/mp4 files.
#
# RPM Fusion install commands from https://rpmfusion.org/Configuration
#
# We ignore the weak dependencies of this package, which include compiler-rt, pocl
# and mesa-libOpenCL -- these pull in the Clang/LLVM toolchain. Excluding them
# saves 300MB of image size.
RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y --setopt=install_weak_deps=False gstreamer1-libav

# This is to speed up the tests. See:
# https://gitlab.gnome.org/GNOME/tracker/merge_requests/176
RUN curl --get 'https://www.flamingspork.com/projects/libeatmydata/libeatmydata-105.tar.gz' --output libeatmydata-105.tar.gz && \
    tar -x -f ./libeatmydata-105.tar.gz && \
    cd libeatmydata-105 && \
    ./configure --prefix=/usr && \
    make install && \
    sed -e '/dpkg-architecture/ d' -i /usr/bin/eatmydata && \
    sed -e 's@shlib="/usr/lib/$DEB_BUILD_MULTIARCH/eatmydata.sh@shlib="/usr/libexec/eatmydata.sh@' -i /usr/bin/eatmydata && \
    cd .. && \
    rm ./libeatmydata-105.tar.gz && \
    rm -Rf ./libeatmydata-105

RUN dnf remove -y tracker && \
    dnf clean all && \
    rm -R /root/*

RUN useradd --groups wheel --create-home --shell /bin/bash --user-group tracker
USER tracker
WORKDIR /home/tracker
