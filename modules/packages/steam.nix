{
  flake.modules.nixos.steam = {pkgs, ...}: {
    programs.steam.enable = true;
    programs.steam.protontricks.enable = true;
    programs.steam.remotePlay.openFirewall = true;
    programs.steam.localNetworkGameTransfers.openFirewall = true;
    
    programs.steam.extraCompatPackages = [pkgs.proton-ge-bin];
    programs.steam.package = pkgs.steam.override {
      extraEnv = {
        OBS_VKCAPTURE = true;
        RADV_TEX_ANISO = 16;
      };
      extraLibraries = p: with p; [atk];
      extraPkgs = pkgs:
        with pkgs; [
          qt5.qtmultimedia
          qt5.qtbase
          libpulseaudio
        ];
    };
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
    hardware.steam-hardware.enable = true;
  };
}
