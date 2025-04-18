#!/bin/bash

set -ouex pipefail

# there is no 'rpm-ostree cliwrap uninstall-from-root', but this is close enough. See:
# https://github.com/coreos/rpm-ostree/blob/6d2548ddb2bfa8f4e9bafe5c6e717cf9531d8001/rust/src/cliwrap.rs#L25-L32
if [ -d /usr/libexec/rpm-ostree/wrapped ]; then
    # binaries which could be created if they did not exist thus may not be in wrapped dir
    rm -f \
        /usr/bin/yum \
        /usr/bin/dnf \
        /usr/bin/kernel-install
    # binaries which were wrapped
    mv -f /usr/libexec/rpm-ostree/wrapped/* /usr/bin
    rm -fr /usr/libexec/rpm-ostree
fi

rpm-ostree install dnf5 dnf5-plugins

# temp until https://github.com/ublue-os/main/pull/665 trickles down:
mkdir -p /usr/share/dnf/plugins
cat << EOF > /usr/share/dnf/plugins/copr.vendor.conf
[main]
distribution = fedora
EOF


case "${IMAGE}" in
"aurora"* | "bluefin"*)
    /ctx/build_files/desktop-changes.sh
#    /ctx/build_files/desktop-fixups-steam.sh
    /ctx/build_files/desktop-packages.sh
    ;;
"ucore"*) 
    if [[ "${IMAGE}" != "ucore-minimal" ]]; then
        /ctx/build_files/server-changes.sh
        /ctx/build_files/server-cockpit-modules.sh
        /ctx/build_files/server-packages.sh
    fi
esac

#/ctx/build_files/branding.sh
/ctx/build_files/signing.sh
/ctx/build_files/cleanup.sh