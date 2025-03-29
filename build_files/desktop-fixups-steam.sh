#!/usr/bin/bash

set -eoux pipefail

# OBS-VKcapture
dnf -y copr enable kylegospo/obs-vkcapture

# Bazzite Repos
dnf -y copr enable kylegospo/bazzite
dnf -y copr enable kylegospo/bazzite-multilib
dnf -y copr enable kylegospo/LatencyFleX

find /etc/yum.repos.d/

sed -i "0,/enabled=0/{s/enabled=0/enabled=1/}" /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# TODO: pull the following scripts directly from m2os
/ctx/build_files/build-fix.sh
/ctx/build_files/steam.sh

sed -i "s@enabled=1@enabled=0@" /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# disable the Repos we pulled in above
sed -i "s@enabled=1@enabled=0@" /etc/yum.repos.d/_copr*.repo
