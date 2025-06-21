{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system;
in {
  imports = [
    ./amdgpu.nix
    ./appimage.nix
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./plymouth.nix
    ./sound.nix
    ./users.nix
    ./dev/docker.nix
  ];

  options.system = {
    amdgpu.enable = mkEnableOption "Enables AMD GPU support";
    boot = {
      kernel = {
        package = mkOption {
          type = types.raw;
          default = pkgs.linuxPackages_zen;
        };
        modules = mkOption {
          type = types.listOf types.str;
          default = [];
        };
        cpuVendor = mkOption {
          description = "Intel or AMD?";
          type = types.enum ["intel" "amd"];
          default = "amd";
        };
        v4l2loopback = mkOption {
          description = "Enables v4l2loopback";
          type = types.bool;
          default = true;
        };
        hardened = mkEnableOption "Enables hardened Linux kernel";
      };
      plymouth.enable = mkEnableOption "Enables Plymouth";
      zfs = {
        enable = mkEnableOption "Enables ZFS";
        pools = mkOption {
          type = types.listOf types.str;
          default = [];
        };
      };
    };
    docker = {
      enable = mkEnableOption "Enable Docker";
      podman.enable = mkEnableOption "Enable Podman rather than Docker";
      nvidia.enable = mkEnableOption "Activate Nvidia support";
      autoprune.enable = mkEnableOption "Enable autoprune";
    };
    networking = {
      hostname = mkOption {
        type = types.str;
        example = "gampo";
      };
      id = mkOption {
        type = types.str;
        example = "deadb33f";
      };
      hostFiles = mkOption {
        type = types.listOf types.path;
        example = [/path/to/hostFile];
        default = [];
      };
      firewall = {
        openPorts = mkOption {
          type = types.listOf types.int;
          example = [22 80 443];
          default = [];
        };
        openPortRanges = mkOption {
          type = types.listOf (types.attrsOf types.port);
          default = [];
          example = [
            {
              from = 8080;
              to = 8082;
            }
          ];
          description = ''
            A range of TCP and UDP ports on which incoming connections are
            accepted.
          '';
        };
        extraCommands = mkOption {
          type = types.nullOr types.lines;
          example = "iptables -A INPUTS -p icmp -j ACCEPT";
          default = null;
        };
      };
    };
    nix = {
      disableSandbox = mkOption {
        type = types.bool;
        default = false;
      };
      gc = {
        automatic = mkOption {
          type = types.bool;
          default = true;
        };
        dates = mkOption {
          type = types.str;
          default = "Monday 01:00 UTC";
        };
        options = mkOption {
          type = types.str;
          default = "--delete-older-than 30d";
        };
      };
    };
    sound = {
      enable = mkEnableOption "Whether to enable sounds with Pipewire";
      alsa = mkOption {
        type = types.bool;
        example = true;
        default = true;
        description = "Whether to enable ALSA support with Pipewire";
      };
      jack = mkOption {
        type = types.bool;
        example = true;
        default = false;
        description = "Whether to enable JACK support with Pipewire";
      };
      package = mkOption {
        type = types.package;
        example = pkgs.pulseaudio;
        default = pkgs.pulseaudioFull;
        description = "Which base package to use for PulseAudio";
      };
    };
    users = {
      root.disablePassword = mkEnableOption "Disables root password";
      phundrak = mkOption {
        type = types.bool;
        default = true;
      };
    };
    timezone = mkOption {
      type = types.str;
      default = "Europe/Paris";
    };
    console.keyMap = mkOption {
      type = types.str;
      default = "fr";
    };
  };

  config = {
    time.timeZone = cfg.timezone;
    console.keyMap = cfg.console.keyMap;
    modules = {
      boot = {
        inherit (cfg) amdgpu;
        inherit (cfg.boot) kernel plymouth zfs;
      };
      inherit (cfg) sound users networking docker amdgpu;
    };
  };
}
