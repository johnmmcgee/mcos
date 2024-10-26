# mcOS

[![build-ublue](https://github.com/johnmmcgee/mcos/actions/workflows/build.yml/badge.svg)](https://github.com/johnmmcgee/mcod/actions/workflows/build.yml)

These are mostly stock projected bluefin images that I created for my own personal use.  
Intial ideas for this repo stemed from: 
[https://github.com/bsherman/bOS/] (https://github.com/bsherman/bOS)


## Usage

We build `latest` which points to Fedora 40:

  Standard
  
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/johnmmcgee/mcos:bluefin
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin

  NVidia drivers
  
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/johnmmcgee/mcos:bluefin-nvidia
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin-nvidia

  uCore
  
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/johnmmcgee/mcos:ucore-minimal
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-minimal

  uCore NVidia drivers
  
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/johnmmcgee/mcos:ucore-minimal-nvidia
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-minimal-nvidia

Use the `latest` tag to follow the current latest.  Or you can use the release tag, such as `40`, which is current. 

## Verification

These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the appropriate command:

    cosign verify --key cosign.pub ghcr.io/johnmmcgee/ublue-custom
    cosign verify --key cosign.pub ghcr.io/johnmmcgee/ublue-nvidia-custom