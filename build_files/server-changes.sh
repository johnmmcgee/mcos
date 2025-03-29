#!/usr/bin/env bash

set -euox pipefail

echo "Hacky stuff that shouldn't be here"

if [[ ${IMAGE} =~ ucore ]]; then
    dnf remove -y \
        containerd moby-engine runc
    rm -f /usr/bin/docker-compose
    rm -fr /usr/libexec/docker
fi