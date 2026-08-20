{
  flake.modules.nixos.steam = {pkgs, ...}: {
    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = true;
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
    hardware.steam-hardware.enable = true;
  };
}
