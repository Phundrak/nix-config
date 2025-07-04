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

  options.system = with types; {
    amdgpu.enable = mkEnableOption "Enables AMD GPU support";
    boot = {
      kernel = {
        package = mkOption {
          type = raw;
          default = pkgs.linuxPackages_zen;
        };
        modules = mkOption {
          type = listOf str;
          default = [];
        };
        cpuVendor = mkOption {
          description = "Intel or AMD?";
          type = enum ["intel" "amd"];
          default = "amd";
        };
        v4l2loopback = mkOption {
          description = "Enables v4l2loopback";
          type = bool;
          default = true;
        };
        hardened = mkEnableOption "Enables hardened Linux kernel";
      };
      systemd-boot = mkOption {
        type = types.bool;
        default = true;
        description = "Does the system use systemd-boot?";
      };
      plymouth.enable = mkEnableOption "Enables Plymouth";
      zfs = {
        enable = mkEnableOption "Enables ZFS";
        pools = mkOption {
          type = listOf str;
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
        type = str;
        example = "gampo";
      };
      id = mkOption {
        type = str;
        example = "deadb33f";
      };
      domain = mkOption {
        type = nullOr str;
        example = "phundrak.com";
        default = null;
      };
      hostFiles = mkOption {
        type = listOf path;
        example = [/path/to/hostFile];
        default = [];
      };
      firewall = {
        openPorts = mkOption {
          type = listOf int;
          example = [22 80 443];
          default = [];
        };
        openPortRanges = mkOption {
          type = listOf (attrsOf port);
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
          type = nullOr lines;
          example = "iptables -A INPUTS -p icmp -j ACCEPT";
          default = null;
        };
      };
    };
    nix = {
      disableSandbox = mkOption {
        type = bool;
        default = false;
      };
      gc = {
        automatic = mkOption {
          type = bool;
          default = true;
        };
        dates = mkOption {
          type = str;
          default = "Monday 01:00 UTC";
        };
        options = mkOption {
          type = str;
          default = "--delete-older-than 30d";
        };
      };
    };
    sound = {
      enable = mkEnableOption "Whether to enable sounds with Pipewire";
      alsa = mkOption {
        type = bool;
        example = true;
        default = true;
        description = "Whether to enable ALSA support with Pipewire";
      };
      jack = mkOption {
        type = bool;
        example = true;
        default = false;
        description = "Whether to enable JACK support with Pipewire";
      };
      package = mkOption {
        type = package;
        example = pkgs.pulseaudio;
        default = pkgs.pulseaudioFull;
        description = "Which base package to use for PulseAudio";
      };
    };
    users = {
      root.disablePassword = mkEnableOption "Disables root password";
      phundrak = mkOption {
        type = bool;
        default = true;
      };
    };
    timezone = mkOption {
      type = str;
      default = "Europe/Paris";
    };
    console.keyMap = mkOption {
      type = str;
      default = "fr";
    };
  };

  config = {
    boot.tmp.cleanOnBoot = true;
    time.timeZone = cfg.timezone;
    console.keyMap = cfg.console.keyMap;
    modules = {
      boot = {
        inherit (cfg) amdgpu;
        inherit (cfg.boot) kernel systemd-boot plymouth zfs;
      };
      inherit (cfg) sound users networking docker amdgpu;
    };
  };
}
