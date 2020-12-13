FROM registry.fedoraproject.org/fedora:rawhide

# tracker and tracker-miners build deps
RUN dnf upgrade -y && \
    dnf install -y 'dnf-command(builddep)' redhat-rpm-config && \
    dnf builddep -y tracker tracker-miners

# test suite dependencies
RUN dnf install -y git libasan libubsan python3-gobject python3-pip umockdev-devel xmlto && \
    pip3 install tap.py

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

RUN dnf remove -y tracker && \
    dnf clean all && \
    rm -R /root/*

RUN useradd --groups wheel --create-home --shell /bin/bash --user-group tracker && \
    mkdir /builds && \
    chown tracker:tracker /builds
USER tracker
WORKDIR /home/tracker
