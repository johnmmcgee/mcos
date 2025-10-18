# mcOS

[![mcos Build Desktop](https://github.com/johnmmcgee/mcos/actions/workflows/build-desktop.yml/badge.svg)](https://github.com/johnmmcgee/mcos/actions/workflows/build-desktop.yml)
[![mcos Build Server](https://github.com/johnmmcgee/mcos/actions/workflows/build-server.yml/badge.svg)](https://github.com/johnmmcgee/mcos/actions/workflows/build-server.yml)


These are mostly stock Project Bluefin images that I created for my own personal use.
Initial ideas for this repo stemmed from:
[https://github.com/bsherman/bos/] (https://github.com/bsherman/bos)


## Usage

We build `stable` which follows the project-bluefin stable branch. 
See: https://docs.projectbluefin.io/administration under Upgrades and Throttle Settings. 

  Standard - stable
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin
    bootc switch ghcr.io/johnmmcgee/mcos:aurora

  NVidia drivers - stable
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin-nvidia
    bootc switch ghcr.io/johnmmcgee/mcos:aurora

  uCore
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore
    bootc switch ghcr.io/johnmmcgee/mcos:ucore

  uCore NVidia drivers
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-nvidia
    bootc switch ghcr.io/johnmmcgee/mcos:ucore-nvidia

  uCore Minimal

    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-minimal
    bootc switch ghcr.io/johnmmcgee/mcos:ucore-minimal



## Verification

These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the appropriate command:

    cosign verify --key cosign.pub ghcr.io/johnmmcgee/mcos
    
