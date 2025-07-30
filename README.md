# NixOS Configuration

Personal NixOS configuration for my machines, using Nix Flakes for reproducible and shareable setups.

## Repository Structure

- **flake.nix**: Main entry point for the Nix Flake, defining NixOS and home-manager configurations.
- **hosts/**: Contains the host-specific NixOS configurations.
- **system/**: Holds system-wide configuration modules that can be shared across different hosts. This includes things like boot settings, desktop environments, hardware configurations, networking, packages, security, and system services.
- **users/**: Manages user-specific configurations. It's split into `modules` for reusable home-manager configurations and `phundrak` for my personal configuration.
- **keys/**: Public keys for various machines.
- **secrets/**: Encrypted secrets managed with `sops-nix`.

## Usage

### System Management

Update flake dependencies:
```bash
nix flake update
```

Build and switch to a new system configuration:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Using the Nix Helper (nh) tool:
```bash
# Build and activate a new configuration, making it the boot default
nh os switch

# Build a new configuration and make it the boot default
nh os boot

# Build and activate a new configuration (without making it the boot default)
nh os test

# Just build a new configuration
nh os build
```

### Home Configuration

Update and switch to a new home configuration:
```bash
nh home switch
```

Format Nix files (using Alejandra):
```bash
nix fmt .
```

## Contributing

Feel free to fork this repository and make your own changes. If you have any improvements or suggestions, please open an issue or submit a pull request.
