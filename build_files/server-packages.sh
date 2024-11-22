#!/usr/bin/env bash

set -euox pipefail

echo "Running server packages scripts..."
#/ctx/build_files/server-docker-ce.sh

# common packages installed to desktops and servers
dnf5 install -y \
  btop \
  cockpit-storaged \
  hdparm \
  igt-gpu-tools \
  iotop \
  iperf3 \
  lm_sensors \
  lshw \
  netcat \
  nmap \
  sanoid

dnf5 remove -y \
        nfs-utils-coreos \
        || true

dnf5 install -y \
        nfs-utils \
        || true
