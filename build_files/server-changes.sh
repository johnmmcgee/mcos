#!/usr/bin/env bash

set -euox pipefail

echo "Hacky stuff that shouldn't be here"

if [[ ${IMAGE} =~ ucore ]]; then
    dnf download cockpit-389-ds -y && rpm2cpio cockpit-389-ds-*.rpm | cpio -idmv --directory=/
    rm -rf cockpit-389-ds-*.rpm    
fi
