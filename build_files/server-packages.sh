#!/usr/bin/env bash

set -euox pipefail

echo "Running server packages scripts..."
#/ctx/build_files/server-docker-ce.sh

# common packages installed to desktops and servers
rpm-ostree install \
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

rpm-ostree remove \
  nfs-utils-coreos

rpm-ostree install \
  nfs-utils