{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.programs.steam;
in {
  options.system.programs.steam.enable = mkEnableOption "Enables Steam and Steam hardware";
  config = mkIf cfg.enable {
    programs = {
      steam = {
        inherit (cfg) enable;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
    };
    hardware.steam-hardware = {
      inherit (cfg) enable;
    };
  };
}
