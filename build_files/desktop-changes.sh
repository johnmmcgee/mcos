#!/usr/bin/env bash

set -euox pipefail

echo "Tweaking existing desktop config..."

if [[ ${IMAGE} =~ bluefin|bazzite ]]; then
  rsync -rvK /ctx/system_files/silverblue/ /

  systemctl enable dconf-update.service && \
  systemctl enable rpm-ostree-countme.timer && \
  systemctl enable podman.socket && \
  fc-cache -f /usr/share/fonts/inputmono && \
  fc-cache -f /usr/share/fonts/outputsans && \
  if [ ! -f /etc/systemd/user.conf ]; then cp /usr/lib/systemd/user.conf /etc/systemd/; fi && \
  if [ ! -f /etc/systemd/system.conf ]; then cp /usr/lib/systemd/system.conf /etc/systemd/; fi && \
  sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
  sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
  chmod a+x /usr/share/ublue-os/firstboot/*.sh && \
  rm -f /usr/share/applications/htop.desktop && \
  rm -f /usr/share/applications/nvtop.desktop && \  
fi
