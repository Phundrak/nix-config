# NixOS Configuration

Personal NixOS configuration for my machines, using Nix Flakes for reproducible and shareable setups.

## Repository Structure

- **flake.nix**: Main entry point for the Nix Flake, defining NixOS and home-manager configurations
- **hosts/**: Host-specific NixOS configurations
- **modules/**: Custom NixOS modules reusable across different hosts
- **programs/**: System-level programs shared across hosts
- **secrets/**: Encrypted secrets managed with sops-nix
- **system/**: Common system-level configurations shared across hosts
- **users/phundrak/**: Home-manager configuration for my user
- **users/modules/**: Custom user modules reusable across configurations

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
nix fmt
```

## Development

For development, a devShell is provided with linting tools and git hooks:

```bash
nix develop
```

This will set up an environment with:
- alejandra (formatting)
- commitizen (commit messages)
- deadnix (dead code detection)
- statix (linting)
- Other useful git hooks

## Contributing

Feel free to fork this repository and make your own changes. If you have any improvements or suggestions, please open an issue or submit a pull request.
