{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.media.mopidy;
in {
  options.home.media.mopidy = {
    enable = mkEnableOption "Enables Mopidy.";
  };

  config.services.mopidy = mkIf cfg.enable {
    inherit (cfg) enable;
    extensionPackages = with pkgs; [
      mopidy-bandcamp
      mopidy-mpd
      mopidy-mpris
      mopidy-muse
      mopidy-notify
      mopidy-spotify
    ];
    extraConfigFiles = [
      config.sops.secrets."mopidy/bandcamp".path
      config.sops.secrets."mopidy/spotify".path
    ];
    settings = {
      mpd = {
        enabled = true;
        hostname = "::";
        port = 6600;
      };
      mpris.enabled = true;
      muse = {
        enabled = true;
        mopidy_host = "localhost";
        mopidy_port = 6690;
        mopidy_ssl = false;
        snapcast_host = "localhost";
        snapcast_port = 1780;
        snapcast_ssl = false;
      };
    };
  };
}
