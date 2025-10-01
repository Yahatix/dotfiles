# NixOS Dotfiles Configuration Guide

This is a NixOS flake-based configuration managing multiple hosts with Home Manager integration.

## Architecture Overview

### Flake Structure

- **`flake.nix`**: Entry point defining inputs (nixpkgs stable/unstable, home-manager) and outputs (nixosConfigurations, homeConfigurations)
- **`hosts/`**: Per-host configurations
  - `ocm285/`: Desktop workstation (Intel+NVIDIA, Budgie+COSMIC desktops, development setup)
  - `strato/`: Server configuration (minimal, SSH-accessible, Docker-enabled)

### Key Patterns

**Dual Package Sources**: Use `pkgs` for stable packages, `unstable` for bleeding-edge. Pattern: `unstable.packageName` for newer versions.

**Host-Specific Structure**: Each host has:

- `configuration.nix`: System-level NixOS config
- `hardware-configuration.nix`: Hardware-specific settings (auto-generated)
- `home.nix`: User-level Home Manager config (ocm285 only)

**Environment Variables**: Both system and home configs set:

```nix
FLAKE = "/home/tim/.dotfiles";
NH_FLAKE = "/home/tim/.dotfiles";
```

## Development Workflows

### Building & Switching

```bash
# Rebuild system configuration
nh os switch

# Update home configuration
nh home switch
```

## Configuration Conventions

### Desktop Managers

Multiple desktop environments configured:

```nix
services.xserver.desktopManager.budgie.enable = true;
services.desktopManager.cosmic.enable = true;  # Wayland-based
```

### Virtualization Stack

Comprehensive setup: Docker, libvirtd/QEMU

### Package Installation Methods

1. **System packages**: `environment.systemPackages`
2. **User packages**: `home.packages` (in home.nix)
3. **Custom derivations**: AppImage wrapping pattern for FreeShow, Docker Desktop
4. **Flatpak integration**: Enabled with flathub auto-setup

### Hardware-Specific Features

- **NVIDIA**: Prime sync for Intel+NVIDIA hybrid graphics
- **Input devices**: Wooting keyboard, Wacom tablet support
- **Printing**: Brother printer drivers, scanner support

## File Editing Guidelines

- **Never modify** `hardware-configuration.nix` (auto-generated)
- **System changes**: Edit `hosts/*/configuration.nix`
- **User applications**: Edit `hosts/*/home.nix`
- **New hosts**: Create new directory under `hosts/` and add to flake.nix outputs
- **Formatting**: Use `nixfmt-rfc-style` (installed in both configs)

## Special Considerations

- **Unfree packages**: Explicitly allowed via `nixpkgs.config.allowUnfree = true`
- **Flake inputs**: Pin to specific branches (nixos-25.05, release-25.05)
- **State version**: Keep at "24.11" unless major system changes
- **Auto-updates**: Enabled via `system.autoUpgrade.enable = true`
