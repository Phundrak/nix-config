{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.sound;
in {
  options.modules.sound = {
    enable = mkEnableOption "Whether to enable sounds with Pipewire";
    alsa = mkOption {
      type = types.bool;
      example = true;
      default = true;
      description = "Whether to enable ALSA support with Pipewire";
    };
    jack = mkOption {
      type = types.bool;
      example = true;
      default = false;
      description = "Whether to enable JACK support with Pipewire";
    };
    package = mkOption {
      type = types.package;
      example = pkgs.pulseaudio;
      default = pkgs.pulseaudioFull;
      description = "Which base package to use for PulseAudio";
    };
  };

  config.services.pipewire = mkIf cfg.enable {
    enable = true;
    alsa = mkIf cfg.alsa {
      enable = mkDefault true;
      support32Bit = mkDefault true;
    };
    jack.enable = mkDefault cfg.jack;
  };
}
