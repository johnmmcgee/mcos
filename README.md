# mcOS

[![mcos Build Desktop](https://github.com/johnmmcgee/mcos/actions/workflows/build-desktop.yml/badge.svg)](https://github.com/johnmmcgee/mcos/actions/workflows/build-desktop.yml)
[![mcos Build Server](https://github.com/johnmmcgee/mcos/actions/workflows/build-server.yml/badge.svg)](https://github.com/johnmmcgee/mcos/actions/workflows/build-server.yml)

## Overview

mcOS is a collection of custom Linux container images built on top of [Project Bluefin](https://docs.projectbluefin.io/), a Fedora-based distribution optimized for immutable infrastructure. These images are designed for both desktop and server use cases, providing pre-configured environments with carefully selected packages and optimizations.

### Key Features

- **Multiple variants** tailored for different use cases (desktop, server, minimal)
- **Pre-configured** with useful development and productivity tools
- **Signed images** using cosign for security verification
- **Automated builds** via GitHub Actions for reliability
- **Regular updates** following Project Bluefin's stable branch

### Image Variants

#### Desktop Images

1. **Bluefin** - Standard desktop image with GNOME
   - Includes development tools, multimedia support, and productivity applications
   - Optimized for daily desktop use

2. **Aurora** - Enhanced desktop experience
   - Additional packages and optimizations beyond Bluefin
   - Includes theming and appearance enhancements

3. **Bazzite** - Gaming-focused desktop
   - Includes gaming-related packages and optimizations
   - Designed for Steam and other gaming platforms

#### Server Images

1. **uCore** - Minimal server image
   - Optimized for server workloads
   - Includes monitoring, management, and virtualization tools

2. **uCore Minimal** - Extremely minimal server image
   - Barebones server environment
   - Ideal for container hosts and minimal deployments

3. **uCore NVidia** - Server image with NVidia drivers
   - Includes NVidia drivers for GPU acceleration
   - Suitable for AI/ML workloads and GPU computing

## Usage

### Installation

#### Desktop Images

**Bluefin (Standard Desktop)**
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bluefin
bootc switch ghcr.io/johnmmcgee/mcos:bluefin
```

**Aurora (Enhanced Desktop)**
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:aurora
bootc switch ghcr.io/johnmmcgee/mcos:aurora
```

**Bazzite (Gaming Desktop)**
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:bazzite
bootc switch ghcr.io/johnmmcgee/mcos:bazzite
```

#### Server Images

**uCore (Standard Server)**
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore
bootc switch ghcr.io/johnmmcgee/mcos:ucore
```

**uCore Minimal**
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-minimal
bootc switch ghcr.io/johnmmcgee/mcos:ucore-minimal
```

**uCore with NVidia Drivers**
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/johnmmcgee/mcos:ucore-nvidia
bootc switch ghcr.io/johnmmcgee/mcos:ucore-nvidia
```

### Post-Installation

After switching to a new image, reboot your system:
```bash
systemctl reboot
```

### Package Management

To install additional packages:
```bash
sudo dnf install <package-name>
```

To remove packages:
```bash
sudo dnf remove <package-name>
```

## Build Process

### Requirements

- Podman or Docker
- just (build automation tool)
- Git
- Internet connection

### Building Images

The repository uses a `Justfile` to manage builds. Available commands:

- `just build <image>` - Build a specific image variant
- `just clean` - Clean up build artifacts
- `just lint` - Run linters on shell scripts

Example build command:
```bash
just build bluefin
```

### Build Workflow

1. The `Containerfile` defines the base image and build context
2. The `build.sh` script installs packages and applies configurations
3. Variant-specific scripts handle image customizations
4. Images are tagged and signed automatically in CI

## Verification

### Image Signing

All images are signed using [sigstore's cosign](https://docs.sigstore.dev/cosign/overview/) to ensure integrity and authenticity.

### Verifying Signatures

1. Download the public key:
```bash
curl -LO https://raw.githubusercontent.com/johnmmcgee/mcos/main/cosign.pub
```

2. Verify an image:
```bash
cosign verify --key cosign.pub ghcr.io/johnmmcgee/mcos:bluefin
```

### Security Considerations

- Always verify images before use
- Only use images from trusted sources
- Check image signatures match expected values
- Monitor for security advisories on included packages

## Package Information

### Desktop Packages

Desktop images include:
- Development tools (Git, Python, Vim, etc.)
- Productivity applications (Geary, Bitwarden, etc.)
- System utilities (btop, iotop, etc.)
- Multimedia support
- Gaming tools (for Bazzite variant)

### Server Packages

Server images include:
- Monitoring tools (cockpit, lm_sensors, etc.)
- Virtualization support (libvirt, QEMU)
- Network utilities (nmap, iperf3)
- Storage management (sanoid, smartmontools)

## Configuration

### Desktop Configuration

- Custom GNOME settings and extensions
- Optimized systemd configurations
- Pre-configured development environment
- Custom directories and symlinks

### Server Configuration

- Optimized for server workloads
- Monitoring and management tools
- Security hardening
- Performance tuning

## Troubleshooting

### Common Issues

**Build failures**: Ensure all dependencies are installed and you have sufficient disk space

**Installation issues**: Verify your system is compatible with rpm-ostree and bootc

**Package conflicts**: Use `dnf distro-sync` to resolve conflicts

**Network issues**: Check your internet connection and DNS configuration

## Support

For issues or questions:
- Check the [GitHub Issues](https://github.com/johnmmcgee/mcos/issues) page
- Review the [Project Bluefin documentation](https://docs.projectbluefin.io/)
- Consult the included packages and their documentation

## License

This project follows the licenses of the upstream Project Bluefin images. See individual package licenses for details.
