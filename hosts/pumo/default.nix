# Minimal configuration for OnePlus 6 (enchilada) NixOS Mobile
# Focus on essentials: SSH, wireless, and basic tools
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../system
  ];

  nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"];

  mySystem = {
    desktop = {
      hyprland.enable = true;
      niri.enable = true;
      waydroid.enable = true;
      xserver = {
        enable = true;
        de = "gnome";
      };
    };
    dev.docker = {
      enable = true;
      podman.enable = true;
      autoprune.enable = true;
    };
    hardware = {
      bluetooth.enable = true;
      sound = {
        enable = true;
        usePulseaudio = true;
      };
    };
    i18n.input.enable = true;
    misc = {
      keymap = "fr-bepo";
      mobile = true;
    };
    networking = {
      hostname = "pumo";
      id = "93595b88";
    };
    packages = {
      appimage.enable = true;
      flatpak.enable = true;
      nix.nix-ld.enable = true;
    };
    services = {
      languagetool.enable = true;
      printing.enable = true;
      ssh.enable = true;
    };
    users = {
      root.disablePassword = true;
      phundrak = {
        enable = true;
        trusted = true;
        extraGroups = ["feedbackd"];
      };
    };
  };

  programs = {
    dconf.enable = true;
    calls.enable = true;
    zsh.enable = true;
  };


  hardware.sensor.iio.enable = true;

  # Minimal essential packages
  environment.systemPackages = with pkgs; [
    chatty # IM and SMS
    epiphany
    nixd
    git
    vim
    emacs
    wget
    curl
    jujutsu
    firefox
    kitty
  ];

  system.stateVersion = "25.11";
}
