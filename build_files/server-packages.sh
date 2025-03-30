#!/usr/bin/env bash

set -euox pipefail

echo "Running server packages scripts..."

# common packages installed to servers
dnf install -y \
  acpica-tools \
  btop \
  cockpit-storaged \
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
dnf remove -y \
        nfs-utils-coreos \
        tailscale \
        || true

dnf install -y \
        nfs-utils \
        || true
