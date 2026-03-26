{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.networking;
in {
  options.mySystem.networking = with types; {
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
    wifi.disablePowersave = mkEnableOption ''
      Disables powersave for Wifi.

        Used mainly for the PineTab2, as leaving WiFi powersave with the bes2600 can cause stability issues.
    '';
  };

  config.networking = {
    hostName = cfg.hostname; # Define your hostname.
    hostId = cfg.id;
    networkmanager = {
      enable = true;
      wifi.powersave = ! cfg.wifi.disablePowersave;
    };
    inherit (cfg) hostFiles domain;
    firewall = {
      enable = true;
      allowedTCPPorts = cfg.firewall.openPorts;
      allowedUDPPorts = cfg.firewall.openPorts;
      allowedTCPPortRanges = cfg.firewall.openPortRanges;
      allowedUDPPortRanges = cfg.firewall.openPortRanges;
      extraCommands = (mkIf (cfg.firewall.extraCommands != null)) cfg.firewall.extraCommands;
    };
  };
}
