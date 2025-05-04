{
  imports = [../../programs/hyprland.nix];
  modules.hyprland = {
    enable = true;
    config = builtins.readFile ./config/hypr/hyprland.conf;
    waybar.style = ./config/waybar/style.css;
  };
}
