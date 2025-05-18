{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
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
    enable = mkEnableOption "enables Emacs";
    package = mkOption {
      type = types.package;
      default = emacsDefaultPackage;
    };
    service = mkEnableOption "enables Emacs service";
    mu4eMime = mkEnableOption "Enables mu4e to handle mailto scheme";
    org-protocol = mkEnableOption "Enables org-protocol";
  };

  config = {
    programs.emacs = mkIf cfg.enable {
      enable = true;
      inherit (cfg) package;
    };
    services.emacs = mkIf cfg.service {
      enable = true;
      inherit (cfg) package;
      startWithUserSession = "graphical";
    };

    xdg.desktopEntries.mu4e = mkIf cfg.mu4eMime {
      name = "mu4e";
      genericName = "mu4e";
      comment = "Maildir Utils for Emacs";
      mimeType = ["x-scheme-handler/mailto"];
      noDisplay = true;
      exec = "${cfg.package}/bin/emacsclient -c -n -a ${cfg.package}/bin/emacs -e \"(browse-url-mail \\\"\\$*\\\")\"";
      terminal = false;
      categories = ["Network" "Email" "TextEditor" "Utility"];
    };

    xdg.desktopEntries.org-protocol = mkIf cfg.org-protocol {
      name = "org-protocol";
      exec = "${cfg.package}/bin/emacsclient -c -n -a ${cfg.package}/bin/emacs %u";
      terminal = false;
      noDisplay = true;
      categories = ["System"];
      mimeType = ["x-scheme-handler/org-protocol"];
    };
  };
}
