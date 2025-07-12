#!/usr/bin/env bash

set -euox pipefail

echo "Running server packages scripts..."

# common packages installed to servers
dnf install -y \
  389-ds-base \
  acpica-tools \
  btop \
  cockpit-storaged \
  fio \
  fish \
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
  smartmontools \
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

# Starship Shell Prompt
curl --retry 3 -Lo /tmp/starship.tar.gz "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz"
tar -xzf /tmp/starship.tar.gz -C /tmp
install -c -m 0755 /tmp/starship /usr/bin
