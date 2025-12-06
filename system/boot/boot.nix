{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.boot;
in {
  options.mySystem.boot = {
    extraModprobeConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
      '';
    };
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
    systemd-boot = mkOption {
      type = types.bool;
      default = !cfg.grub.enable;
      description = "Does the system use systemd-boot?";
    };
    grub = {
      enable = mkEnableOption "Does the system use GRUB? (Disables systemd-boot)";
      device = mkOption {
        type = types.str;
        description = "The GRUB device";
        default = "";
      };
    };
    zfs = {
      enable = mkEnableOption "Enables ZFS";
      pools = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config.boot = {
    initrd.kernelModules = lists.optional config.mySystem.hardware.amdgpu.enable "amdgpu";
    loader = {
      systemd-boot.enable = cfg.systemd-boot;
      efi.canTouchEfiVariables = cfg.systemd-boot;
      grub = mkIf cfg.grub.enable {
        inherit (cfg.grub) enable device;
      };
    };
    supportedFilesystems = mkIf cfg.zfs.enable ["zfs"];
    zfs.extraPools = mkIf cfg.zfs.enable cfg.zfs.pools;
    kernelPackages =
      if cfg.kernel.hardened
      then pkgs.linuxPackages_hardened
      else cfg.kernel.package;
    kernelModules =
      cfg.kernel.modules
      ++ ["kvm-${cfg.kernel.cpuVendor}"]
      ++ lists.optional cfg.kernel.v4l2loopback "v4l2loopback"
      ++ lists.optional cfg.kernel.hardened "tcp_bbr";
    kernel.sysctl = mkIf cfg.kernel.hardened {
      "kernel.sysrq" = 0; # Disable magic SysRq key
      # Ignore ICMP broadcasts to avoid participating in Smurf attacks
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      # Ignore bad ICMP errors
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # SYN flood protection
      "net.ipv4.tcp_syncookies" = 1;
      # Do not accept ICMP redirects (prevent MITM attacks)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default_accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      # Do not send ICMP redirects (we are not a router)
      "net.ipv4.conf.all.send_redirects" = 0;
      # Do not accept IP source route packets (we are not a router)
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # Protect against tcp time-wait assassination hazards
      "net.ipv4.tcp_rfc1337" = 1;
      # Latency reduction
      "net.ipv4.tcp_fastopen" = 3;
      # Bufferfloat mitigations
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };
  };
}
