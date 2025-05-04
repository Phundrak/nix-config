{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.networking;
in {
  options.modules.networking = {
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

  config.networking = {
    hostName = cfg.hostname; # Define your hostname.
    hostId = cfg.id;
    networkmanager.enable = true;
    inherit (cfg) hostFiles;
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
