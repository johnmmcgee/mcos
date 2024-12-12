# mcOS

[![mcos Build Desktop](https://github.com/johnmmcgee/mcos/actions/workflows/build-desktop.yml/badge.svg)](https://github.com/johnmmcgee/mcos/actions/workflows/build-desktop.yml)
[![bOS Build Server](https://github.com/johnmmcgee/mcos/actions/workflows/build-server.yml/badge.svg)](https://github.com/johnmmcgee/mcos/actions/workflows/build-server.yml)


These are mostly stock project bluefin images that I created for my own personal use.  
Intial ideas for this repo stemed from: 
[https://github.com/bsherman/bos/] (https://github.com/bsherman/bos)


## Usage

We build `stable` which follows the project-bluefin stable branch.  We also build `-latest` that follows the 'latest' branch. 
See: https://docs.projectbluefin.io/administration under Upgrades and Throttle Settings. 

  Standard - stable
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin

  Standard - latest
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin-latest

  NVidia drivers - stable
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin-nvidia

  NVidia drivers - latest
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin-nvidia-latest

  uCore
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-minimal

  uCore NVidia drivers
  
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-minimal-nvidia



## Verification

These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the appropriate command:

    cosign verify --key cosign.pub ghcr.io/johnmmcgee/ublue-custom
    cosign verify --key cosign.pub ghcr.io/johnmmcgee/ublue-nvidia-custom
