#!/usr/bin/env bash

set -euox pipefail

echo "Running desktop packages scripts..."
#/ctx/build_files/desktop-1password.sh

# common packages installed to desktops
dnf install -y \
  alacritty \
  ansible \
  autofs \
  bat \
  btop \
  borgbackup \
  buildah \
  cachefilesd \
  clinfo \
  ddcutil \
  direnv \
  geary \
  gh \
  highlight \
  intel-compute-runtime \
  iotop \
  iperf3 \
  igt-gpu-tools \
  iscan-firmware \
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
  stow \
  strace \
  tealdeer \
  tmux \
  udica \
  uv \
  virt-install \
  virt-manager \
  virt-viewer \
  vulkan-tools \
  wireguard-tools \
  wl-clipboard \
  zsh

if [[ ${IMAGE} =~ bluefin ]]; then
  dnf install -y \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-no-overview
  dnf remove -y gnome-tour || true

fi

if [[ ${IMAGE} =~ aurora ]]; then
  dnf -y copr enable deltacopy/darkly
  dnf install -y darkly
  pip install --prefix /usr --root-user-action  konsave || true
fi

# common packages excluded from desktop
dnf install -y \
  firefox \
  firefox-langpacks || true

## github direct installs
#/ctx/build_files/github-release-install.sh Tomiyou/ivyterm x86_64

# Zed because why not?
#curl -Lo /tmp/zed.tar.gz \
#    https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz
#mkdir -p /usr/lib/zed.app/
#tar -xvf /tmp/zed.tar.gz -C /usr/lib/zed.app/ --strip-components=1
#ln -s /usr/lib/zed.app/bin/zed /usr/bin/zed
#cp /usr/lib/zed.app/share/applications/zed.desktop /usr/share/applications/dev.zed.Zed.desktop
#sed -i "s@Icon=zed@Icon=/usr/lib/zed.app/share/icons/hicolor/512x512/apps/zed.png@g" /usr/share/applications/dev.zed.Zed.desktop
#sed -i "s@Exec=zed@Exec=/usr/lib/zed.app/libexec/zed-editor@g" /usr/share/applications/dev.zed.Zed.desktop

# bitwarden
mkdir -p /var/opt/Bitwarden
curl -L https://bitwarden.com/download/?app=desktop\&platform=linux\&variant=rpm -o bitwarden.rpm
dnf install -y bitwarden.rpm
mv /var/opt/Bitwarden /usr/share/factory/bitwarden
echo "L  /opt/Bitwarden  -  -  -  -  /usr/share/factory/bitwarden" > /usr/lib/tmpfiles.d/microsoft.conf
cat <<EOF > /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
"-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
"http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">

<policyconfig>
    <action id="com.bitwarden.Bitwarden.unlock">
      <description>Unlock Bitwarden</description>
      <message>Authenticate to unlock Bitwarden</message>
      <defaults>
        <allow_any>no</allow_any>
        <allow_inactive>no</allow_inactive>
        <allow_active>auth_self</allow_active>
      </defaults>
    </action>
</policyconfig>
EOF

# cursor
# dnf -y copr enable unixlover/cursor
# dnf install -y cursor

# ghostty
dnf -y copr enable scottames/ghostty
dnf install -y ghostty

# rclip
pip install --prefix /usr --root-user-action rclip || true

# vscode stuff
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo
dnf install -y code

# wezterm
dnf -y copr enable wezfurlong/wezterm-nightly
dnf install -y wezterm
