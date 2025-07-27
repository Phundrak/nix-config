{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.desktop.obs;
in {
  options.home.desktop.obs.enable = mkEnableOption "Enables OBS Studio";
  config.programs.obs-studio = mkIf cfg.enable {
    inherit (cfg) enable;
    plugins = with pkgs.obs-studio-plugins; [
      input-overlay
      obs-backgroundremoval
      obs-mute-filter
      obs-pipewire-audio-capture
      obs-source-clone
      obs-source-record
      obs-tuna
    ];
  };
}
