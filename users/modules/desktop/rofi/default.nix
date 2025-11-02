{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.desktop.rofi;
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  options.home.desktop.rofi = {
    enable = mkEnableOption "Enable Rofi";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [rofi-bluetooth];
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
      ];
      terminal = "${pkgs.kitty}/bin/kitty";
      location = "center";
      modes = ["drun" "emoji" "calc" "combi"];
      extraConfig.show-icons = true;
      theme = {
        "*" = {
          font = "Cascadia Code 14";
          blur = true;
          padding = mkLiteral "10px";
          background-color = mkLiteral "transparent";
          border-radius = mkLiteral "0px";
        };
        window = {
          width = mkLiteral "1050px";
          height = mkLiteral "625px";
          location = mkLiteral "center";
          blur = true;
          border = mkLiteral "2px";
          border-radius = mkLiteral "3px";
          border-color = mkLiteral "#61afef";
          background-color = mkLiteral "transparent";
          padding = mkLiteral "0px";
          margin = mkLiteral "30px 50px";
        };
        mainbox = {
          orientation = mkLiteral "horizontal";
          children = map mkLiteral ["borderbox"];
          spacing = mkLiteral "0px";
          padding = mkLiteral "0px";
        };
        borderbox = {
          orientation = mkLiteral "horizontal";
          children = map mkLiteral ["imagebox" "contentbox"];
          padding = mkLiteral "0px";
          spacing = mkLiteral "0px";
          border-radius = mkLiteral "3px";
        };
        contentbox = {
          orientation = mkLiteral "vertical";
          children = map mkLiteral ["entry" "listview"];
          spacing = mkLiteral "0px";
          padding = mkLiteral "0px";
          expand = true;
        };
        imagebox = {
          background-image = mkLiteral "url(\"${./image.jpg}\")";
          background-repeat = false;
          size = mkLiteral "200px 625px";
        };
        element = {
          border-radius = mkLiteral "0px";
        };
        "element-text, element-icon" = {
          padding = mkLiteral "6px 8px";
          spacing = mkLiteral "2px";
          text-color = mkLiteral "#fab387";
        };
        "element selected" = {
          background-color = mkLiteral "#191919";
          text-color = mkLiteral "#e5c07b";
          border-radius = mkLiteral "3px";
        };
        prompt = {
          enabled = false;
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "#61afef";
          padding = mkLiteral "5px 10px";
        };
        entry = {
          padding = mkLiteral "8px";
          expand = false;
          font = "Cascadia Code 14";
          text-color = mkLiteral "#fab387";
          border-radius = mkLiteral "0px 3px 0px 0px";
          background-color = mkLiteral "#292e36";
        };
        listview = {
          lines = mkLiteral "1";
          background-color = mkLiteral "rgba(46, 52, 64, 0.8)";
          border-radius = mkLiteral "0px 0px 3px 0px";
          padding = mkLiteral "5px";
        };
      };
    };
  };
}
