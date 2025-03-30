#!/usr/bin/env bash

set -euox pipefail

echo "Hacky stuff that shouldn't be here"

if [[ ${IMAGE} =~ ucore ]]; then
    dnf download console-389-ds -y && rpm2cpio console-389-ds-*.rpm | cpio -idmv -D /
fi