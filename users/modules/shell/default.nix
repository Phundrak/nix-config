{
  config,
  lib,
  ...
}:
with lib; let
  aliases = {
    df = "df -H";
    diskspace = "sudo df -h | grep -E \"sd|lv|Size\"";
    du = "du -ch";
    meminfo = "free -m -l -t";
    gpumeminfo = "grep -i --color memory /var/log/Xorg.0.log";
    cpuinfo = "lscpu";
    pscpu = "ps auxf | sort -nr -k 3";
    pscpu10 = "ps auxf | sort -nr -k 3 | head -10";
    psmem = "ps auxf | sort -nr -k 4";
    psmem10 = "ps auxf | sort -nr -k 4 | head -10";

    s = "systemctl";

    dc = "docker compose";
    dcd = "docker compose down";
    dcl = "docker compose logs";
    dclf = "docker compose logs -f";
    dcp = "docker compose pull";
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcudp = "docker compose up -d --pull=always";
    dcr = "docker compose restart";
    enw = "emacsclient -nw";
    e = "emacsclient -n -c";

    cp = "cp -i";
    rsync = "rsync -Pa --progress";
    ln = "ln -i";
    lns = "ln -si";
    mv = "mv -i";
    rm = "rm -Iv";
    rmd = "rm --preserve-root -Irv";
    rmdf = "rm --preserve-root -Irfv";
    rmf = "rm --preserve-root -Ifv";
    chgrp = "chgrp --preserve-root -v";
    chmod = "chmod --preserve-root -v";
    chown = "chown --preserve-root -v";
    lsl = "eza -halg@ --group-directories-first --git";

    flac = "yt-dlp -x --audio-format flac --audio-quality 0 o \"~/Music/%(uploader)s/%(title)s.%(ext)s\"";
    please = "sudo -A";
    wget = "wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\" -c";
  };
  cfg = config.modules.shell;
in {
  imports = [
    ./bash.nix
    ./fish.nix
    ./starship.nix
    ./zsh.nix
  ];

  options.modules.shell = {
    enableBash = mkOption {
      type = types.bool;
      default = true;
      description = "enables bash";
    };
    enableFish = mkOption {
      type = types.bool;
      default = true;
      description = "enables fish";
    };
    enableZsh = mkOption {
      type = types.bool;
      default = true;
      description = "enables zsh";
    };
    starship = {
      enable = mkEnableOption "Enables the starship prompt.";
      jjIntegration = mkEnableOption "Enables Jujutsu integration in starship.";
    };
    zoxide = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enables zoxide";
      };
      replaceCd = mkOption {
        type = types.bool;
        default = true;
        description = "makes zoxide replace cd";
      };
    };
  };

  config = {
    home.shell = {
      enableFishIntegration = mkDefault cfg.enableFish;
      enableBashIntegration = mkDefault cfg.enableBash;
      enableZshIntegration = mkDefault cfg.enableZsh;
    };

    modules = {
      fish = {
        enable = mkDefault cfg.enableFish;
        abbrs = mkDefault aliases;
      };
      bash = {
        enable = mkDefault cfg.enableBash;
        aliases = mkDefault aliases;
      };
      zsh = {
        enable = mkDefault cfg.enableZsh;
        abbrs = mkDefault aliases;
      };
      inherit (cfg) starship;
    };

    programs.zoxide = mkIf cfg.zoxide.enable {
      enable = true;
      options = mkIf cfg.zoxide.replaceCd [
        "--cmd cd"
      ];
    };
  };
}
