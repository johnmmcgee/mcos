#!/usr/bin/bash

set -eoux pipefail

repos=(
    fedora-updates.repo
    fedora-updates-archive.repo
)

for repo in "${repos[@]}"; do
    if [ $(grep -c "enabled=1" /etc/yum.repos.d/${repo}) -eq 0 ]; then
        sed -i "0,/enabled=0/{s/enabled=0/enabled=1/}" /etc/yum.repos.d/${repo}
    fi
done

dnf reinstall -y \
    --repo=updates \
        systemd-libs \
        || true
dnf reinstall -y \
    --repo=updates \
        vulkan-loader \
        || true
dnf reinstall -y \
    --repo=updates \
        alsa-lib \
        || true
dnf reinstall -y \
    --repo=updates \
        gnutls \
        || true
dnf reinstall -y \
    --repo=updates \
        glib2 \
        || true
dnf reinstall -y \
    --repo=updates \
        nspr \
        || true
dnf reinstall -y \
    --repo=updates \
        nss \
        nss-softokn \
        nss-softokn-freebl \
        nss-sysinit \
        nss-util \
        || true
dnf reinstall -y \
    --repo=updates \
        atk \
        at-spi2-atk \
        || true
dnf reinstall -y \
    --repo=updates \
        libaom \
        || true
dnf reinstall -y \
    --repo=updates \
        gstreamer1 \
        gstreamer1-plugins-base \
        || true
dnf reinstall -y \
    --repo=updates \
        libdecor \
        || true
dnf reinstall -y \
    --repo=updates \
        libtirpc \
        || true
dnf reinstall -y \
        libuuid \
        || true
dnf reinstall -y \
    --repo=updates \
        libblkid \
        || true
dnf reinstall -y \
    --repo=updates \
        libmount \
        || true
dnf reinstall -y \
    --repo=updates \
        cups-libs \
        || true
dnf reinstall -y \
    --repo=updates \
        libinput \
        || true
dnf reinstall -y \
    --repo=updates \
        libopenmpt \
        || true
dnf reinstall -y \
    --repo=updates \
        llvm-libs \
        || true
dnf reinstall -y \
    --repo=updates \
        zlib-ng-compat \
        || true
dnf reinstall -y \
    --repo=updates \
        fontconfig \
        || true
dnf reinstall -y \
    --repo=updates \
        pciutils-libs \
        || true
dnf reinstall -y \
    --repo=updates \
        libdrm \
        || true
dnf reinstall -y \
    --repo=updates \
        cpp \
        libatomic \
        libgcc \
        libgfortran \
        libgomp \
        libobjc \
        libstdc++ \
        || true
dnf reinstall -y \
    --repo=updates \
        libX11 \
        libX11-common \
        libX11-xcb \
        || true
dnf reinstall -y \
    --repo=updates \
        libv4l \
        || true
if grep -q "aurora" <<< "${IMAGE}"; then \
    dnf reinstall -y \
        --repo=updates \
            qt6-qtbase \
            qt6-qtbase-common \
            qt6-qtbase-mysql \
            qt6-qtbase-gui \
            || true \
; fi
dnf remove -y \
    glibc32 \
    || true
