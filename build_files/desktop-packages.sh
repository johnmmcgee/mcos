#!/usr/bin/env bash

set -euox pipefail

echo "Running desktop packages scripts..."
#/ctx/build_files/desktop-1password.sh

# common packages installed to desktops
dnf5 install -y \
  alacritty \
  ansible \
  autofs \
  borgbackup \
  buildah \
  cachefilesd \
  ddcutil \
  fira-code-fonts \
  foot \
  gh \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-no-overview \
  highlight \
  intel-compute-runtime \
  iotop \
  iperf3 \
  kitty \
  langpacks-en \
  libretls \
  libvirt-client \
  libvirt-daemon-kvm \
  lm_sensors \
  lsd \
  lshw \
  ltrace \
  netcat \
  nmap \
  numlockx \
  perl-Image-ExifTool \
  p7zip \
  p7zip-plugins \
  papirus-icon-theme \
  podman-compose \
  podman-tui \
  powertop \
  python3-pip \
  rclone \
  slirp4netns \
  source-foundry-hack-fonts \
  stow \
  strace \
  tealdeer \
  tmux \
  udica \
  virt-install \
  virt-manager \
  virt-viewer \
  wireguard-tools \
  wl-clipboard \
  zsh

# common packages excluded from desktop
dnf5 remove -y \
  firefox \
  firefox-langpacks \
  gnome-tour || true

## github direct installs
/ctx/build_files/github-release-install.sh twpayne/chezmoi x86_64

# Zed because why not?
curl -Lo /tmp/zed.tar.gz \
    https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz
mkdir -p /usr/lib/zed.app/
tar -xvf /tmp/zed.tar.gz -C /usr/lib/zed.app/ --strip-components=1
ln -s /usr/lib/zed.app/bin/zed /usr/bin/zed
cp /usr/lib/zed.app/share/applications/zed.desktop /usr/share/applications/dev.zed.Zed.desktop
sed -i "s@Icon=zed@Icon=/usr/lib/zed.app/share/icons/hicolor/512x512/apps/zed.png@g" /usr/share/applications/dev.zed.Zed.desktop
sed -i "s@Exec=zed@Exec=/usr/lib/zed.app/libexec/zed-editor@g" /usr/share/applications/dev.zed.Zed.desktop

# vscode stuff
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo
dnf5 install -y code

# mscorefonts2
dnf install -y https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm