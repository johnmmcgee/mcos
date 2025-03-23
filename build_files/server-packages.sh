#!/usr/bin/env bash

set -euox pipefail

echo "Running server packages scripts..."
#/ctx/build_files/server-docker-ce.sh

# common packages installed to servers
dnf5 install -y \
  389-ds-base \
  acpica-tools \
  btop \
  cockpit-storaged \
  cockpit-389-ds \
  hdparm \
  igt-gpu-tools \
  iotop \
  iperf3 \
  lm_sensors \
  lshw \
  netcat \
  netdata \
  nmap \
  sanoid \
  tuned \
  tuned-profiles-atomic \
  tuned-profiles-cpu-partitioning \
  tuned-utils \
  tuned-utils-systemtap

# common packages removed from servers
dnf5 remove -y \
        nfs-utils-coreos \
        tailscale \
        || true

dnf5 install -y \
        nfs-utils \
        || true