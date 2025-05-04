{
  pkgs,
  config,
  lib,
  ...
}: let
  emacsDefaultPackage = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (
    epkgs: [
      epkgs.vterm
      epkgs.mu4e
      epkgs.pdf-tools
    ]
  ));
  cfg = config.modules.emacs;
in {
  options.modules.emacs = {
    enable = lib.mkEnableOption "enables Emacs";
    package = lib.mkOption {
      type = lib.types.package;
      default = emacsDefaultPackage;
    };
    service = lib.mkEnableOption "enables Emacs service";
  };

  config = {
    programs.emacs = lib.mkIf cfg.enable {
      enable = true;
      inherit (cfg) package;
    };
    services.emacs = lib.mkIf cfg.service {
      enable = true;
      inherit (cfg) package;
      startWithUserSession = "graphical";
    };
  };
}
