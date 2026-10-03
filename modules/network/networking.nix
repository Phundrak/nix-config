{...}: {
  flake.modules.nixos.networking = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.networking;
    in {
      options.mySystem.networking.hostname = mkOption {
        type = types.str;
        example = "gampo";
      };
      config.networking.hostName = cfg.hostname;
      options.mySystem.networking.id = mkOption {
        type = types.str;
        example = "deadb33f";
      };
      config.networking.hostId = cfg.id;
      options.mySystem.networking.domain = mkOption {
        type = types.nullOr types.str;
        example = "phundrak.com";
        default = null;
      };
      config.networking.domain = cfg.domain;
      options.mySystem.networking.hostFiles = mkOption {
        type = types.listOf types.path;
        example = [/path/to/hostFile];
        default = [];
      };
      config.networking.hostFiles = cfg.hostFiles;
      options.mySystem.networking.wifi.disablePowersave = mkEnableOption ''
        Disables powersave for Wifi.

          Used mainly for the PineTab2, as leaving WiFi powersave with the bes2600 can cause stability issues.
      '';
      config.networking.networkmanager = {
        enable = true;
        wifi.powersave = !cfg.wifi.disablePowersave;
      };
      options.mySystem.networking.firewall.openPorts = mkOption {
        type = types.listOf types.int;
        example = [22 80 443];
        default = [];
      };
      config.networking.firewall = {
        enable = true;
        allowedTCPPorts = cfg.firewall.openPorts;
        allowedUDPPorts = cfg.firewall.openPorts;
      };
      options.mySystem.networking.firewall.openPortRanges = mkOption {
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
      config.networking.firewall = {
        allowedTCPPortRanges = cfg.firewall.openPortRanges;
        allowedUDPPortRanges = cfg.firewall.openPortRanges;
      };
      options.mySystem.networking.firewall.extraCommands = mkOption {
        type = types.nullOr types.lines;
        example = "iptables -A INPUTS -p icmp -j ACCEPT";
        default = null;
      };
      config.networking.firewall.extraCommands = mkIf (cfg.firewall.extraCommands != null) cfg.firewall.extraCommands;
    };
}
