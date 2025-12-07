{
  config,
  lib,
  ...
}:
with lib; let
  defaultAliases = {
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
    ss = "systemctl status";
    sst = "systemctl stop";
    sr = "systemctl restart";
    sre = "systemctl reload";
    se = "systemctl enable";
    sen = "systemctl enable --now";
    su = "systemctl --user";
    sus = "systemctl --user status";
    sust = "systemctl --user stop";
    sur = "systemctl --user restart";
    sure = "systemctl --user reload";
    sue = "systemctl --user enable";
    suen = "systemctl --user enable --now";

    dc = "docker compose";
    dcd = "docker compose down";
    dcl = "docker compose logs";
    dclf = "docker compose logs -f";
    dcp = "docker compose pull";
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcudp = "docker compose up -d --pull=always";
    dcr = "docker compose restart";
    pc = "podman compose";
    pcd = "podman compose down";
    pcl = "podman compose logs";
    pclf = "podman compose logs -f";
    pcp = "podman compose pull";
    pcu = "podman compose up";
    pcud = "podman compose up -d";
    pcudp = "podman compose up -d --pull=always";
    pcr = "podman compose restart";

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
  cfg = config.home.shell;
in {
  imports = [
    ./bash.nix
    ./fish.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
    ./zoxide.nix
  ];
  options.home.shell = {
    fullDesktop = mkEnableOption "Enable all shells";
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {la = "ls -a";};
    };
  };
  config.home.shell = {
    enableShellIntegration = cfg.bash.enable or cfg.zsh.enable or cfg.fish.enable;
    bash = {
      aliases = cfg.aliases // defaultAliases;
      enable = mkDefault cfg.fullDesktop;
    };
    fish = {
      abbrs = cfg.aliases // defaultAliases;
      enable = mkDefault cfg.fullDesktop;
    };
    zsh = {
      abbrs = cfg.aliases // defaultAliases;
      enable = mkDefault cfg.fullDesktop;
    };
  };
}
